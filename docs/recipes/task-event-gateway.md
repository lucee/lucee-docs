<!--
{
  "title": "Tasks Event Gateway Extension",
  "id": "task-event-gateway",
  "categories": [
    "event-gateways",
    "extensions"
  ],
  "description": "Long-running background tasks with hot reload, listeners, and cluster pause via the Tasks Event Gateway extension",
  "keywords": [
    "Tasks Event Gateway",
    "TEG",
    "Event Gateway",
    "background task",
    "worker",
    "listener",
    "sendGatewayMessage",
    "TasksGateway"
  ],
  "related": [
    "event-gateways",
    "event-gateways-how-they-work",
    "function-sendgatewaymessage",
    "scheduler-quartz",
    "extension-installation",
    "environment-variables-system-properties"
  ]
}
-->

# Tasks Event Gateway Extension

The Tasks Event Gateway (TEG) runs **continuous background workers** on Lucee Server. Each task is a CFML component (or `.cfm` template) that implements a repeating loop — you control sleep intervals, concurrency, and error backoff per task.

This is complementary to [[scheduler-quartz]]: use Quartz for cron-style, calendar-based jobs; use TEG for always-on loops (queue polling, sync workers, heartbeat jobs).

## Installation

Install via the Lucee Administrator, or see [[extension-installation]] for all options (Dockerfile, deploy folder, env var, `.CFConfig.json`).

