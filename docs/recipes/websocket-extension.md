<!--
{
  "title": "WebSocket Extension",
  "id": "extension-websocket",
  "categories": [
    "websocket",
    "protocols"
  ],
  "description": "How to install, configure and create WebSockets",
  "keywords": [
    "Lucee",
    "Extension"
  ],
  "related": [
    "function-websocketinfo",
    "websocket-client-extension",
    "scheduler-quartz",
    "event-gateways"
  ]
}
-->

# WebSocket Extension

This extension adds WebSocket support to your Lucee Server.

WebSockets use the same port as your HTTP server (Tomcat) — connect via `ws://` for HTTP or `wss://` for HTTPS. For example, if Tomcat runs on port 8888, your WebSocket URL would be `ws://localhost:8888/ws/yourlistener`.

WebSocket Listeners are created with a CFML Component — one per channel.

**Requires Lucee 6.2+.** Loads on both Lucee 6.x (Tomcat 9, `javax.websocket`) and Lucee 7.x (Tomcat 11, `jakarta.websocket`) — the extension ships both API bindings and picks the right one at startup.

On Windows, peak concurrent WebSocket capacity is lower than on Linux. Linux's NIO uses `epoll`, which scales well across tens of thousands of idle sockets; Windows falls back to `select()`, which doesn't. Windows also has a narrower default ephemeral port range (~16k) and no `ulimit -n` equivalent. For heavy WebSocket loads, prefer Linux — or on Windows, widen the ephemeral range (`netsh int ipv4 set dynamicport tcp start=10000 num=55000`) and raise Tomcat's `maxConnections` in `server.xml`.

## Installation

Install via the Lucee Administrator, or see [[extension-installation]] for all options (Dockerfile, deploy, env var, `.CFConfig.json`).

