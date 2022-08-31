---
title: How to update Lucee
id: updating-lucee-update
---

# How to update an existing installation #

To update an existing Lucee Installation go to "Services/Update" in your Lucee Server Administrator.

If a patch is available, Lucee will display a box detailing the changes made in this and all intermediate patches. Simply click the "execute" button to patch your current version.

You can choose from Releases, Pre Releases or Snapshots (Bleeding Edge). You can even define a custom update provider for your builds!

![update.png](/images/04.guides/03.updating-lucee/services-updates.png)

## Updating the first release (4.5.0.042) ##

Unfortunately the first Lucee release cannot be updated from within the Lucee Administrator and needs to be updated manually as follows:

1. Download the "lucee.jar" from the [Lucee downloads page](http://stable.lucee.org/download/?type=releases).
2. Stop your Lucee Server (the Servlet Engine).
3. Replace the existing lucee.jar, with the downloaded version.
4. Restart your Lucee Server.

## Firewall ##

Updating via the Administrator may not work if you are behind a firewall, in which case simply follow the instructions below:

1. Download the latest ".lco" file from the [Lucee downloads page](http://stable.lucee.org/download/?type=releases).
2. Stop your Lucee Server
3. Copy the downloaded file to "{server-context}/patches" (the server context is normally at "{Lucee-Server}/lib/ext/lucee-server/patches").
3. Restart Lucee.
