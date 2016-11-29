---
title: Admin Plugins
id: plugins
---

# Admin Plugins

Lucee extensions can contribute pages to the web-based administrator that allow you to interact with the user, collection licensing details or display data.
To bundle a plugin with your Lucee extension, create a directory called `plugins` in your extension.  Any folders inside the plugins directory will be a plugin named after the folder name they are contained in.

[[lucee-5-extensions]]See our guide on building Lucee extensions.

## Conventions

Lucee plugins operate largley by convention.  Creating files with specific names will automatically be picked up.  Lucee plugins
follow a rough MVC format and allow for cross-language translations out of the box.

```
/plugins
  /myPlugin
```

### Translation and menu item control

Lucee will look for a file called `langauge.xml` in the root of your plugin folder.

```
/plugins
  /myPlugin
    /language.xml
```

This file provides a basic resource bundle so your code can handle multuple languages.  You don't need to worry about the user selecting the language-- Lucee already has that in the admin.
Just provide each translation and it will get used automatically. Let's look at an example:

```
<?xml version="1.0" encoding="UTF-8"?>
<languages action="myPlugin" position="5">
	<language key="en">
		<group>Menu Name</group>
		<title>My Plugin</title>
		<description>This is my sample plugin.</description>
		<custom key="sayhi">Welcome</custom>
		<custom key="btnSubmit">Activate</custom>
	</language>
	<language key="de">
		<group>Menübezeichnung</group>
		<title>Mein plugin</title>
		<description>Dies ist meine Beispiel-Plugin.</description>
		<custom key="sayhi">Willkommen</custom>
		<custom key="btnSubmit">Aktivieren</custom>
	</language>
</languages>
```

Let's break down the pieces there.

* **action** - The top level menu item to create.  If omitted, your plugin will go under a default menu item.
* **position** - The optional numeric position of where to place the new top level menu item.
* **Language tag** - Create one of these tags for each language you wish to support.  The `key` attribute specifies the language.
 * **group tag** - This specifies the top level group to create your new menu item under
 * **title tag** - This is the human-readable menu name to create.
 * **description tag** - This text will automatically appear at the top of your views. 
 * **custom tag** - Create one of these for each individual peice of text you wish to translate.  The `key` attribute will be how you access the translation.
 
 ### Controller
 
 Lucee will also look for a file called `Action.cfc` in your plugin folder.  This acts as a controller to help process your views.

```
/plugins
  /myPlugin
    /Action.cfc
```
This CFC needs to extend the class `lucee.admin.plugin.Plugin` and has no required method.  The following methods are looked for by convention though:
* `init( struct lang, struct app )` - test
* `overview( struct lang, struct app, struct req )` - test
* `init( struct lang, struct app, struct req )` - test
