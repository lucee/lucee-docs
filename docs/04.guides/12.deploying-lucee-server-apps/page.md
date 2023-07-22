---
title: Deploying Lucee
id: deploying-lucee-server-apps
categories:
- server
related:
- running-lucee-system-properties
- locking-down-lucee-server
- relocating-web-inf
forceSortOrder: '22'
---

[[securing-lucee-server-apps]]

[[cookbook-lockdown-guide]]

[[locking-down-your-lucee-stack]]

There is a `/deploy` folder under the `/lucee-server/` folder which can be used to drop in updates to Lucee.

The `/deploy` folder is polled every 60 seconds by Lucee's Controller thread.  It looks for (`.lex`) file and (`.lco`) files.

If Lucee finds an extension `.lex` (in the `/deploy` folder), it installs it (copying it to the `/installed` folder, among other things).

If Lucee finds a `.lco` jar (in the `/deploy` folder), it copies it to the `/patches` folder, then it forces the engine to reload that core version immediately.

However, if there is already a newer Lucee core version in the `/patches/` folder, any older version will simply be ignored. In that case, you need to delete any newer `.lco` files from `/patches/` folder beforehand.

`/deploy` is polled every 60 seconds, `/patches` is only checked at startup.

The `/deploy` folder is just a shortcut way to install the `.lco` version into the patches folder of a running Lucee server without needing to restart it.

The `/patches` folder is where Lucee's core `.lco` jars are kept.  When Lucee starts, it determines which `*.lco` in that folder is the latest version and it loads that version. 

Extensions (`.lex`) can also be dropped in the `/lucee-server/context/extensions/available` folder and they can be installed using environment or JVM arguments without Lucee reaching out to the update provider.

## Lucee Distributions 

available from [https://download.lucee.org/](https://download.lucee.org/)

- **Lucee.jar** (aka the far jar) which includes lucee core and loader, java bundles, the base set of extensions, admin and docs
- **Lucee-light.jar** which includes the lucee core and loader, java bundles, admin and docs
- **Lucee-zero.jar** which includes just the lucee core and loader, java bundles (since 6.0.0.492)
- **lucee.lco** just the core lucee engine, which can be used to update an existing Lucee installation

## Customized Installs

If you want to deploy a very targeted / customised install, start with Light or Zero and optionally add the extension(s) you want to use in the deploy folder, or set `LUCEE_EXTENSIONS` env var

## Warming up installs

You can pre warm a lucee installation, by setting the env var `LUCEE_ENABLE_WARMUP` to true, when set, Lucee will deploy and then exit

## Admin and Docs extensions

You will see extensions, Lucee Admin and Lucee Docs, these simply install mappings to make them available. The admin is tightly coupled to the Lucee Version, so they aren't separately deployed

## AWS Lambdas / Serverless

[Fuseless: Tools for running Serverless CFML Lambda Functions](https://fuseless.org/)
