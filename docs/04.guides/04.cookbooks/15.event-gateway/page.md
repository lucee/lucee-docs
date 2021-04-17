---
title: Event Gateways in Lucee
id: event-gateways-lucee
categories:
- gateways
---
## Lucee Event Gateways

First of all it is necessary to explain how Event Gateways (EG) are working in the first place.
EG's are another way how to communicate with your Lucee server – kind of a service running on Lucee, reacting on certain events. These kind of events could be something along the lines of:

* SMS sent to a certain receiver
* File change happening in a  directory
* Mail received on a mail server
* Slack notification received

What then can be done with these events is to trigger some actions that react on these events. For instance if an SMS is sent to the server asking for the current heap memory space, the server could respond with an SMS returning the details. So you basically have an event producer and an event consumer.

Event Gateways have for a long time lived a quiet life in CFML for several reasons. The main reasons were the lack of diversity and implementations which were due to the fact that EG's had to be written in Java and not every CFML developer is very familiar with Java. Given this downside, it is understandable, that there are such few available event gateways available.

## Lucee's approach

In Lucee EG's can be written in CFML and this is what this description is all about, which now makes it way more attractive to write the decisive parts with your favorite language. Some parts sometimes still need perhaps a Java library, but coding around that normally is not really a problem. Just use the according JAR solution available for the specific event (like SMS or others).

### What are the involved components in Lucee?

There are 2 components that are important for writing an event gateway:

* Gateway driver
* Event Gateway

The gatway driver is a CFC that is allowing you to configure your EG. The basic Gateway driver is defining the edit fields for the configuration in the administrator.

So for instance if you want to define the above configuration with the Event Gateway Driver CFC the CFC might look like this:

**CustomLoggerDriver.cfc**

```
component extends="Gateway" {
        fields = [
                  field("Interval (ms)","interval","5000",true,"The interval used for checking on log events","text"),
            field("Log level","logLevel","Debug",true,"Log level for the log file. Possible values are:<ul>
        <li>Info - Starting, stopping and errors will be logged.</li>
        <li>Warning - Nothing will be logged.</li>
        <li>Error - Only errors will be logged.</li>
        <li>Debug - Detailled messages will be logged.</li></ul>",
        "select","Info,Warning,Error,Debug"
            ),
            field("Log Filename","logFileName","susi.log",true,"The file name to be used for logging.","text")
           ];

public string function getClass() {          return ""; }
           public string function getCFCPath() { return "lucee.extension.gateway.CustomLogger"; }
           public string function getLabel() { return "Custom Logger"; }
           public string function getDescription() { return "Catches log calls and stores them in log files"; }

           public string function onBeforeUpdate(required string cfcPath, required string startupMode, required struct custom) {
            // interval
            if (!isNumeric(custom.interval)) {
                      throw "interval [#custom.interval#] is not a numeric value";
            } else if (custom.interval LT 1) {
                      throw "interval [#custom.interval#] must be a positive number greater than 0";
            }
           }

}
```

In the above CustomLoggerDriver.cfc in the body of the component an array is defined containing the fields of the event gateway. Each element is defined by a function called field. The field function is mapped to the component Field.cfc (internal convention based Lucee calls implement this function mapping) and takes the following arguments:

* displayName string
* name string
* defaultValue string
* required boolean
* description any
* type string
* values string

The values above are quite self-describing. So with the function field() and the above parameters, you can define the form for the configuration of your EG. The variable names are important, since they will be passed along as in struct as an argument of the init function of the EG itself.

### Driver Component Methods

The following functions are available in the driver CFC and can be used in order to influence the display and setup of the EG driver. The driver is of the same kind as the datasource drivers, so some of the functions are not necessary:

* getClass()
required only with Datasource Drivers
* getCFCPath()
contains the path to the event gateway itself. In our example the component points to lucee.extension.gateway.CustomLogger which is in the directory of the auto included components (eg. /WEB-INF/lucee/components)
* getLabel()
contains the label of the driver for selection of the Gateway
* getDescription()
The description appears at the top of the form displayed for defining the configuration values

   * onBeforeUpdate
This method allows you to do sanity checks with the values entered, like checking whether the interval is numeric or not. It is called on submission of the form. If you throw an error, the error will be displayed at the top of the form.

After we have created the driver CFC, we need to copy it to the directory WEB-INF/lucee/context/admin/gdrivers. If the file has no syntax errors, the new driver should be available in the drop down list for new event gateways.

