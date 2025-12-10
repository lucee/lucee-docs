<!--
{
  "title": "Single Mode vs Multi Mode",
  "id": "single-vs-multi-mode",
  "description": "Understanding the differences between Single mode and Multi mode in Lucee.",
  "keywords": [
    "Lucee",
    "Single Mode",
    "Multi Mode",
    "Configuration"
  ],
  "categories": [
    "server"
  ],
  "since": "6.0",
  "related": [
    "lucee_7_overview"
  ]
}
-->

# Single Mode vs Multi Mode in Lucee

Lucee offers two modes: **Single Mode** and **Multi Mode**.

Multi Mode was the default in earlier versions, but Single Mode is simpler and now recommended. Lucee 7 only supports Single Mode.

Benefits of Single Mode:

- Simpler configuration - one admin, no redundant settings
- Unified logging
- Faster startup
- Future-proof - required for Lucee 7

## History

Adobe Coldfusion has always been single mode and never supported multi mode.

- **Lucee 5**: Only supported Multi Mode.
- **Lucee 6**: Introduced Single Mode. New installations start in Single Mode by default. However, if upgrading from Lucee 5, the system remains in Multi Mode unless manually changed.
- **Lucee 7**: Only supports Single mode - [[lucee_7_overview]]

A long time ago, in a galaxy far, far away...

Servers were expensive, memory was also scarce, Docker didn't exist and it was quite common for shared hosting to run many clients on the same server, so Lucee solved this problem with Multi Mode.

Really should have been a Star Trek reference, as Ralio, the project Lucee was forked from, was named after [Rhylo](https://memory-alpha.fandom.com/wiki/Rhylo)

The name Lucee was inspired by the Film [Lucy](https://en.wikipedia.org/wiki/Lucy_(2014_film)), a machine which took over the world.

## What is Multi Mode?

Multi Mode allows separate configurations for each web context.

Useful when running multiple web applications on a single server with different settings. However, this flexibility adds complexity to configuration, logging, and maintenance.

For example, in multi-mode the Lucee Admins have colour themes, Red is the Server Admin, Blue is the Web Admin.

If you only ever do configuration under the Red Server Admin, you are already quite close to using Lucee in single mode.

## What is Single Mode?

Single Mode consolidates all configurations into a single context.

Ideal for environments where multiple web contexts aren't needed. One config, simpler operations.

## Key Differences

- All hosts served by a Lucee instance share the same Application name space, so `myapp` on `host1` is the same as `myapp` on `host2`, consider using `cgi.http_host` etc as part of the application name, if required
- Mappings are the same across all hosts, so any application specific mappings should be done in `Application.cfc`, where as previously you might have done them in the Web Context Admin
- mod_cfml is still required in single mode when using multiple hosts with Apache
- Lower memory usage
- One single common log directory

### Configuration

- **Multi Mode**: Separate configs per web context - can overlap or conflict
- **Single Mode**: One unified config, one Lucee Administrator

### Scheduled Tasks

In single mode, check scheduled task names don't overlap when migrating.

### Logging

- **Multi Mode**: Logs split between web and server contexts
- **Single Mode**: All logs centralised under server context

### Performance

- **Multi Mode**: Slower startup - loads multiple configs
- **Single Mode**: Faster startup - one config

### Future Compatibility

Multi Mode was removed in Lucee 7.

## Switching Between Modes

Switch via the Lucee Administrator or `.CFConfig.json`.

### Using the Lucee Administrator

1. Go to the overview page
2. Current mode is shown at the top with an option to switch. In Multi Mode, you can merge configs or use server config only.

### Using `.CFConfig.json`

Set the `mode` flag:

```json
{
  "mode": "single"
}
```

```json
{
  "mode": "multi"
}
```

Note: This method doesn't support merging configs.
