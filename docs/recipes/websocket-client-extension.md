<!--
{
  "title": "WebSocket Client Extension",
  "id": "websocket-client-extension",
  "categories": [
    "websocket",
    "protocols"
  ],
  "description": "WebSocket client for Lucee — connect to any WebSocket server from CFML",
  "keywords": [
    "Lucee",
    "Extension",
    "WebSocket",
    "Client"
  ],
  "related": [
    "extension-websocket",
    "function-createwebsocketclient"
  ]
}
-->

# WebSocket Client Extension

Provides [[function-CreateWebSocketClient]] for connecting **to** a WebSocket server from Lucee — the opposite direction of the server-side [[extension-websocket]]. Use this for server-to-server communication, integration testing, or consuming external WebSocket APIs from CFML.

**Requires Lucee 6.2+.** Powered by the [nv-websocket-client](https://github.com/TakahikoKawasaki/nv-websocket-client) library.

## Installation

Install via the Lucee Administrator, or see [[extension-installation]] for all options (Dockerfile, deploy, env var, `.CFConfig.json`).

- **Maven GAV:** `org.lucee:websocket-client-extension`
- **Extension ID:** `058215B3-5544-4392-A187A1649EB5CA90`
- **Source:** [github.com/lucee/extension-websocket-client](https://github.com/lucee/extension-websocket-client)
- **Issues:** [Jira — `websockets` label](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20%22websockets%22)
- **Downloads:** [download.lucee.org](https://download.lucee.org/#058215B3-5544-4392-A187A1649EB5CA90)

## Usage

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

// Send a text message
ws.sendText( "Hello from CFML!" );

// Send binary data — anything that produces a byte[] works
ws.sendBinary( fileReadBinary( "/path/to/payload.bin" ) );
ws.sendBinary( charsetDecode( "raw bytes", "utf-8" ) );

// Check connection status
if ( ws.isOpen() ) {
    ws.sendText( "Still connected" );
}

// Close when done
ws.disconnect();
```

Use `wss://` instead of `ws://` to connect over TLS.

### `CreateWebSocketClient()` signature

```text
CreateWebSocketClient( string endpoint, component listener ) -> WebSocket
```

Both arguments are required. The `listener` is a CFC instance whose callbacks (see below) are invoked when messages arrive.

## Listener Callbacks

All callbacks are optional — implement only what you need:

| Callback | Arguments | Description |
|----------|-----------|-------------|
| `onMessage` | `message` | Text message received |
| `onBinaryMessage` | `binary` | Binary data received |
| `onClose` | (none) | Connection closed |
| `onError` | `type, cause, [data]` | Error occurred |
| `onPing` | (none) | Ping frame received |
| `onPong` | (none) | Pong frame received |

Error types: `callback`, `connect`, `general`, `frame`, `message`, `unexpected`.

## WebSocket Object Methods

`CreateWebSocketClient()` returns a Java WebSocket object with these commonly used methods:

```java
sendText( string message )  // send text message
sendBinary( byte[] data )   // send binary data
sendPing()                  // send ping frame
sendPong()                  // send pong frame
isOpen()                    // check if connected
disconnect()                // close connection
```

## Notes & Limitations

- **`permessage-deflate` compression is enabled by default** — messages are transparently compressed and decompressed in transit. If you're inspecting frames on the wire, don't expect to see raw text.
- **Connection timeout is hardcoded at 5 seconds** and can't currently be configured. Slow endpoints will fail to connect and throw a `WebSocketException`.
- **No automatic reconnection** — if the connection drops, you're responsible for calling `CreateWebSocketClient()` again. Consider wrapping connect + send in a retry loop with back-off.
- **`onError( type, cause, data )` — the `data` argument is only populated for errors of type `message`** (text-frame decode failures). Every other error type passes `null` for `data`, so your callback should tolerate both 2- and 3-argument invocations.
- **No support for custom connect-time headers or cookies.** If you need to send an `Authorization` header or a session cookie during the handshake, the current BIF doesn't expose that — consider authenticating via query string on the endpoint URL.
- **Sending binary to a Lucee [[extension-websocket]] server endpoint:** the server extension's `@OnMessage` only binds to text frames. `ws.sendBinary()` frames you send to a Lucee-hosted listener are accepted on the wire but won't invoke the listener's `onMessage` callback.