When the values displayed by the EG-driver are saved, the EG might be starting up right away (depending on the mode). EG startupmode:

* Automatic; In automatic mode, the EG will be started as soon as the context will be started. If you are using dynamic hosts, the EG will only start as soon as the particular host is called for the first time. Disabled obviously disables the EG. Consider it similar to Windows Services or Linux Daemons.
* Manual; You have to call the start/stop methods (hit the button) in order to start/stop the EG. The EG will not start at engine startup
* Disabled

Basically when an EG is started up (according to its startup mode) is an endless loop that waits for events to happen. In our current example we will create a custom logger, that logs events to a file system with the help of the CFML function eventGatewayMessage(). The CFC looks like the one further above. In our case, the CustomLoggerDriver.cfc already allows us to define the following keys in the configuration struct for the EG:

* interval
* logLevel
* logFileName

These values are important for our EG which we will look at in a bit. The EG itself has been defined in the EG Driver with the help of the method getCFCPath(). So next, lets have a look at the CFC we defined above: lucee.extension.gateway.CustomLogger

You can use any component path you like here. In the above example we are actually pointing to a directory inside the Lucee configuration directory. It is easier to store all components in that place, so that they are tied to the context you are in. Of course you can use any other mapping you desire. Here is the CustomLogger.cfc:

```
component {
           variables.state   = "stopped";
           variables.aLogs   = [];
           variables.stTypes = {'debug':1,'info':2,'error':3,'quiet':4};

           public void function init(string id, struct config) { … }
           public void function start() { … }
           public void function stop() { … }
           public void function restart() { … }
           public string function getState() { return state; }
           public any function sendMessage(struct data) { … }
           private void function _handleError(struct catchData = {}, string functionName) { … }
           private void function _log(required string sText, string sType = "quiet") { … }
}
```

We will have a look at the individual functions in more detail below.

When a Lucee context is started and there are EG's defined for the context, they will be started and after the init function has been called, the start method will be called (if the startup mode is set to automatic) by Lucee. So let's have a closer look at the details.

The init method will be called when the EG is first called either at startup or when initiated the start procedure is initiated when the start button is pressed in the Lucee Web Administrator.
In the above CFC, we are initializing the status variable and an array of log messages that we will process later on.

```
variables.state   = "stopped";
variables.aLogs   = [];
variables.stTypes = {'debug':1,'info':2,'error':3,'quiet':4};
```

The state is the label displayed when the EG is stopped or started or when it is about to start. When Lucee is determining in which state an EG is, it will call the getState() method of the EG CFC. You can actually use any state you like. We tend to use the state labels stopped, stopping, running and starting.

When first initialized (startup of the context), the init() method is called. In our case, the init() method is just storing the passed arguments in the variables scope of the component and log a message to an EG logfile.

```
public void function init(string id, struct config) {
           local.cfcatch = "";
           try {
                  variables.id = arguments.id;
                  variables.config = arguments.config;
                  _log("init");
           } catch (e) {
                  _handleError(cfcatch, "init");
           }
}
```

The arguments of the init() method are:

* id
The ID is the name of the EG. You will need this name (which has to be unique per contex) to address any message you are sending to the EG.
* config
The config argument is a struct which contains the variables that you have defined and the user has set in the instantiation of the EG. The EG driver allows you, as mentioned above, to define additional values which you now receive. Storing them in the variables scope helps us reference them for later.

One interesting thing can be deducted from the above lines. The component that has been initiated will exist for the entire time the EG has been started. This is the case because the start method actually intentionally ends up in an endless loop, so the component never is destroyed.

Next to that, even if a component is stopped, the get getState() method returns the correct value. So actually the EG is a singleton in the context that you are in.

The start() method is either called in case the startup method is set to automatic at context startup time, or whenever the start method is initialized by the pressing of the start button in the Lucee Web Administrator. So let's have a look at the current start() method:

```
public void function start() {
           local.sleepStep = variables.config.interval gt 2000 ? variables.config.interval : 2000;
try {
                      state="starting";
       state="running";
                  while(variables.state EQ "running") {
                         loop array="#variables.aLogs#" index="local.iMsg" item="local.stLog" {
                               _log(stLog.message, stLog.type);
                         };
                         variables.aLogs = [];
                         sleep(sleepStep);
                  }
           } catch (e) {
                  state="failed : #cfcatch.message#";
                  _handleError(cfcatch, "init");
                  rethrow;
}
}
```

