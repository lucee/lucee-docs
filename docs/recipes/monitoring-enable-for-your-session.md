<!--
{
	"title": "Monitoring - Enable for your session",
	"id": "monitoring-enable-for-your-session",
	"categories": [
		"debugging",
		"monitoring",
		"session"
	],
	"since": "6.1",
	"description": "Shows you a way to enable Monitoring for your session",
	"keywords": [
		"monitoring",
		"session"
	]
}
-->

# Monitoring - Enable for your session

Since Lucee 6.1, you can enable debugging directly in `Application.cfc`. Previously, only `<cfsetting showDebugOutput="true|false">` was available.

**Note:** Be cautious when deploying this to a public-facing server, as it may expose sensitive information about your web server when not used correctly.

## Enable/Disable Monitoring

Add this to your `Application.cfc`:

```lucee
if (!isNull(url.show) || isNull(session.show)) {
 session.show = url.show ?: true;
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

## Activating and Deactivating Debugging

- Enable: `https://yourdomain.com?show=true`
- Disable: `https://yourdomain.com?show=false`

## Enhanced Security

Use a secret URL parameter instead of `show`:

```lucee
if (!isNull(url.fsdfsdfdfgdgdfs) || isNull(session.show)) {
 session.show = url.fsdfsdfdfgdgdfs ?: true;
}
```

- Enable: `https://yourdomain.com?fsdfsdfdfgdgdfs=true`
- Disable: `https://yourdomain.com?fsdfsdfdfgdgdfs=false`

Only those who know the parameter name can toggle debugging.
