<!--
{
  "title": "Socket Event Gateway",
  "id": "event-gateway-socket",
  "related": [
    "event-gateways",
    "event-gateways-how-they-work",
    "custom-event-gateways",
    "function-sendgatewaymessage",
    "function-gatewayaction",
    "function-gatewaystate",
    "config",
    "logging"
  ],
  "categories": [
    "event-gateways"
  ],
  "description": "Use the Socket event gateway built into Lucee to accept plain TCP connections, handle each incoming line in a CFML listener and send replies back to the client.",
  "keywords": [
    "Event Gateway",
    "Socket Gateway",
    "SocketGateway",
    "TCP",
    "telnet",
    "netcat",
    "onIncomingMessage",
    "sendGatewayMessage",
    "CFConfig"
  ]
}
-->

# Socket Event Gateway

Lucee ships with a Socket event gateway in core (`lucee.runtime.gateway.SocketGateway`). It opens a plain TCP server port, and every line a client sends to that port is passed to a listener component written in CFML. The listener can answer the client with [[function-sendgatewaymessage]].

This is useful for simple line-based integrations, for example a small control channel for scripts and devices, or for poking at a running server with `telnet` or `nc`.

The Socket gateway is part of the Lucee core (it is not an extension), so there is nothing to install. The source is the same in Lucee 7.1, 8.0 and 9.0.

> **Verification:** the examples on this page were run against a real Lucee 7.1 server, with the gateway configured in the server `.CFConfig.json`, a client connected over TCP and messages echoed back. They have not been run on 8.0 or 9.0.

## What it does

- Starts a `ServerSocket` on the configured port and accepts any number of client connections.
- Sends the welcome message and a `> ` prompt to each client when it connects.
- Reads each connection line by line. A line is anything ended by a line break (`\n` or `\r\n`), so `telnet` and `nc` both work.
- For every line, calls `onIncomingMessage` on the listener component.
- If a client sends `exit`, the connection is closed and the line is not passed to the listener.
- Every message written with [[function-sendgatewaymessage]] is followed by a new `> ` prompt.

## Configuration

Gateway instances are defined in the `gateways` section of the server configuration (see [[config]]). Add an entry to the server `.CFConfig.json`:

```json
{
  "gateways": {
    "echoSocket": {
      "class": "lucee.runtime.gateway.SocketGateway",
      "listenerCFCPath": "gateways.EchoListener",
      "startupMode": "automatic",
      "custom": {
        "port": 1225,
        "welcomeMessage": "Hello from echoSocket"
      }
    }
  }
}
```

| Key | Purpose |
|---|---|
| `echoSocket` (the key) | The gateway id. You use it with `sendGatewayMessage()`, `gatewayAction()` and `gatewayState()`. |
| `class` | The Java class that implements the gateway: `lucee.runtime.gateway.SocketGateway`. |
| `listenerCFCPath` | Dotted path of the listener component, resolved like any other CFC in the web context (webroot or mappings). `gateways.EchoListener` is `/gateways/EchoListener.cfc`. |
| `startupMode` | `automatic` starts the gateway when Lucee starts, `manual` only starts it when you call `gatewayAction( id, "start" )`, `disabled` switches the instance off. |
| `custom.port` | TCP port to listen on. Defaults to `1225`. |
| `custom.welcomeMessage` | Text sent to each client on connect. Defaults to `Welcome to the Lucee Socket Gateway`. |

Make sure the port is free and reachable only by the clients that should use it, see the caveats below.

## The listener

Lucee calls `onIncomingMessage` on the listener for every line received. The event is passed in as **named arguments**:

| Argument | Contents |
|---|---|
| `data` | A struct, `data.message` holds the line the client sent. |
| `originatorID` | An id identifying the client connection that sent the line. |
| `gatewayId` | The id of the gateway instance, `echoSocket` in this example. |
| `gatewayType` | Always `Socket`. |
| `cfcPath`, `cfcMethod`, `cfcTimeout` | The listener path, the method name and the timeout (10) used for the call. |

Create `/gateways/EchoListener.cfc` in your webroot:

```lucee
component {

	function onIncomingMessage( required struct data, required string originatorID, required string gatewayId ) {
		var line = trim( arguments.data.message );

		// reply to the client that sent the line
		sendGatewayMessage( arguments.gatewayId, {
			message: "echo: " & uCase( line ),
			originatorID: arguments.originatorID
		} );
	}

}
```

Note that, unlike Adobe ColdFusion, there is no single `CFEvent` argument, so a listener declared as `onIncomingMessage( CFEvent )` fails with *The parameter [CFEvent] to function [onIncomingMessage] is required but was not passed in*. Declare the arguments you need, or read everything from the `arguments` scope.

The return value of the listener is ignored.

## Sending messages back

`sendGatewayMessage( gatewayId, data )` takes a struct with these keys:

- `message` - the text to write to the client.
- `originatorID` - optional. If set, only the connection with this id gets the message, usually the one from the incoming event. If omitted, the message is written to **every** connected client.

It returns `OK` on success and `EXCEPTION` if the message could not be delivered, for example when no client is connected or the `originatorID` does not match an open connection. The reason is written to the `gateway` log.

You can also push messages from any normal request, which makes it easy to broadcast, for example from a scheduled task:

```lucee
<cfscript>
	result = sendGatewayMessage( "echoSocket", { message: "Server restarting in 5 minutes" } );
	// result is "OK" when at least one client received it
</cfscript>
```

## Testing it

Start Lucee (or start the gateway), then connect from a terminal with `telnet` or `nc`:

```bash
nc localhost 1225
```

or

```bash
telnet localhost 1225
```

A session looks like this (the text after each `> ` prompt is what you type):

```text
Hello from echoSocket
> hello world
echo: HELLO WORLD
> exit
```

If nothing happens, check the following:

- `gatewayState( "echoSocket" )` returns `running`.
- The `gateway` log (see [[logging]]) for errors such as the port being in use or the listener failing.
- That the listener path resolves, `gateways.EchoListener` must be `/gateways/EchoListener.cfc` in the web context.

## Controlling the gateway

```lucee
<cfscript>
	systemOutput( gatewayState( "echoSocket" ), true ); // running, starting, stopping, stopped or failed

	gatewayAction( "echoSocket", "stop" ); // also: start, restart
</cfscript>
```

[[function-gatewayaction]] does not return a value. Stopping or restarting the gateway closes all open client connections.

## Caveats

- **No authentication or encryption.** The gateway listens on all network interfaces and anybody who can reach the port can send it lines. Do not expose the port to untrusted networks; restrict it with a firewall, and treat every message as untrusted input in your listener.
- **No framing beyond lines.** Binary protocols, messages that contain line breaks and TLS are not supported. This is a plain text, line-based gateway.
- **Errors do not reach the client.** If the listener throws, the error is written to the `gateway` log and the client gets no reply. Wrap your listener code in try/catch and send a message back yourself, see [[event-gateways-how-they-work]].
- **Treat the listener as stateless.** Do not rely on the `variables` scope surviving between messages; keep shared state in the `application` or `server` scope or in a cache.
- **`originatorID` belongs to a connection.** It changes every time a client reconnects, so do not store it as a user identity.
- **One port, one gateway.** Every gateway instance needs its own port. If the port is already taken the gateway fails to start (state `failed`) and the reason is logged.
- **Configuration changes.** After changing `port` or the listener path, restart the gateway with `gatewayAction( id, "restart" )` or restart Lucee.
- **Server level configuration.** The gateway is defined in the server configuration, as in the example above, while the listener component is found through the web context.
