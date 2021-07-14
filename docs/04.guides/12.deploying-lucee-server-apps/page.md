---
title: Deploying Lucee
id: deploying-lucee-server-apps
forceSortOrder: '22'
---

[[securing-lucee-server-apps]]

[[cookbook-lockdown-guide]]

[[locking-down-your-lucee-stack]]

There are two folders, `/deploy` and `/patches` under the `/lucee-server/` folder which can be used to drop in updates to Lucee.

The `/patches` folder is where Lucee's core jars go (`.lco`).  When Lucee starts, it determines which jar in that folder is the latest version and it classloads that one.

The `/deploy` folder is a folder polled every 60 seconds by Lucee's Controller thread.  It looks for (`.lex`) file and (`.lco`) files.

If Lucee find an extension (`.lex`), it installs it (copying it to the installed folder, among other things).

If it find a (`.lco`) jar, it copies it to the patches folder and forces the engine to reload the core classes immediately., however, if there is already a newer version of Lucee in the `/patches/` folder, it will be ignored. In that case, you need to delete any newer (`.lco`) files from `/patches/` first.

`/deploy` is polled every 60 seconds, `/patches` is only checked at startup.

And the `/deploy` folder is really just a shortcut to get the (`.lco`) into the patches folder of a running Lucee server without needing to restart it.

Extensions (`.lex`) can also be dropped in the `/lucee-server/context/extensions/available` folder and they can be installed using environment or JVM arguments without Lucee reaching out to the update provider.
