---
title: Extension Installation
id: extension-installation
---
## Extensions ##

### Introduction ###

In this section, you'll find information about Lucee extension installation, which can be used to add functions, tags, JDBC/Cache drivers and admin plugins to Lucee Server

There are different ways to install the extension in lucee

### Extension installation via Admin ###

Extensions can be installed via the web or server admin. If you want to use the extension for the whole server means you need to install at server admin. If you want the extension for single web context installed in web admin.

It available in **Extension -> Applications**

![Extension](assets/images/screenImages/Extension.png)

Here we you can see the extension which is installed and not installed.

For installed extension if we have a update for the extension it simply showing with the label update, while clicking the extension it redirect to detail page of the extension

![Extension Details](assets/images/screenImages/Extension_Detail.PNG)

In this detail page you can upgrade or downgrade your versions and you can uninstall the extension.

It's most help ful for JDBC driver, choose the version you like. If you update the extension it download & install it automatically.

By default lucee use extension as http://extension.lucee.org.

### Extension installation via lex file ###

Install the extension using file system. For that you should download the lex file for the extension.

You can download it from the url [https://download.lucee.org/](https://download.lucee.org/)

Copy the lex file into your ```lucee-server/deploy/``` folder. Wait for a minute, it deploy the extension automatically. You can see the installation message on deploy.log files.

Another way you can upload the lex file in admin, You can see "Upload new extension (experimental)" at bottom of **Extension -> Applications** page.

* Click the browse button,
* Choose the lex file,
* Click the upload button,

Extension installed automatically.

### Footnotes ###

Here you can see this details on video also

[Extension Installation](https://www.youtube.com/watch?time_continue=184&v=Vcu0OENm_ks)