- **Maven GAV:** `org.lucee:tasks-extension`
- **Extension ID:** `947C02B0-7AE4-4054-938A8E059DD7625A`
- **Source:** [github.com/lucee/task-event-gateway](https://github.com/lucee/task-event-gateway)
- **Downloads:** [download.lucee.org](https://download.lucee.org/#947C02B0-7AE4-4054-938A8E059DD7625A)

> Since extension **1.1.0.0**, installing the `.lex` file does **not** create a gateway instance. You must register one manually (below).

## Quick start

1. Install the extension.
2. Add a gateway instance (CFConfig or Administrator).
3. Create `core/tasks/MyWorker.cfc` extending `org.lucee.cfml.Task`.
4. Restart the gateway (or set `startupMode: automatic` and restart Lucee).
5. Watch the configured log for `Tasks Event Gateway:` lines.

### Gateway instance (`.CFConfig.json`)

```json
{
  "gateways": {
    "my-task": {
      "cfcPath": "org.lucee.cfml.TasksGateway",
      "listenerCFCPath": "",
      "startupMode": "automatic",
      "custom": {
        "package": "core.tasks",
        "templatePath": "",
        "templatePathRecursive": true,
        "checkForChangeInterval": 10,
        "checkForChangeNoMatchInterval": 60,
        "settingLocation": "",
        "checkForChangeSettingInterval": 0,
        "logName": "application"
      },
      "readOnly": "true"
    }
  }
}
```

In the Administrator: **Services → Event Gateways → Add Gateway → type Tasks**.

| Custom setting | Purpose |
|---|---|
| `package` | Dotted package scanned for Task/Listener CFCs (`core.tasks` → `/core/tasks/`) |
| `templatePath` | Optional folder of `.cfm` tasks (webroot path, mapping, or absolute path) |
| `templatePathRecursive` | Scan subfolders of `templatePath` (default `true`) |
| `checkForChangeInterval` | Seconds between reload checks for known task files |
| `checkForChangeNoMatchInterval` | Seconds between checks for non-task files in the scan path |
| `settingLocation` | Cache name for shared pause state across servers |
| `checkForChangeSettingInterval` | Poll interval for pause changes from other servers (`0` = off) |
| `logName` | Lucee log file for gateway output |

Gateway instance values override environment variables and JVM system properties. See [[environment-variables-system-properties]] for the `TASKS_EVENT_GATEWAY_*` names (e.g. `TASKS_EVENT_GATEWAY_PACKAGE`, `TASKS_EVENT_GATEWAY_CHECKFORCHANGENOMATCHINTERVAL`).

### Activator

By default the gateway uses `org.lucee.cfml.tasks.Activator`, whose `active()` always returns `true`. Point `tasks.event.gateway.activator` (or `TASKS_EVENT_GATEWAY_ACTIVATOR`) at your own CFC to disable the gateway during maintenance or when this node is not the cluster leader.

## Creating a task (CFC)

```cfc
component extends="org.lucee.cfml.Task" {

    property name="concurrentThreadCount"               type="numeric" default=1;
    property name="howLongToSleepAfterTheCall"          type="numeric" default=5000;
    property name="howLongToSleepAfterTheCallWhenError" type="numeric" default=60000;

    public void function invoke(
        required string id,
        required numeric iterations,
        required numeric errors,
        numeric lastExecutionTime,
        date lastExecutionDate,
        struct lastError
    ) {
        // worker logic here
    }
}
```

Task properties (all optional — defaults come from the base component):

| Property | Default | Meaning |
|---|---|---|
| `concurrentThreadCount` | `1` | Parallel threads for this task |
| `howLongToSleepBeforeTheCall` | `0` | ms before each invocation |
| `howLongToSleepAfterTheCall` | `0` | ms after success |
| `howLongToSleepAfterTheCallWhenError` | `60000` | ms after exception (back off to avoid log storms) |
| `howLongToWaitForTaskOnStop` | `10000` | Grace period on gateway stop |
| `forceStop` | `false` | Force-terminate thread after grace period |

The gateway hot-reloads task CFCs when their file timestamp changes (interval controlled by `checkForChangeInterval`).

## .cfm-based tasks

Set `templatePath` and add metadata to a comment block at the top of each template:

```cfm
<!---
@task                           "Legacy cron job"
@concurrentThreadCount          1
@howLongToSleepAfterTheCall     5000
--->
```

Templates run as internal requests (`Application.cfc` applies). Execution context is passed via `url.id`, `url.iterations`, `url.errors`, `url.lastExecutionTime`, `url.lastExecutionDate`, and `url.lastError`.

## Listeners

Components extending `org.lucee.cfml.Listener` in the same package receive lifecycle callbacks:

- `onExecutionStart` — before `invoke()`
- `onExecutionEnd` — after successful `invoke()`
- `onError` — when `invoke()` throws

Filter tasks with `allow` and `deny` (comma-separated, `*` and `?` wildcards; deny wins):

```cfc
property name="allow" type="string" default="*Queue*,MyWorker";
property name="deny"  type="string" default="*Test*";
```

## Runtime control (`sendGatewayMessage`)

Use [[function-sendgatewaymessage]] with the **gateway instance ID** as the first argument:

```cfc
sendGatewayMessage("my-task", { action: "state" });

info = sendGatewayMessage("my-task", { action: "info" });
dump(deserializeJSON(info));

sendGatewayMessage("my-task", { action: "pause",  task: "core.tasks.MyWorker" });
sendGatewayMessage("my-task", { action: "resume", task: "core.tasks.MyWorker" });
```

| Action | Description |
|---|---|
| `state` | Gateway state string (`running`, `stopped`, …) |
| `info` | JSON snapshot of tasks, thread instances, and timing |
| `pause` | Pause a task by full component/template name |
| `resume` | Resume a paused task |

With `settingLocation` set to a shared cache, pause state survives restarts and propagates to other servers when `checkForChangeSettingInterval` is enabled.

## Multiple gateway instances

You can register several TEG instances (different IDs) — for example one per application package or one for CFC tasks and one for `.cfm` templates. Each instance has its own scan path, log, and task pool. Use distinct `settingLocation` cache key prefixes via the gateway ID when sharing pause state.

## Troubleshooting

- **Gateway won't start** — Check activator; read the log named in `logName`; confirm `org.lucee.cfml.TasksGateway` is the gateway CFC path.
- **Task missing** — Verify `extends="org.lucee.cfml.Task"`, package name, and component mapping.
- **Template ignored** — `@task` metadata required; path must be under `templatePath` and reachable internally.
- **Stale code** — Wait for `checkForChangeInterval` or touch the file; ensure Lucee template inspection is not caching stale gateway drivers in older versions.
- **Runaway errors** — Raise `howLongToSleepAfterTheCallWhenError` on the task.

## See also

- [[event-gateways-how-they-work]] — gateway lifecycle and architecture
- [[scheduler-quartz]] — cron and calendar scheduling
- [Extension README](https://github.com/lucee/task-event-gateway/blob/master/README.md) — full reference including build instructions
