---
title: Extension Installation
id: extension-installation
categories:
- extensions
description: How to install Lucee extensions, manually, via a environment variable or via the admin
---

## Extensions ##

In this section, you'll find information about Lucee extension installation, which can be used to add Functions, Tags, JDBC/Cache drivers and Admin Plugins to Lucee Server.

There are several different ways to install extensions in Lucee.

### Extension installation via Admin ###

Extensions can be installed via the web or server admin. 

If you want to use an Extension for the whole server, you should install it under the Server Admin. If you want the extension for just for only a single web context, install it via the Web admin.

All available Extensions are listed under  **Extension -> Applications**

![Extension](assets/images/screenImages/Extension.png)

Here you can see which extensions are installed and not installed.

Installed extensions, with an update available have a red overlay.

![Extension Details](assets/images/screenImages/Extension_Detail.png)

On the Extension detail page, you can upgrade or downgrade the version or uninstall it.

With JDBC drivers, choose the version you require, the version numbers are based on the undelying JDBC Library. 

By default Lucee allows installing extensions from the following sites

- <https://downloads.lucee.org> (Official LAS Extensions)
- and <https://www.forgebox.io/type/lucee-extensions> (third party, community)

### Extension installation via lex file ###

To install an extension using the file system, first download the `.lex` file for the extension.

You can download it from the url [https://download.lucee.org/](https://download.lucee.org/)

Copy the `.lex` file into your ```lucee-server/deploy/``` folder. Wait for a minute, it deploy the extension automatically. You can see the installation message on `deploy.log` files.

Another way you can upload the `.lex` file in admin, You can see "Upload new extension (experimental)" at bottom of **Extension -> Applications** page.

* Click the browse button,
* Choose the `.lex` file,
* Click the upload button, and the Extension will be automatically installed

### Extension installation via an Environment Variable ###

Lucee will automatically install extensions on startup, if an environment variable is set.

`LUCEE_EXTENSIONS=D46B46A9-A0E3-44E1-D972A04AC3A8DC10;version=1.0.19.19`

See [[running-lucee-system-properties]]

### Footnotes ###

Here you can see this details on video also

[Extension Installation](https://www.youtube.com/watch?time_continue=184&v=Vcu0OENm_ks)
