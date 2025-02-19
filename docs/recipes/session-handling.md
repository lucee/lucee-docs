<!--
{
  "title": "Session Handling in Lucee",
  "id": "session-handling",
  "related": [
    "application-cfc",
    "request-handling",
    "caching"
  ],
  "categories": [
    "server",
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

This document explains how session handling works in Lucee and covers configuration options, storage mechanisms, and security considerations.

## Type
Lucee allows use of 2 types of sessions:
-  "jee" - The session provided and managed by the ServletEngine, also known as "JSession"
- "cfml" - The Sessions provided and managed by Lucee

You can define the type used in the Lucee Administrator or .CFConfig.json like this:
```json
{
  "sessionType": "cfml"
}
```
and overwrite it in the Application.cfc like this:
```javascript
this.sessionType="cfml";
```

This document only addresses session type "cfml". For "jee" (Servlet Engine Session) please see the [Java EE Session Documentation](https://docs.oracle.com/cd/B31017_01/web.1013/b28959/sessions.htm#:~:text=When%20a%20servlet%20creates%20an,pair%20constitutes%20a%20session%20attribute).

## Enable Sessions

You can enable session management in the Lucee Administrator or .CFConfig.json like this:
```json
{
  "sessionManagement": true
}
```

and overwrite it in the Application.cfc like this:
```javascript
this.sessionManagement=true;
```
By default, sessions are enabled.

## (Idle)Timeout
You can set the default session idle timeout in the Lucee Administrator or .CFConfig.json like this:
```json
{
  "sessionTimeout": "0,0,30,0"
}
```

The timeout format "0,0,30,0" represents days,hours,minutes,seconds. You can set it in the Application.cfc using different approaches:
```javascript
// Different ways to set a 30-minute timeout
this.sessionTimeout=createTimeSpan(0,0,30,0); // using createTimeSpan
this.sessionTimeout=1/24/2;                   // using day fractions
```

## Storage
Lucee allows defining storage for sessions. By default, this is "memory", meaning the session is stored in memory for its full life cycle.

You can set the default session storage in the Lucee Administrator or .CFConfig.json like this:
```json
{
  "sessionStorage": "memory"
}
```
and overwrite it in the Application.cfc like this:
```javascript
this.sessionStorage="memory";
```

For any setting other than "memory", the session is only stored up to a minute (idle) in memory, after which it is removed from memory and loaded again from storage on demand.

The following storage options are available:

- "memory" - Stores session data in server memory for the full life cycle. Best for single-server deployments.
- "cookie" - Stores session data in the user's browser cookies. Should be avoided for security reasons and limited by cookie size restrictions.
- "file" - Stores session data in local files. Good for development but may cause issues in clustered environments.
- [datasource-name] - Name of an existing datasource. Session data is stored in a table named "cf_session_data". Lucee automatically creates this table if it doesn't exist. Suitable for clustered environments.
- [cache-name] - Name of an existing cache (e.g., Redis, Memcached). Ideal for distributed systems requiring high performance.

Lucee does not store "empty" sessions (sessions containing only default keys) into storage to optimize resource usage.

### Distributed Storage
When using a cache or datasource as storage, you can configure how data synchronization works between local memory and storage.

Configure the default session distribution mode in the Lucee Administrator or .CFConfig.json:
```json
{
  "sessionCluster": false
}
```
and overwrite it in the Application.cfc:
```javascript
this.sessionCluster=false;
```

If set to `false`, local memory acts as the primary storage point:
- Session data in local memory is considered authoritative
- Storage is only updated when data is modified
- Optimal for single-server deployments
- Minimizes storage requests

If set to `true`, external storage acts as the primary source of truth:
- Session data is verified against storage at request start
- Ensures data consistency across multiple servers
- Recommended for clustered environments
- May increase storage I/O

## Event Handlers
Lucee provides event handlers in Application.cfc for session management:

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

### Invalidate
The `SessionInvalidate()` function immediately terminates the current session and removes all associated data:

```javascript
// During logout
public void function logout() {
    // Log user activity before invalidating
    logUserActivity(session.user.id, "logout");
    
    SessionInvalidate();
    // All session variables are now cleared
    
    location(url="login.cfm", addToken=false);
}
```

### Rotate
The `SessionRotate()` function creates a new session and copies existing data to it while invalidating the old session:

```javascript
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
The Session is linked with help of the key "CFID" that can be in the URL of the cookie of the user (the key "CFTOKEN" is not used by Lucee and only exists for compatibility with other CFML engines). 
Lucee first checks for "CFID" in the URL and only if not exists in the URL it looks for it in the cookie scope.

Since Lucee 6.1, Lucee only accepts the key in the URL in case it has active sessions in memory with that key.
So in case you are using a storage (not "memory"), this is only up to a minute.

Since Lucee 6.1 you can completely block the use of CFID in the url by setting the following system property
```properties
 -Dlucee.read.cfid.from.url=false
```
or environment variable
```bash
 LUCEE_READ_CFID_FROM_URL=false
```

### Client Identification in CFID
Lucee can enhance session security by embedding client information within the CFID. This feature helps prevent session hijacking by making it harder for one client to use another client's CFID.

Enable this feature using either system property:
```properties
-Dlucee.identify.client=true
```
or environment variable:
```bash
LUCEE_IDENTIFY_CLIENT=true
```

When enabled:
- The CFID includes a unique client identifier based on the client's characteristics (e.g., User-Agent)
- A session created for Client A cannot easily be used by Client B
- Maintains backward compatibility with older CFID patterns
- Sessions remain valid when downgrading Lucee versions

The client identification is derived from:
1. User-Agent header
2. If not available, falls back to accept header
3. If no identifying information is available, reverts to standard CFID generation


## Best Practices

Lucee tries to avoid creating sessions whenever possible. It only creates a session when:
- Session data is read or written in the code
- A key in the session scope is checked
- The Application.cfc contains session listeners like "onSessionStart" or "onSessionEnd"

Best practices for session handling:
1. Avoid unnecessary session creation by only accessing the session scope when needed
2. Use appropriate storage mechanisms based on your deployment architecture
3. Consider security implications when choosing between URL and cookie-based session tracking
4. Implement session rotation after authentication state changes
5. Set appropriate timeout values based on your application's requirements

Since Lucee 6.2, empty sessions are only kept for up to a minute, independent of the storage used, to optimize resource usage.