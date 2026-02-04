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
    "function-websocketinfo"
  ]
}
-->

# WebSocket Extension

This extension adds WebSocket support to your Lucee Server. 

WebSockets use the same port as your HTTP server (Tomcat) - connect via `ws://` for HTTP or `wss://` for HTTPS. For example, if Tomcat runs on port 8888, your WebSocket URL would be `ws://localhost:8888/ws/yourlistener`.

WebSocket Listeners are created with a CFML Component - one per channel.

Please note, on Windows, there are more limitations regarding how many websockets can be used than with Linux.

## Installation

There are multiple ways to install the websocket extension.

### Lucee Administrator

The extension can be installed via Lucee Administrator:

![Lucee Admin: Extensions - Application](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/lucee-admin-extension.png)

### Manual Installation

Download the LEX file from [https://download.lucee.org/](https://download.lucee.org/) and save to `/lucee/lucee-server/deploy/` (takes up to a minute for Lucee to pick up and install).

![Lucee Download LEX File](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/websocket-lex.png)

### Docker

In Docker there are different ways to install it.

Copy it into the `deploy folder` like this via a Dockerfile:

```Dockerfile
ADD https://ext.lucee.org/websocket-extension-3.0.0.14-RC.lex /lucee/lucee-server/deploy/
```

Using Environment Variables like this:

```yml
environment:
  - LUCEE_EXTENSIONS=3F9DFF32-B555-449D-B0EB5DB723044045;version=3.0.0.14-RC
```

Or simply define it in the `.CFConfig.json` file (Lucee 6+):

```json
{
  "extensions": [
    {
      "name": "WebSocket",
      "path": "/your/path/extensions/websocket.extension-3.0.0.14-RC.lex",
      "id": "3F9DFF32-B555-449D-B0EB5DB723044045"
    }
  ]
}
```

See [this](https://github.com/lucee/lucee-docs/tree/master/examples/docker/with-extension) example for more details about setting up Extension in .CFConfig.json.

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

The WebSocket extension comes with a helper function `websocketInfo()` that will show the current configurations settings. More on other details later ...

![websocketInfo()](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/websocketInfo.png)

## Logging

By default the websocket extension logs to the `websocket` log, which needs to be created in the Lucee Admin, for debugging set the log level to TRACE.

Once this log has been defined in the admin, you can [force all the logs to the console](https://luceeserver.atlassian.net/browse/LDEV-3420)

## Component

> [!IMPORTANT]
> A Lucee restart is required when a new WebSocket CFC is added (just like for a ReST CFC)

```lucee
component hint="used to test websocket client" {

    public static function onFirstOpen( wsclients ) {}

    function onOpen( wsclient ) {}

    function onOpenAsync( wsclient ) {}

    function onMessage( wsclient, message ) {}

    function onClose( wsclient, reasonPhrase ) {}

    function onError( wsclient, cfcatch ) {}

    public static function onLastClose() {}

}
```

### JavaScript Client

Given that the Component was saved as `{lucee-config}/websockets/test.cfc`, here is native JavaScript to open and use a connection to your Lucee WebSocket:

```javascript
const socket = new WebSocket("ws://127.0.0.1/ws/test");

socket.onopen = function (evt) {
  console.log("Connected");
  socket.send("Hello, Lucee Extension!");
};

socket.onmessage = function (event) {
  console.log("Received:", event.data);
};

socket.onclose = function (evt) {
  console.log("Connection closed");
};

socket.onerror = function (error) {
  console.error("WebSocket error:", error);
};

// To close later: socket.close();
```

### CFML Client

For server-to-server WebSocket communication or testing, use the **WebSocket Client Extension** which provides [[function-CreateWebSocketClient]].

#### Installation

Install from the Lucee Administrator or via Maven:

```
org.lucee:websocket-client-extension
```

#### Usage

Create a listener component to handle WebSocket events:

```lucee
// ClientListener.cfc
component {

	variables.messages = [];

	function onMessage( message ) {
		arrayAppend( variables.messages, message );
	}

	function onBinaryMessage( binary ) {
		// handle binary data
	}

	function onClose() {
		systemOutput( "Connection closed", true );
	}

	function onError( type, cause, data ) {
		systemOutput( "Error [#type#]: #cause.getMessage()#", true );
	}

	function onPing() {}

	function onPong() {}

	array function getMessages() {
		return variables.messages;
	}

}
```

Connect to a WebSocket server:

```lucee
// Create listener and connect
listener = new ClientListener();
ws = CreateWebSocketClient( "ws://localhost/ws/test", listener );

// Send messages
ws.sendText( "Hello from CFML!" );
ws.sendBinary( toBinary( toBase64( "binary data" ) ) );

// Check connection status
if ( ws.isOpen() ) {
	ws.sendText( "Still connected" );
}

// Close when done
ws.disconnect();
```

#### Listener Callbacks

All callbacks are optional - implement only what you need:

| Callback | Arguments | Description |
|----------|-----------|-------------|
| `onMessage` | `message` | Text message received |
| `onBinaryMessage` | `binary` | Binary data received |
| `onClose` | (none) | Connection closed |
| `onError` | `type, cause, [data]` | Error occurred |
| `onPing` | (none) | Ping frame received |
| `onPong` | (none) | Pong frame received |

Error types: `callback`, `connect`, `general`, `frame`, `message`, `unexpected`

#### WebSocket Object Methods

The `CreateWebSocketClient()` function returns a Java WebSocket object with these commonly used methods:

```java
sendText( string message )  // send text message
sendBinary( byte[] data )   // send binary data
sendPing()                  // send ping frame
sendPong()                  // send pong frame
isOpen()                    // check if connected
disconnect()                // close connection
```

### Broadcast Message to all Clients

A broadcast is a message sent to all connected clients

To be able to do this, we need to know who is connected. The first time a connection is made, `onFirstOpen(wsclients)` is fired. `wsclients` is a Java class with the following methods:

```java
size():number                  // the number of clients connected
broadcast(any message):boolean // send message to all clients
getClients():Client[]          // return array of all clients currently connected
close():void                   // closes all clients
```

So we can save that for future use:

```lucee
public static function onFirstOpen(wsclients) {
    static.wsclients = arguments.wsclients;
}
```

For example:

```lucee
function onOpen(wsclient) {
    static.wsclients.broadcast("There are now ##static.wsclients.size()## connections");
}
```

### Send Message to One Client

When a connection is instantiated, `onOpen(wsclient)` is fired. `wsclient` is a Java class with the following methods:

```java
wsclient.broadcast(message):void // send message to all connected clients
wsclient.send(message):void      // send message to the client
wsclient.isOpen():boolean        // is the client still connected?
wsclient.isClose():boolean       // is the client no longer connected?
wsclient.close():void            // closes the connection of the client
```

To send a message using wsclient

```lucee
function onOpen(wsclient) {
    arguments.wsclient.send("You are connected to Lucee WebSocket");
}
```

You can also send a message from `onOpen()` by returning a string:

```lucee
function onOpen(wsclient) {
    return "Welcome to the test websocket channel";
}
```

You can add your own function to the WebSocket component:

```lucee
public void function sendMessage(
    required string jsonData
) {
    variables.wsclient.send(jsonData);
}

function onOpen(wsclient) {
    sendMessage("Hello, Lucee WebSocket!");
}
```

## Using Lucee WebSocket to PUSH data to Client

With WebSockets being a bidirectional communication channel, your Lucee Server is no longer limited to responding to a _request_; it can now _push_ data to the client.

This means the user no longer has to refresh a page to see if data is updated, nor have a JavaScript looping function that is continuously calling a REST API to get latest data.

When your application has data ready for the user, have the WebSocket push the data to the client!

### Make use of Static Function

Add a thread to start a background process, and have it continuously looping for as long as there are clients connected:

```lucee
public static function onFirstOpen(wsclients) {
    static.wsclients = arguments.wsclients;
    thread name="threadDataQueue" oClients=static.wsclients {
		while( attributes.oClients.size() > 0 ) {
			data = getDataFromSomewhere();
			attributes.oClients.broadcast(data);
			sleep(1000);
		}
    }
}
```

Function `getDataFromSomewhere()` is responsible for obtaining the data that needs to be sent to the client. RedisQueue is an example of where data can be stored. Your Lucee application can Push data to a Redis Queue, and `getDataFromSomewhere()` can Pop one record at a time.

### Using webSocketInfo() to Send Message to Client

[[function-websocketinfo]] returns a struct containing an `instances` array - one entry per active WebSocket connection. 

Each entry gives you access to the `component` and the `session` instance, allowing you to call the component's methods.

> [!NOTE]
> `instances` shows **active connections only**, not available listener components.
> The array is empty until clients connect, and entries are removed when connections close.

For Example (_excluding role management functions_):

```lucee
component hint="Test WebSocket"  {
	variables.roles = [];

	public boolean function hasRole( required string role ) {
		return ( variables.roles.find( arguments.role ) > 0 );
	}

	public void function sendMessage( required string jsonData ) {
		variables.wsclient.send( jsonData );
	}
	...
}
```

```lucee
var wsInfo = websocketInfo(false);
if ( !wsInfo.instances.len() )
    return;

var wsInstances = wsInfo.instances;

var item = getRedisData();
var stItem = deserializeJSON( item );
for ( var wsI in wsInstances ) {
    if ( GetMetadata( wsI.component ).name == 'test' && wsI.component.hasRole( stItem.data.role ) ) {
        wsI.component.sendMessage( item );
    }
}
```

[[event-gateways]] is a good candidate for this script.