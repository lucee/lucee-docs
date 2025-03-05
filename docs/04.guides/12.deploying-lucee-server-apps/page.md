---
title: Deploying Lucee
id: deploying-lucee-server-apps
categories:
- server
related:
- running-lucee-system-properties
- locking-down-lucee-server
- relocating-web-inf
- cookbook-check-for-changes
- config
forceSortOrder: '22'
---

[[securing-lucee-server-apps]]

[[cookbook-lockdown-guide]]

[[locking-down-your-lucee-stack]]

## The deploy folder

There is a `/deploy` folder under the `/lucee-server/` folder which can be used to customize Lucee .

The `/deploy` folder is polled on startup and every 60 seconds by Lucee's Controller thread.  It looks for `.lex` files (extensions), `.lco` files (lucee updates) and `.json` files for CFconfig snippets.

This is the simplest way to configure / install your Lucee instance at startup or on the fly, without needing to restart it.

### .json - CFConfig.json or config.json

Since Lucee 6.1.1, if Lucee finds a `.CFConfig.json` or `config.json` (in the `/deploy` folder) it will be automatically imported and applied to your running `CFconfig` configuration. [LDEV-4994](https://luceeserver.atlassian.net/browse/LDEV-4994)

You can also configure Lucee to [[cookbook-check-for-changes|monitor the server's .CFConfig.json file for changes]].

### .lex - Extensions

If Lucee finds an extension `.lex` in the `/deploy` folder, it will be installed (copying it to the `/installed` folder, among other things).

Extensions (`.lex`) can also be dropped in the `/lucee-server/context/extensions/available` folder and they can be installed using environment or JVM arguments without Lucee reaching out to the update provider.

### .lco - Lucee core updates

If Lucee finds a `.lco` jar in the `/deploy` folder, it copies it to the `/patches` folder, then it forces the engine to reload that core version immediately.

However, if there is already a newer Lucee core version in the `/patches/` folder, any older version will simply be ignored. In that case, you need to delete any newer `.lco` files from `/patches/` folder beforehand.

`/deploy` is polled every 60 seconds, `/patches` is only checked at startup.

The `/patches` folder is where Lucee's core `.lco` jars are kept.  When Lucee starts, it determines which `*.lco` in that folder is the latest version and it loads that version.

### Lucee Distributions 

available from [https://download.lucee.org/](https://download.lucee.org/)

- **Lucee.jar** (aka the fat jar) which includes Lucee core and loader, java bundles, the standard base set of extensions, admin and docs
- **Lucee-light.jar** which includes the lucee core and loader, java bundles, admin and docs
- **Lucee-zero.jar** which includes just the Lucee core and loader, java bundles (since 6.0.0.492)
- **lucee.lco** just the core Lucee engine, which can be used to update an existing Lucee installation

### Customized Installs

If you want to deploy a very targeted / customised install, start with Light or Zero and optionally add the extension(s) and `CFconfig.json` you required into the deploy folder, or set `LUCEE_EXTENSIONS` env var

### Warming up installs

You can pre warm a lucee installation, by setting the env var `LUCEE_ENABLE_WARMUP` to true, when set, Lucee will deploy itself, including processing any files found in the `/deploy` folder and then exit

### Admin and Docs extensions

You will see extensions, Lucee Admin and Lucee Docs, these simply install mappings to make them available. The admin is tightly coupled to the Lucee Version, so they aren't separately deployed

The Lucee Admin can be disabled by setting the env var `LUCEE_ADMIN_ENABLED=false` which is **recommended** for production/internet facing servers

### Console Logging

Since Lucee [6.2.0.310 / LDEV-3420](https://luceeserver.atlassian.net/browse/LDEV-3420), you can override the default logging configuration in `.CFconfig.json`, to redirect all logs to the console, which is very useful, especially with Docker.

Setting the env var `LUCEE_LOGGING_FORCE_APPENDER=console` globally overrides all logging configuration, to log out the console, using the existing configured log levels.

You can override the configured, per log file log levels using the env var `LUCEE_LOGGING_FORCE_LEVEL=INFO`

### Error Templates

By default, Lucee is configured to show detailed error messages, revealing server paths etc, which is great for developing.

This **should be disabled for production servers** by the following `.CFconfig.json` directives, or supply your own templates.

```
{
    "errorGeneralTemplate": "/lucee/templates/error/error-public.cfm",
    "errorMissingTemplate": "/lucee/templates/error/error-public.cfm"
}
```

### Firewalled Servers

`.lco` updates either via the Lucee Admin update page, or by dropping into the `/deploy` folder, may require dynamically downloading any updated jar files from the update server. As such they may fail attempting to download the new files.

To update firewalled servers, or to upgrade without Lucee downloading bundles (which is slightly slower), do the following

1. Stop the server
2. Download the (fat) lucee.jar (see below) from [https://download.lucee.org/](https://download.lucee.org/)
3. Delete or change the file extension for the fat jar in the `lucee/lib` folder, i.e `5.4.3.2.jar`
4. Copy the updated `lucee.jar` into that `lucee\lib` folder 
5. Start the server

### AWS Lambdas / Serverless

[Fuseless: Tools for running Serverless CFML Lambda Functions](https://fuseless.org/)
