---
title: Deploying Lucee
id: deploying-lucee-server-apps
categories:
- server
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
