<!--
{
  "title": "Monitoring/Debugging",
  "id": "monitoring-debugging",
  "since": "6.1",
  "description": "Learn about the changes in Lucee 6.1 regarding Monitoring and Debugging. Understand the old and new behavior, and how to configure the settings in Lucee Admin and Application.cfc.",
  "keywords": [
    "monitoring",
    "debugging",
    "admin",
    "Application.cfc",
    "cfsetting",
    "debug",
    "showdebugoutput",
    "cfapplication"
  ],
  "categories": [
    "monitoring",
    "debugging",
    "server"
  ]
}
-->

# Monitoring/Debugging

Lucee 6.1 changed how you handle Monitoring/Debugging.

## Old Behaviour

Previously, you enabled/disabled Debugging in admin and used `<cfsetting showDebugOutput="true|false">` to control output.

## New Behaviour

Lucee 6 overhauled this. "Metrics" and "Reference" are now independently controlled under "Monitoring".

### Lucee Admin

Debugging settings are now under "Monitoring" with a new "Output" page where you define which sections are shown:

- Debugging
- Metrics
- Documentation (formerly "Reference")
- Test (coming soon)

**Settings page**: Enable/disable individual debug options - if none enabled, debugging is disabled.

**Debug Templates page**: Choose template, limit to IP ranges, or use different templates per IP range.

**Logs page**: View last X requests - useful when debugging isn't shown in output.

### Application.cfc

Lucee 6.1 lets you override all settings in Application.cfc:

```lucee
this.monitoring.showDebug = true;
this.monitoring.showDoc = true;
this.monitoring.showMetric = true;
this.monitoring.showTest = true; // following soon
```

Enable/disable debug options:

```lucee
this.monitoring.debuggingTemplate = true;
this.monitoring.debuggingDatabase = true;
this.monitoring.debuggingException = true;
this.monitoring.debuggingTracing = true;
this.monitoring.debuggingDump = true;
this.monitoring.debuggingTimer = true;
this.monitoring.debuggingImplicitAccess = true;
this.monitoring.debuggingThread = true;
```

Export settings from Admin on the Monitoring/Settings page.

### In Your Code

Change settings at runtime with `<cfapplication>`:

```lucee
<cfapplication
    action="update"
    showDebug="false"
    showDoc="true"
    showMetric="false"
    showTest="false"
    debuggingTemplate="false"
    debuggingDatabase="true">
```

Or `<cfsetting>` for "show" settings only (not debug options):

```lucee
<cfsetting
    showDebug="false"
    showDoc="true"
    showMetric="false"
    showTest="false">
```

#### Trade-off

Enabling `debuggingTemplate` mid-request won't capture earlier activity - but you can use this to exclude sensitive code:

```lucee
try {
    application action="update" debuggingTemplate=false;
    include "mysecretcode.cfm";
} finally {
    application action="update" debuggingTemplate=true;
}
```

## Tab Documentation (formerly Reference)

Now includes function/tag reference plus recipes like this one.

## Backward Compatibility

Fully backward compatible. The old `showDebugOutput` is now an alias for `show`:

```lucee
<cfsetting showDebugOutput="false">
```

Is equivalent to:

```lucee
<cfsetting show="false">
```