- **Maven GAV:** `org.lucee:websocket-extension`
- **Extension ID:** `3F9DFF32-B555-449D-B0EB5DB723044045`
- **Source:** [github.com/lucee/extension-websocket](https://github.com/lucee/extension-websocket)
- **Issues:** [Jira — `websockets` label](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20%22websockets%22)
- **Downloads:** [download.lucee.org](https://download.lucee.org/#3F9DFF32-B555-449D-B0EB5DB723044045)

## Configuration

By default, Lucee Server will look in `{lucee-config}/websockets/` for WebSocket Components.

Lucee Server will create a config file if one does not exist at `{lucee-config}/websocket.json` with the following defaults:

_{lucee-config}: /lucee/lucee-server/context_

```json
{
  "directory": "{lucee-config}/websockets/",
  "requestTimeout": 50,
  "idleTimeout": 300
}
```

- `idleTimeout` (default 300 seconds) controls how long each connection can remain idle before the servlet engine closes it.
- `requestTimeout` (default 50 seconds) controls the maximum time for processing a WebSocket request.

Override the config file path with the `-Dlucee.websocket.config=/path/to/websocket.json` JVM argument or the `LUCEE_WEBSOCKET_CONFIG` environment variable.

### Storing Listeners with Your Application

The default `{lucee-config}/websockets/` location is outside your application's webroot and git repository, which makes deployment awkward — the listener CFC isn't versioned alongside the rest of your code and has to be copied to each server manually.

The `directory` setting accepts **any absolute path**, so point it at a folder inside your app's repository:

```json
{
  "directory": "/var/www/myapp/websockets/",
  "requestTimeout": 50,
  "idleTimeout": 300
}
```

Now listeners live in your repo and deploy with the rest of the application. Lucee placeholders like `{lucee-config}` also work in this field.

> [!NOTE]
> If the directory sits inside a publicly-served webroot, block HTTP access to it via your web server config (Apache `Deny`, Nginx `location` rule, IIS request filtering) — the listener CFCs aren't meant to be invoked directly over HTTP.

### Per-Listener `idleTimeout`

A listener can override the server-wide `idleTimeout` by declaring a component `property` (value in seconds):

```lucee
component {

    property name="idleTimeout" default=60;

    function onOpen( wsClient ) {
        wsClient.send( "CONNECTED" );
    }

}
```

Only `idleTimeout` is honoured at the listener level — `requestTimeout` is server-wide.

### Health Checks and Deployment

The extension registers its WebSocket endpoints on a background thread after Lucee startup — there's a brief window where Tomcat is serving HTTP but `/ws/*` still 404s because the endpoints aren't registered yet.

For blue/green or rolling deployments, include [[function-websocketinfo]] in your health check so the load balancer doesn't route traffic until the extension has finished registering:

```lucee
var info = websocketInfo();
if ( isNull( info ) || ( info.mapping ?: "" ) == "" )
    throw( message="websocket extension not ready", type="HealthCheckFailure" );
```

> [!IMPORTANT]
> `requestTimeout` also bounds `onFirstOpen` and any `thread` spawned inside it. A `while` loop in `onFirstOpen` will be killed once `requestTimeout` elapses. For long-running push work, don't loop inside `onFirstOpen` — move it to a [[scheduler-quartz]] job (cron expressions, clustering, component jobs) or an [[event-gateways]]. The legacy [[tag-schedule]] also works for simpler cases.

![websocketInfo()](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/websocketInfo.png)

## Example Listener

Drop this into the configured directory as `EchoListener.cfc`. It echoes incoming messages, tracks connected users by id and role, and exposes static helpers so the rest of your app can push to specific users or roles.

```lucee
component hint="Example listener — echoes, tracks users, supports targeted push" {

    static {
        clientsByUser = {};  // userId -> wsClient
        rolesByUser   = {};  // userId -> array of roles
    }

    function onOpen( wsClient ) {
        var userId = getUserIdFromRequest();
        static.clientsByUser[ userId ] = arguments.wsClient;
        static.rolesByUser[ userId ]   = getRolesForUser( userId );
        arguments.wsClient.send( "CONNECTED" );
    }

    function onMessage( wsClient, message ) {
        arguments.wsClient.send( "ECHO:" & arguments.message );
    }

    function onClose( wsClient, reasonPhrase ) {
        var userId = getUserIdFromRequest();
        structDelete( static.clientsByUser, userId );
        structDelete( static.rolesByUser, userId );
    }

    function onError( wsClient, cfCatch ) {
        systemOutput( "WS error: #cfCatch.message#", true );
    }

    // --- static helpers callable from anywhere in the app ---

    public static boolean function sendToUser( required string userId, required any message ) {
        if ( !structKeyExists( static.clientsByUser, arguments.userId ) )
            return false;
        var client = static.clientsByUser[ arguments.userId ];
        if ( !client.isOpen() ) {
            structDelete( static.clientsByUser, arguments.userId );
            return false;
        }
        client.send( arguments.message );
        return true;
    }

    public static void function sendToRole( required string role, required any message ) {
        for ( var userId in static.clientsByUser ) {
            if ( arrayFind( static.rolesByUser[ userId ], arguments.role ) && static.clientsByUser[ userId ].isOpen() )
                static.clientsByUser[ userId ].send( arguments.message );
        }
    }

    // --- your auth integration ---

    private string function getUserIdFromRequest() {
        // add your business logic here — e.g. read a token from the handshake
        // query string (?userId=42), a JWT cookie, a session, etc.
        return cgi.query_string.listLast( "=" );
    }

    private array function getRolesForUser( required string userId ) {
        // add your business logic here — look up roles for this user from your
        // database, auth provider, etc.
        return [ "user" ];
    }

}
```

> [!IMPORTANT]
> A Lucee restart is required when a new WebSocket CFC is added (just like for a REST CFC). **Tomcat does NOT need to be restarted** — just Lucee (via the admin, `cfadmin action="restart"`, or a redeploy). The extension uses a reflection fallback so the newly-loaded classes take over the endpoint that Tomcat has already registered. See [the reflection note](#reflection-after-lucee-restart) in Troubleshooting for the detail.

Restart Lucee and connect from a browser (the listener name maps to the URL):

```javascript
const socket = new WebSocket( "ws://127.0.0.1:8888/ws/EchoListener?userId=42" );
socket.onmessage = ( evt ) => console.log( "received:", evt.data );
socket.onopen    = ()    => socket.send( "hello" );
// Expect: "received: CONNECTED", then "received: ECHO:hello"
```

Check server state any time:

```lucee
writeDump( websocketInfo() );
```

## Lifecycle Callbacks

All callbacks are optional — implement only what you need.

| Callback | Static? | When it fires | Notes |
| --- | --- | --- | --- |
| `onOpen( wsClient )` | no | Client connects | Return a string to send back to that client |
| `onOpenAsync( wsClient )` | no | Same time as `onOpen`, in parallel | Long init work that shouldn't block the connection ack |
| `onMessage( wsClient, message )` | no | Client sends a text frame | Return a string to auto-send a reply |
| `onClose( wsClient, reasonPhrase )` | no | Client disconnects | Use to clean up `static` maps |
| `onError( wsClient, cfCatch )` | no | Exception in any callback | Connection remains open |
| `onFirstOpen( wsClients )` | **yes** | First connection on a "cold" listener | Fires again after `onLastClose` if new clients connect later |
| `onLastClose()` | **yes** | Last remaining client disconnects | Channel-wide cleanup |

The [Example Listener](#example-listener) uses the four everyday instance callbacks (`onOpen`, `onMessage`, `onClose`, `onError`). `onFirstOpen` and `onLastClose` are class-level bookends for channel-wide setup/teardown and don't receive a specific `wsClient` — they're not tied to any one connection.

### The `wsClient` argument

Every instance callback receives a `wsClient` Java object:

```java
send( any message ):boolean      // send to this client; true on success, false if message was null
broadcast( any message ):any     // send to ALL clients; null on success, false if message was null
isOpen():boolean                 // is this connection still alive?
isClose():boolean                // inverse of isOpen
close():void                     // terminate this connection
```

The message argument can be a string, binary data, or a complex value (auto-serialized). If the value is binary, a binary frame is sent; otherwise a text frame.

### The `wsClients` argument (plural, passed to `onFirstOpen`)

```java
size():number                    // currently-connected client count
broadcast( any message ):any     // send to all; null on success, false if message was null
getClients():Client[]            // array of individual wsClient objects
close():void                     // close all connections
```

> [!NOTE]
> **Incoming messages are text only.** The server-side `@OnMessage` handler only binds to text frames — if your client sends a binary frame, the server won't receive an `onMessage` call. Outgoing binary works fine (return binary from a callback, or call `wsClient.send( toBinary( base64EncodedData ) )`).

## Why `static` and not `variables`?

A natural first instinct is `variables.clientsByUser`. Here's why that doesn't work:

Every lifecycle callback — `onOpen`, `onMessage`, `onClose` — and any external code that reaches in via [[function-websocketinfo]] can get its own fresh instance of your listener CFC. Whatever you stash in `variables` during `onOpen` isn't guaranteed to be visible when the next message arrives, let alone from a scheduled job that wants to push data in.

`application` scope looks tempting next, but each callback runs in a synthetic PageContext built by the extension — no `Application.cfc`, no `OnRequestStart`, no request lifecycle at all. Treating listener state as "application data" is also the wrong shape: a WebSocket channel isn't scoped to an application, it's scoped to the listener component itself.

`server` scope is too broad, and it survives Lucee restarts — you'd be left holding references to dead sessions on the next reload.

`static` fits exactly. It lives on the component **class**, not on any instance, so every callback and every external caller sees the same store. Its lifetime matches the listener CFC's lifetime: populated when first touched, reset when Lucee reloads the component. That's why `static.clientsByUser` and `static.rolesByUser` in the example listener survive across callbacks and across the scheduled jobs that push to them.

## Sending Messages

### Inside a lifecycle callback

Use the `wsClient` argument directly. The example listener's `onMessage` does this:

```lucee
function onMessage( wsClient, message ) {
    arguments.wsClient.send( "ECHO:" & arguments.message );
}
```

Or return a string from `onOpen` / `onMessage` and the framework sends it for you:

```lucee
function onOpen( wsClient ) {
    return "Welcome to the test websocket channel";
}
```

### Broadcast to every connected client

From inside a callback, use the `wsClient.broadcast()` shortcut:

```lucee
function onOpen( wsClient ) {
    arguments.wsClient.broadcast( "a new client connected — #structCount( static.clientsByUser )# total" );
}
```

From outside, stash the plural `wsClients` object at `onFirstOpen` and use it:

```lucee
public static function onFirstOpen( wsClients ) {
    static.wsclients = arguments.wsClients;
}

public static void function announceMaintenance() {
    if ( !isNull( static.wsclients ) && static.wsclients.size() > 0 )
        static.wsclients.broadcast( "maintenance in 5 minutes" );
}
```

### To a specific user or role (from anywhere)

The example listener's `sendToUser` and `sendToRole` static helpers are callable from any CFML code that can reach the listener component — a scheduled job, an event gateway, a REST endpoint, whatever. See the next section.

## Pushing Data from Outside the Connection

WebSockets are bidirectional — your server can push updates without waiting for a client request. The Lucee-specific rule: **don't drive the push from `onFirstOpen`**. The `requestTimeout` (default 50s) will kill any loop or long-running thread spawned there.

Drive pushes from a scheduler instead. A [[scheduler-quartz]] job, [[event-gateways]], or [[tag-schedule]] task calls your listener's static helpers:

```lucee
// in a scheduled job / event gateway / REST endpoint
var events = popEventsFromQueue();
for ( var e in events ) {
    if ( structKeyExists( e, "role" ) )
        EchoListener::sendToRole( role=e.role, message=serializeJSON( e ) );
    else
        EchoListener::sendToUser( userId=e.userId, message=serializeJSON( e ) );
}
```

> [!WARNING]
> Do not run an infinite `while { sleep() }` loop inside `onFirstOpen`. The page context's `requestTimeout` will kill it. Use a scheduler that fires on an interval instead.

### Dispatching via `websocketInfo()`

If you don't know the listener name at compile time, iterate the active connections from [[function-websocketinfo]]:

```lucee
var info = websocketInfo( false );
for ( var i in info.instances ) {
    if ( GetMetadata( i.component ).name == "EchoListener" ) {
        i.component.sendToUser( userId=42, message="hello" );
        break;
    }
}
```

> [!NOTE]
> `instances` shows **active connections only**, not available listener components. The array is empty until clients connect, and entries are removed when connections close.

## Connecting

### JavaScript

```javascript
const socket = new WebSocket( "ws://127.0.0.1:8888/ws/EchoListener" );

socket.onopen    = ( evt )   => { console.log( "Connected" ); socket.send( "hello" ); };
socket.onmessage = ( event ) => console.log( "Received:", event.data );
socket.onclose   = ( evt )   => console.log( "Connection closed" );
socket.onerror   = ( error ) => console.error( "WebSocket error:", error );

// To close later: socket.close();
```

See MDN for the JavaScript side: [Writing WebSocket client applications](https://developer.mozilla.org/docs/Web/API/WebSockets_API/Writing_WebSocket_client_applications) (tutorial) and the [`WebSocket` interface reference](https://developer.mozilla.org/docs/Web/API/WebSocket).

### CFML (server-to-server)

Use the separate [[websocket-client-extension]], which provides [[function-CreateWebSocketClient]], for connecting **to** a WebSocket server from CFML — useful for server-to-server communication or integration testing.

## Logging

The extension logs to a dedicated `websocket` logger. Create it in the Lucee Administrator (or in `.CFConfig.json`) and set the level to `TRACE` when debugging — see [[logging]] for configuration details.

To stream everything to the console for local debugging or containers, use the env vars from [[logging]]'s "Redirecting Logs to Console" section:

```bash
LUCEE_LOGGING_FORCE_LEVEL=trace
LUCEE_LOGGING_FORCE_APPENDER=console
```

## Troubleshooting

### Reverse Proxy Timeouts

If your WebSocket connections are closing after exactly 60 seconds, the problem is almost certainly your **reverse proxy**, not the servlet engine. Most reverse proxies have their own idle timeout that defaults to 60 seconds, independently of Lucee's `idleTimeout` setting.

**Nginx** — add to your WebSocket `location` block:

```nginx
proxy_read_timeout 300s;
proxy_send_timeout 300s;
```

**Apache mod_proxy** — add to your `<VirtualHost>` or `<Location>` block:

```apache
ProxyTimeout 300
```

Other load balancers (HAProxy, Cloudflare, AWS ALB, etc.) have similar idle timeout settings — check your provider's docs.

### Reflection After Lucee Restart

**This is a feature, not a warning.** The reflection fallback is what makes the "add a listener CFC → restart Lucee → new listener works immediately" workflow viable without forcing a servlet-engine restart.

After Lucee restarts while Tomcat stays up, the log shows:

```text
calling [onOpen] via reflection, servlet engine restart needed
```

Why: the servlet container only allows `addEndpoint()` once per endpoint path during its lifecycle. When Lucee restarts, its fresh extension classes can't re-register — so they inject themselves into the previous class's static field and forward calls via reflection. WebSocket traffic keeps flowing; only the dispatch is marginally slower.

If you want to remove that slight overhead, restart Tomcat too — not just Lucee. But for routine "I added a new listener, reload Lucee to pick it up" usage, the reflection path is designed to be transparent and can be left alone.

See [LDEV-6221](https://luceeserver.atlassian.net/browse/LDEV-6221) for the implementation detail.

## Further Reading

- [Lucee-websocket-commandbox](https://github.com/webonix/Lucee-websocket-commandbox) — full working client + server example with JavaScript and CFML.
- [Getting Started with Lucee 6 WebSockets](https://www.cfcamp.org/resource/getting-started-with-lucee-6-websockets.html) — CFCAMP 2024 presentation.
