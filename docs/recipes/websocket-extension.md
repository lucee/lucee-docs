<!--
{
  "title": "Lucee WebSocket Extension",
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

# Lucee WebSocket Extension

This extension adds a WebSocket Server to your Lucee Server that runs over `TCP` on port 80 for `WS:` and 443 for `WSS:`

WebSocket Listeners are created with a CFML Component - one per channel.

## Installation

There are multiple ways to install the docker extension.

### Lucee Administrator

The Extension can be installed via Lucee Administrator

![Lucee Admin: Extensions - Application](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/lucee-admin-extension.png)

### Manual Installation

Download the LEX file from [https://download.lucee.org/](https://download.lucee.org/) and save to `/lucee/lucee-server/deploy/` (takes up to a minute for Lucee to pick up and install)

![Lucee Download LEX File](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/websocket-lex.png)

### Docker

In Docker there are different ways to install it.

Copy it into the `deploy folder` like this:

```Dockerfile

ADD https://ext.lucee.org/websocket-extension-3.0.0.14-RC.lex /lucee/lucee-server/deploy/

```

Using Environment Variables like this:

```yml

environment:
  - LUCEE_EXTENSIONS=3F9DFF32-B555-449D-B0EB5DB723044045;version=3.0.0.14-RC

```

Or simply define it in the .CFConfig.json file (Lucee 6 only)

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

Lucee Server will create a config file if one does not exists at `{lucee-config}websocket.json` with the following defaults

_{lucee-config}: /lucee/lucee-server/context_

```json
{
  "directory": "{lucee-config}/websockets/",
  "requestTimeout": 50,
  "idleTimeout": 300
}
```

The WebSocket Extension comes with a helper function `websocketInfo()` that well show the current configurations settings. More on other details later ...

![websocketInfo()](https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/_images/extension/websocket/websocketInfo.png)
<em>TODO: update with new version</em>

## Component

> [!IMPORTANT]
> a Lucee restart is required when a new WebSocket CFC is added (just like for a ReST CFC)

```lucee
component hint="used to test websocket client" {

    public static function onFirstOpen(wsclients) {}

        function onOpen(wsclient) {}

        function onOpenAsync(wsclient) {}

        function onMessage(wsclient, message) {}

        function onClose(wsclient, ReasonPhrase) {}

        function onError(wsclient,cfcatch) {}

    public static function onLastClose() {}

}
```

### Javascript Client

Given that the Component was saved as `{lucee-config}/websockets/test.cfc`, here is native Javascript to open and use a connection to your Lucee WebSocket:

```javascript
socket = new WebSocket("ws://127.0.0.1:80/ws/test");

socket.onopen = function (evt) {
  console.log(["onopen()", evt]);
};

socket.onmessage = (event) => {
  console.log(event.data);
};

socket.onerror = function (error) {
  console.error(error);
};

socket.send("Hello, Lucee Extension!");

socketclose();
```

### Broadcast Message to all Clients

A broadcast is a message send to all connected clients

To be able to do this, we need to know who is connected. The first time a connection is made, `onFirstOpen(wsclients)` is fired. `wsclients` is a Java class with the following methods

```java
size():number                  // the number of clients connected
broadcast(any message):boolean // send message to all clients
getClients():Client[]          // return array of all clients currently connected
close():void                   // closes all clients
```

SO we can save that for furture use

```lucee
public static function onFirstOpen(wsclients) {
    static.wsclients = arguments.wsclients;
}
```

For example

```lucee
function onOpen(wsclient) {
    static.wsclients.broadcast("There are now ##static.wsclients.size()## connections");
}
```

### Send Message to one Client

When a connection is instantiated, `onOpen(wsclient)` is fired. `wsclient` is a Java class with the following methods

```java
client.broadcast(message):void // send message to all connected clients
client.send(message):void      // send message to the client
client.isOpen():boolean        // is the client still connected?
client.isClose():boolean       // is the client no longer connected?
client.close():void            // closes the connection of the client
```

To send a message using wsclient

```lucee
function onOpen(wsclient) {
    arguments.wsclient.send("You are connected to Lucee WebSocket");
}
```

You can also send a message from `onOpen()` by returning a string

```lucee
function onOpen(wsclient) {
    return "Welcome to the test websocket channel";
}
```

You can add your own function to the WebSocket Component

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

With webSocets being a bidirectional communication channel, your Lucee Server no longer limited to responding to a _request_, it can now _push_ data to the client.

This means the user no longer has to refresh a page to see if data is updated, or have a Javascript looping function that is continuously calling a ReST API to get lasted data.

When your application has data ready for the user, have the WebSocket push the data to the cient!

### Make use of Static Function

Add a thread to start a background process, and have it continuously looping for as long as there are clients connected

```lucee
public static function onFirstOpen(wsclients) {
    static.wsclients = arguments.wsclients;
    thread name="threadDataQueue" oClients=static.wsclients {
		while( attributes.oClients.size() > 0 ) {
			data = getDataFromSomewhere();
			attributes.oClients.broadcastMessage(data);
			sleep(1000);
		}
    }
}
```

Function `getDataFromSomewhere()` is respoible for obtaining the data that needs to be sent to the client. RedisQueue is an example of where data can be stored. Your Lucee application can Push data to a Redis Queue, and `getDataFromSomewhere()` can Pop one record at a time.

### Using websocketInfo() to Send Message to Client

`websocketInfo()` also has an array of instances - one for each client call to a WebSocket Component. So looping through the array, gives you access to the Component, and then you can call any of it'sfunction

For Example ( _excuding role management functions_ )

```lucee
component hint="Test WebSocket"  {
	variables.roles = [];

	public boolean function hasRole(
		required string role
	) {
		return ( variables.roles.find(arguments.role) > 0 );
	}

	public void function sendMessage(
    	required string jsonData
	) {
		variables.wsclient.send(jsonData);
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
var stItem = deserializeJSON(item);
for ( var wsI in wsInstances) {
    if ( GetMetadata(wsI).name == 'test' && wsI.hasRole(stItem.data.role) ) {
        <b>wsI.sendMessage(item);</b>
    }
}
```

[Task Event Gateway](event-gateways-overview.md) is a good candidate for this script

_TODO: link to recipe page_
