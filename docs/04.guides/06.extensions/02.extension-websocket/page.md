---
title: Websocket gateway
id: extensions-websocket-gateway
categories:
- ajax
- protocols
---

### WebSockets Gateway Extension ###

This extension enables you to launch a server that is capable to manage messaging from HTML WebSockets. The server runs on a dedicated port. Lucee will receive notifications when a connection is opened, closed and any time a message is sent invoking a cfc listener class. 

The gateway can also being invoked via SendGatewayMessage so to allow your app to push message to all the connected clients.

<https://github.com/isapir/lucee-websocket>

[Extension Wiki](https://github.com/isapir/lucee-websocket/wiki)

<https://www.youtube.com/watch?v=r2s2kGQVZqg>

<https://www.youtube.com/watch?v=rvB7PcNylVY>


### Installing the Extension ###

You can install the extension by adding the provider <http://preview.lucee.org/ExtensionProvider.cfc> to your Providers section in the Lucee Web administration panel (not the Server administration panel). Then select the Websocket Gateway Extension app and simply click on the Install button.

### Create the gateway instance ###

Go into the Event Gateway section of your Lucee admin panel. Create a new gateway instance of type WebSocket. Choose a name that makes sense and is unique into your Lucee context. Click


### Configure the gateway ###

You can configure many aspect of your gateway.


* **Port** : select the port you want the server will listen for your incoming messages. Default is port 10125. Please remember that the server will listen incoming messages using the ws protocol. For example : ws://localhost:10125
* **Startup Mode** : Automatic will make the gateway start when Lucee server starts up automatically. Choose what selection better fits your need.
* **CFC Listener** : this is the cfc invoked by the websocket server and provides the hooks that you can use to manage the connections and the messages that arrive on the server. This can be any CFC. It must expose the functions defined in the configuration. A dummy example is provided with the extension in the location specified in the CFC listener field.

When you are done click submit.

### Usage ###

Start and stop the gateway is easier as per any other gateway in Lucee. Access the Gateway section in the lucee admin and and you will a set to start/stop, restart , edit and delete the gateway instances. Please note that stopping the gateway will also stop the websocket server and will destroy any actual connection.


### Interact using the gateway listener ###

You can use the interception provided by the gateway listener to change the default behaviour of the websocket gateway. The dummy listener that the extension ships looks like this:

```lucee
component{

    public void function onClientOpen(Struct data){
    }

    public void function onClientClose(Struct data){
    }

    public void function onMessage(Struct data){
    }
}
```

Any time a new connection is opened, closed and when a message is sent, the websocket server invokes the listener before sending out any message. The data map passed to the listener contains the following :


* **conn** : the connection reference that created the message.
* **message** : the message that the connection carries. This is normally empty when a connection is Opened and Closed

More in details:

* **onClientOpen / onClientClose ** : these 2 events are fired by the client when a new connection is opened or an existing one is terminated. On these events the websocket server does not actually sends out any message but allows you to store the connections and using them later. For example :

```lucee
public void function onClientOpen(Struct data){
    arrayAppend(variables.connections,data.conn);
}
```

Is important that you implement onClientClose removing the connection from your personal store. This is important if you want to force the server to send messages only to selected group of connections.

* onMessage : this is the hook that allows to you to manage the message to be sent and the set of connection to be notified.

Customizing the message is very easy. Just modify the data.message field and that will be the message pushed to the connections.

```lucee
public void function onMessage(Struct data){
	data.message = data.message & " This is added to the message to be sent to any opened connection";
}
```

If you want to force the server to notify only a set of connections you can add to the data map the attribute connections containing an array of actual opened connections. If a connection exists and is an array containing valid connections only these will be notified and will receive the message.

```lucee
public void function onMessage(Struct data){
	data.connections = ['Array of connections that you have stored using the onClientOpen, onClientClose listener methods.'];
}
```

### sendGatewayMessage ###

The gateway is running into your applications and can be invoked as any other other gateway by id using the SendGatewayFunction:

```lucee
sendGatewayMessage(String id,Struct data);
```

This is a great way for performing data push operations. The server will ping ANY REGISTERED CONNECTION and invokes the onMessage listener ( you can restrict the connection to be called at this level adding a data.connections array to the struct).

** IMPORTANT ** : store the message as data.message in the struct you pass to the sendGatewayMessage function.


### Logging ###

The gateway creates a log file called WebSocket.log under your lucee context log folder. Any important event ( and error ) is logged in this file. This file is unique for all the gateways you start from a same Lucee context.

### Client ###

At the time of this script not all the browsers support WebSockets out of the box.

Use this test page to find out if your browser supports it. 

<http://html5test.com/>

If your browser supports websockets implementing a client is very easy:

```lucee
ws = new WebSocket(server_url);

ws.onopen = function(){
    //do staff or send a message
}

ws.onmessage = function(message){
    do(message.data);
}

ws.onclose =  function(){
    //do staff or send a message
}
```

Please refer to the sample apps source code for more examples.

If browser failover is important to you, many OS libraries exist that has the ability to failover to other technologies as flash or ajax longpolling if there is no WebSocket support available in the current browser. This is one of the best client around that offer exactly this failover : [http://socket.io/](http://socket.io/)
