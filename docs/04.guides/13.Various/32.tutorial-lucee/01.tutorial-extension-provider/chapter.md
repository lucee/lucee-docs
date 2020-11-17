---
title: Extension Provider
id: tutorial-extension-provider
categories:
- extensions
description: Tutorial, Creating an extension for Lucee 3.1
---

### Creating an extension for Lucee 3.1 ###

For this exercise in building a Lucee Extension, we're going to be building one for MangoBlog. [Mango Blog](http://www.mangoblog.org/) is a cool open source blog application written by [Laura Arguello](http://www.asfusion.com/). This tutorial is a series of several entries since it covers a lot of ground.

### To prepare for this exercise, you will need the following: ###

* Lucee 3.1 installed. You can use the express version if you wish.
* Mango Blog downloaded
* A CFC named ExtensionProvider.cfc
* A Database Server like MySQL or SQL Server

Go to the [Lucee Extension Store](https://download.lucee.org/)

### Background information ###

If you want to write an application extension for Lucee you need to do the following things:

1. Create a local ExtensionProvider.cfc that lists the metadata of all available applications and offers the corresponding installation archive.
1. Return a query in the ExtensionProvider.cfc:listApplications() method with your application and the necessary metadata (like blog location, forum location, support, image, video etc.)
1. Create a zip file containing the complete application files in it.
1. Create a config.xml file containing the forms that collect the data one needs to fill out upon installation.
1. Create a cfc called install.cfc containing the three methods install, uninstall and update.
1. Extend one of the available helper cfc's in order to have some additional methods for common procedures available like createMapping, createDatasource etc.
1. Write your install procedure so that the application get's installed according to its requirements.

Tutorial Sections

[[tutorial-extension-provider-part1]]

[[tutorial-extension-provider-part2]]

[[tutorial-extension-provider-part3]]

[[tutorial-extension-provider-part4]]

[[tutorial-extension-provider-part5]]
