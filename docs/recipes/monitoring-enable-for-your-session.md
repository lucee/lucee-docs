---
title: Monitoring - Enable for your session
id: monitoring-enable-for-your-session
categories:
- debugging
- monitoring
- session
since: '6.1'
description: Shows you a way to enable Monitoring for your session
keywords: monitoring,session
---



# Monitoring - Enable for your session

This guide demonstrates how to enable monitoring for your session in Lucee 6.1 and above. Prior to Lucee 6.1, you could only enable or disable the display of debugging information using the `<cfsetting showDebugOutput="true|false">` tag. However, Lucee 6.1 introduces the ability to enable debugging itself directly in the `Application.cfc`.

**Note:** Be cautious when deploying this to a public-facing server, as it may expose sensitive information about your web server when not used correctly.

## Enabling/Disable Monitoring

To enable or disable monitoring for your session, add the following code to your `Application.cfc`:

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

To show debugging, add `show=true` to the URL. To disable debugging, add `show=false` to the URL.

For example:

- Enable debugging: `https://yourdomain.com?show=true`
- Disable debugging: `https://yourdomain.com?show=false`

## Enhanced Security

To enhance security, you can use a more specific string in the URL:

```lucee
if (!isNull(url.fsdfsdfdfgdgdfs) || isNull(session.show)) {
 session.show = url.fsdfsdfdfgdgdfs ?: true;
}
```

In this case, use `fsdfsdfdfgdgdfs=true` to enable debugging and `fsdfsdfdfgdgdfs=false` to disable it.

For example:

- Enable debugging: `https://yourdomain.com?fsdfsdfdfgdgdfs=true`
- Disable debugging: `https://yourdomain.com?fsdfsdfdfgdgdfs=false`

This additional string requirement helps ensure that only those who know the specific string can enable or disable debugging.
