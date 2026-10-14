<!--
{
  "title": "Session Handling in Lucee",
  "id": "session-handling",
  "related": [
    "tag-application",
    "function-sessionexists",
    "function-sessioninvalidate",
    "function-sessionrotate"
  ],
  "categories": [
    "server",
    "session",
    "cache",
    "state-management",
    "configuration"
  ],
  "description": "Comprehensive guide on session handling and configuration in Lucee, including session types, storage options, and security considerations.",
  "keywords": [
    "Session Management",
    "CFML Sessions",
    "JEE Sessions",
    "Session Storage",
    "Session Security",
    "Session Timeout",
    "Session Clustering",
    "State Management"
  ]
}
-->

# Session Handling

How session handling works in Lucee - configuration, storage, and security.

## Type

Lucee supports 2 session types:

- `jee` - managed by the Servlet Engine (JSession)
- `cfml` - managed by Lucee

Configure in `.CFConfig.json`:

```json
{
  "sessionType": "cfml"
}
```

Or in `Application.cfc`:

```javascript
this.sessionType="cfml";
```

This doc covers `cfml` sessions only. For `jee`, see the [Java EE Session Documentation](https://docs.oracle.com/cd/B31017_01/web.1013/b28959/sessions.htm).

## Enable Sessions

`.CFConfig.json`:

```json
{
  "sessionManagement": true
}
```

Or `Application.cfc`:

```javascript
this.sessionManagement=true;
```

Sessions are enabled by default.

## (Idle)Timeout

`.CFConfig.json`:

```json
{
  "sessionTimeout": "0,0,30,0"
}
```

Format is `days,hours,minutes,seconds`. In `Application.cfc`:

```javascript
// Different ways to set a 30-minute timeout
this.sessionTimeout=createTimeSpan(0,0,30,0); // using createTimeSpan
this.sessionTimeout=1/24/2;                   // using day fractions
```

## Storage

Default is `memory` - session stored in memory for its full life cycle.

`.CFConfig.json`:

```json
{
  "sessionStorage": "memory"
}
```

Or `Application.cfc`:

```javascript
this.sessionStorage="memory";
```

For non-memory storage, sessions are kept in memory up to a minute (idle), then removed and loaded from storage on demand.

Storage options:

- `memory` - server memory, best for single-server
- `cookie` - browser cookies. **Removed in Lucee 7.** Avoid for security reasons.
- `file` - local files. Good for dev, not for clusters.
- `[datasource-name]` - stores in `cf_session_data` table (auto-created). Requires `storage=true` on datasource.
- `[cache-name]` - e.g. Redis, Memcached. Ideal for distributed systems.

Empty sessions (only default keys) aren't written to storage.

### Distributed Storage

Configure how data syncs between local memory and storage.

`.CFConfig.json`:

```json
{
  "sessionCluster": false
}
```

Or `Application.cfc`:

```javascript
this.sessionCluster=false;
```

`false` - local memory is authoritative:

- Storage only updated when data changes
- Best for single-server
- Minimizes storage I/O

`true` - external storage is source of truth:

- Session verified against storage at request start
- Ensures consistency across servers
- Use for clustered environments

## Event Handlers

`Application.cfc` event handlers:

```javascript
// Called when a new session is created
public void function onSessionStart() {
    // Initialize session variables
    session.created = now();
    session.lastAccessed = now();
}

// Called when a session ends (timeout or invalidation)
public void function onSessionEnd(required struct sessionScope,
                                required struct applicationScope) {
    // Clean up resources
    var userId = sessionScope.user?.id ?: "unknown";
    application.logger.info("Session ended for user #userId#");
}
```

## Session Management Functions

### Checking if a session exists

Use [[function-sessionExists]] to check if a session exists (since 6.2.1).

Note: [[function-structKeyExists]] on the `session` scope triggers creating an empty session.

### Invalidating a session

[[function-sessionInvalidate]] terminates the session and removes all data. Useful for logout:

```cfml
// During logout
public void function logout() {
    // Log user activity before invalidating
    logUserActivity(session.user.id, "logout");

    SessionInvalidate();
    // All session variables are now cleared

    location(url="login.cfm", addToken=false);
}
```

### Rotating session cookies

[[function-sessionRotate]] creates a new session with fresh token, copies existing data, invalidates old token. Prevents session fixation:

```cfml
// After successful authentication
if (authentication.success) {
    // Create new session to prevent session fixation
    SessionRotate();

    // Set session data with new session ID
    session.user = userDetails;
    session.authenticated = true;
    session.lastLogin = now();
}
```

## Security

Sessions are linked via `CFID` (in URL or cookie). `CFTOKEN` exists only for ACF compatibility.

Lucee checks URL first, then cookies. Since 6.1, URL-based CFID only accepted if session is active in memory (up to 1 minute with non-memory storage).

Block CFID in URL entirely (since 6.1):

```properties
-Dlucee.read.cfid.from.url=false
```

or:

```bash
LUCEE_READ_CFID_FROM_URL=false
```

### Client Identification in CFID

Embed client info in CFID to prevent session hijacking:

```properties
-Dlucee.identify.client=true
```

or:

```bash
LUCEE_IDENTIFY_CLIENT=true
```

When enabled:

- CFID includes client identifier (based on User-Agent, or Accept header as fallback)
- Session from Client A can't easily be used by Client B
- Backward compatible with older CFID patterns

## Session Change Detection

Memory-only sessions don't need change detection.

With `sessionCluster=true` or external storage, Lucee tracks changes to know when to update storage. With `sessionCluster=false`, memory is authoritative - external storage is just backup.

At request end, dirty sessions are written to storage. Empty sessions (no user-defined vars) aren't written - avoid [[function-StructKeyExists]], use [[function-sessionexists]] instead.

Use [[function-sessionCommit]] to force immediate write during request.

Prior to 6.2.4, change detection only checked top-level values. Nested changes or component changes weren't detected.

**Avoid storing components in session** - expensive to serialize/deserialize per request. Instead, store simple values and use a component wrapper that reads from session properties.

## Best Practices

Lucee tries to avoid creating sessions whenever possible. It only creates a session when:

- Session data is read or written in the code
- A key in the session scope is checked
- The Application.cfc contains session listeners like "onSessionStart" or "onSessionEnd"

Use [[function-sessionexists]] to check if a session has been created, using [[function-structkeyexists]] will create a session.

Best practices for session handling:

1. Avoid unnecessary session creation by only accessing the session scope when needed
2. Use appropriate storage mechanisms based on your deployment architecture
3. Consider security implications when choosing between URL and cookie-based session tracking
4. Implement session rotation after authentication state changes
5. Set appropriate timeout values based on your application's requirements
6. Avoid storing components in the session scope, store simple values

Since Lucee 6.2, empty sessions are only kept for up to a minute, independent of the storage used, to optimize resource usage.

# Troubleshooting Sessions

Lucee has a `scope.log` which when set to **DEBUG** (default is ERROR) logs detailed session handling information.

See [[troubleshooting]] for a guide on how to run Lucee with logging to the console.

Expired sessions aren't immediately purged - they're cleaned up by the background controller periodically. For testing short-term session expiry, use `admin action="purgeExpiredSessions"` ([LDEV-4819](https://luceeserver.atlassian.net/browse/LDEV-4819)).

```
<cfadmin action="purgeExpiredSessions"
		type="server"
		password="#password#">
```