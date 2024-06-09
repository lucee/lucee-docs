<!--
{
  "title": "Monitoring - Enable for your session",
  "id": "monitoring-enable-for-your-session",
  "since": "6.1", 
  "categories": [
    "monitoring"
  ],
  "description": "Shows you a way to enable Monitoring for your session",
  "keywords": [
    "monitoring",
    "session"
  ]
}
-->
# Monitoring - Enable for your session

This shows you a way to enable Monitoring for your session, this only works with Lucee 6.1 and above.
In Lucee 6.1 you can not only enable/disable that debugging is shown in the Website, you can also enable debugging, or better the different debug options in the Application.cfc (or Environment Variables), without having any negative performance impact for other.
Still per carful with deploying this to a public facing server, because this will expose information about the web server.

So you simply add the following code in your Application.cfc
```lucee

	if(!isNull(url.show) || isNull(session.show)) {
		session.show=url.show?:true;
	}

	this.monitoring.showDebug = session.show;
	this.monitoring.showDoc = session.show;
	this.monitoring.showMetric = session.show;

	this.monitoring.debuggingTemplate = session.show;
	this.monitoring.debuggingDatabase = session.show;
	this.monitoring.debuggingException = session.show;
	this.monitoring.debuggingTracing = session.show;
	this.monitoring.debuggingDump = session.show;
	this.monitoring.debuggingTimer = session.show;
	this.monitoring.debuggingImplicitAccess = session.show;
	this.monitoring.debuggingThread = session.show;

```
Then you add `show=true` to show the debugging or `show=false` to disable it again.

Of course you can lock that down a bit, by requesting a more specific string.
```lucee
	if(!isNull(url.fsdfsdfdfgdgdfs) || isNull(session.show)) {
		session.show=url.fsdfsdfdfgdgdfs?:true;
	}
```