What the start method actually does is looping and eventually executing stuff that comes in through the sendMessage() method described later.

First of all the start() method makes sure, that the value of the field interval defined in the custom configuration is not exceeding 2000 (ms).

Then, the state is changed from stopped to starting and then to running. After this the code goes into an endless loop, which depends on the content of the state variable. So you can easily understand that when the administrator button "stop" is pressed, the status would change to stopped and the endless loop will be terminated.

Inside the loop the EG is checking on the existence or rather the length of a message variable and calls the _log() function for every single entry. After this, the loop is paused by the sleep() function which takes the configured wait time as an argument.

Now during the sleep time, there might be messages pouring in and stored in the aLogs variable. The _log() function is actually not necessary in any EG. It is only a custom one that we have written in order to write stuff out to a file.

So core to the EG are the functions init(), start(), stop(), restart(), getState() and sendMessage(). All together help you define an EG.

In our example we will have a closer look at the sendMessage() method and how it is used. The sendMessage() method looks like follows:

```
public any function sendMessage(struct data) {
           // data receives some data to log
           /*
           - Check whether necessary data exists: data.keyExists("")
           - when type is missing, cfthrow with available types
           - types are available in variables.stTypes.
           */
           local.sMessage = "";
           local.sDetail = "";

           if (!arguments.data.keyExists("message")) {
                  sMessage &= "#chr(10)#Key message is required in the data struct for sendMessage(customLogger).";
           }

           if (!arguments.data.keyExists("type")) {
                  sMessage &= "#chr(10)#Key type is required in the data struct for sendMessage(customLogger).";
                  local.availTypes = "";
                  loop collection="#variables.stTypes#" item="local.sTypes" {
                         availTypes &= "#chr(10)#- #sTypes#";
                  }
                  sDetail &= "#chr(10)#Available types are: #availTypes#";
           } else if (!stTypes.keyExists(arguments.data.type)) {
                  local.availTypes = "";
                  loop collection="#variables.stTypes#" item="local.sTypes" {
                         availTypes &= "#chr(10)#- #sTypes#";
                  }
                      sMessage &= "#chr(10)#Type #arguments.data.type# is not available.";
                  sDetail &= "#chr(10)#Available types are: #availTypes#";
           }

           if (!isEmpty(local.sMessage)) {
                  throw(message:sMessage, detail:sDetail);
           }

           variables.aLogs.append(arguments.data);

}
```

The EG method is called, when you use the function sendGatewayMessage() in any of your applications. The arguments for the function are the ID of the gateway (defined in the web administrator, when you create the gateway) and any additional argument you define in the method above.

In this case we are passing in a struct that contains the level and the message to log. The most of the lines are just sanity checks, so that the line

```
variables.aLogs.append(arguments.data);
```

is executed with useful data. So let's see this event gateway in action. After we have defined the custom Logger EG in the administrator and stored the customLogger.cfc in the corresponding directory, let's use some code to check the functionality of the EG.

The two methods errorHandling() and _log() are helper functions which actually either write the data or catch exceptions.

## Testing the Event Gateway

I have created a template called testGateway.cfm and use the following code to test the result.

```
<cfset sMessage = "something I need to log.">
<cfset sendGatewayMessage("logMe", {})>
```

<img src="/uploads/default/original/1X/a127ee6bf8b4df77c6956ba2cada99ab4642e7ff.jpg" width="593" height="163">

Now the sanity checks kick in and prevent faulty data from being sent to the Gateway. So once we change the code to this:

```
<cfset sMessage = "something I need to log.">
<cfset sendGatewayMessage("logMe", {message:sMessage, type:"error"})>
```

We receive the expected blank page. In the background the message has been passed to the Gateway through the sendGateway() method and the data will be written by the start() endless loop into the logfile with the help of the method _log().

How you actually write your EG is totally up to you. But now, do it in CFML!

## Further examples for Event Gateway implementations

Above we have introduced the possibility to asynchronously log some data to a log file. There are additional other Event Gateways you can think of or use:

* ICQ watcher
* Slack Channel inspector
* Listen to a socket
* On incoming email

The possibilities are huge and we expect several new event gateways to emerge in the next few months. Have fun with Lucee.