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
You can define the type used in the Lucee Administrator or .CFConfig.json like this
```json
{
  "sessionType": "cfml"
}
```
 and overwrite it in the Application.cfc like this
```javascript
this.sessionType="cfml";
```

This document only addresses session type "cfml" , for "jee" (Servlet Engine Session) please see for example
https://docs.oracle.com/cd/B31017_01/web.1013/b28959/sessions.htm#:~:text=When%20a%20servlet%20creates%20an,pair%20constitutes%20a%20session%20attribute.

## Enable Sessions

You can enable session management in the Lucee Administrator or .CFConfig.json like this
```json
{
  "sessionManagement": true
}
```

 and overwrite it in the Application.cfc like this
```javascript
this.sessionManagement=true;
```
By default sessions are enabled

## (Idle)Timeout
You can set the default session idle timeout in the Lucee Administrator or .CFConfig.json like this
```json
{
  "sessionTimeout": "0,0,30,0"
}
```

 by default it is 30 minutes.
 and overwrite it in the Application.cfc like this
```javascript
this.sessionTimeout=createTimeSpan(0,0,30,0); // 30 minutes
this.sessionTimeout=1/24/2; // 30 minutes
```

## Storage
Lucee allows to define a storage for sessions, by default this is "memory", what means that the session is simply stored in memory for the full life cycle of the session.
You can set the default session storage in the Lucee Administrator or .CFConfig.json like this
```json
{
  "sessionStorage": "memory"
}
```
 and overwrite it in the Application.cfc like this
```javascript
this.sessionStorage="memory";
```

for any other setting than "memory", the session is only stored up to a minute (idle) in memory, after that it is removed from memory and loaded again from the storage on demand.

The following settings are possible:
- "memory" - simply store in memory for the full life cycle
- "cookie" - stored in the cookie of the user (should be avoided from a security perspective)
- "file" - stored in a local file 
- <datasource-name> - name of an existing datasource, the session get stored in a table with name "cf_session_data" in that datasource.
- <cache-name> - name of an existing cache, the session get stored in that cache, for example Redis.

Lucee does not store "empty" sessions into a storage, so when a session does not contain any data other than the default keys, it not get stored.

### Distributed Storage
In case you are using a cache or a datasource as storage you can define how the data synchronization between local memory and storage should work.
You can set the default session distribution mode in the Lucee Administrator or .CFConfig.json like this
```json
{
  "sessionCluster": false
}
```
 and overwrite it in the Application.cfc like this
```javascript
this.sessionCluster=false;
```
If set to `false`, the local memory acts as primary storage point. When Lucee has the session locally at the beginning of a request, it will not retrieve the data from storage, only updating the storage at the end when the data is modified. This setting is optimal when the storage is used by a single server as it minimizes storage requests.

If set to `true`, the external storage acts as the primary source of truth. The data is checked against the storage at the beginning of every request to ensure consistency. This setting is recommended when the storage is shared between multiple servers to ensure data consistency across the cluster.

## Invalidate
The `SessionInvalidate()` function immediately terminates the current session and removes all associated data. This is useful when you need to clear all session data, such as during user logout. Example:

```javascript
SessionInvalidate();
// All session variables are now cleared
```

## Rotate
The `SessionRotate()` function creates a new session and copies all existing session data to it, while invalidating the old session. This is a security measure typically used after authentication state changes (login/logout) to prevent session fixation attacks. Example:

```javascript
// User logs in successfully
SessionRotate();
// Session data is preserved but with a new session ID
```

## Security
The Session is linked with help of the key "CFID" that can be in the URL of the cookie of the user (the key "CFTOKEN" is not used by Lucee and only exists for compatibility with other CFML engines). 
Lucee first checks for "CFID" in the URL and only if not exists in the URL it looks for it in the cookie scope.

Since Lucee 6.1, Lucee only accepts the key in the URL in case it has active sessions in memory with that key.
So in case you are using a storage (not "memory"), this is only up to a minute.

Since Lucee 6.1 you can completely block the use of CFID in the url by setting the following system property
``` -Dlucee.read.cfid.from.url=false```
or environment variable
``` LUCEE_READ_CFID_FROM_URL=false```



## Best Practice
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