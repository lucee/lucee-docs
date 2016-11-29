---
title: Admin Plugins
id: plugins
---

# Admin Plugins

Lucee extensions can contribute pages to the web-based administrator that allow you to interact with the user, collection licensing details or display data.
To bundle a plugin with your Lucee extension, create a directory called `plugins` in your extension.  Any folders inside the plugins directory will be a plugin named after the folder name they are contained in.

[[lucee-5-extensions]] - See our guide on building Lucee extensions.

## Conventions

Lucee plugins operate largley by convention.  Creating files with specific names will automatically be picked up.  Lucee plugins
follow a rough MVC format and allow for cross-language translations out of the box.

```
/plugins
  /myPlugin
```

## Translation and menu item control

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
		<custom key="btnSubmit">Save</custom>
	</language>
	<language key="de">
		<group>Menübezeichnung</group>
		<title>Mein plugin</title>
		<description>Dies ist meine Beispiel-Plugin.</description>
		<custom key="sayhi">Willkommen</custom>
		<custom key="btnSubmit">Speichern</custom>
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
 
## Controller
 
 Lucee will also look for a file called `Action.cfc` in your plugin folder.  This acts as a controller to help process your views.

```
/plugins
  /myPlugin
    /Action.cfc
```

### Controller layout

This CFC needs to extend the class `lucee.admin.plugin.Plugin` and has no required method.  The following methods are looked for by convention though.  Your `Action.cfc` will be created once and cached as a singleton. 

* `init( struct lang, struct app )` - If this method exists, it will be called once when the component is initialized.  Use it to prepare the controller, set up variables, or initialize settings.  
* `overview( struct lang, struct app, struct req )` - This is the default action for the plugin and will be run if it exists.  
* `myCustomAction( struct lang, struct app, struct req )` - Create as many additional methods as you need to represent actions your plugin needs to perform.  You can create links or forms that submit to these actions.

Here's an overview of the parameters described above:

* `lang` is a struct of translated keys from your `langauge.xml` file based on the current language the user has selected.  You can refernce translated strings as a normal CFML variable like `#lang.sayhi#`.
* `app` is a struct of data for this plugin persisted in the application scope
* `req` is a struct containing `form` and `url` variables for the request.

### Controller helper methods

The base `lucee.admin.plugin.Plugin` component provides you with the following helper functions.

* `load()` - Will return data that is specific to this plugin and persistend across restarts
* `save( data )` - Pass in data to persist that will be returned by `load()`
* `action( string action, string qs )` - Generates a URL to an action in your plugin.  `action` is the name of the action and `qs` is the query string to include.

### Controller flow control

Your controller methods can return one of the following things:
* **Nothing** - If a view `.cfm` file exists with the same name of the method, it will be called
* **The string "redirect:actionName"** - No view will be rendered and the browser will be redirected to the action name you specify.
* **The string "_none"** - This tells Lucee not to try and render a view.

#### Sample Controller

Here is a simple `Action.cfc` for you to copy from.
```
component extends='lucee.admin.plugin.Plugin' {
	
	/**
	* This function will be called once to initalize the plugin
	* 
	* @lang A struct of translated keys based on selected language
	* @app A struct of data for this plugin persisted in the application scope
	*/
	function init( struct lang, struct app ) {
		// Load up the plugin's data into memory
		app.note = load();
	}

	/**
	* The default action name by convention
	* 
	* @lang A struct of translated keys based on selected language
	* @app A struct of data for this plugin persisted in the application scope
	* @req A struct containing  form and url variables for the request.
	*/
	function overview( struct lang, struct app, struct req ) {
		// Set the data into the req "scope"
		req.note = app.note;
	}

	/**
	* Save the form.  We'll submit here from the view
	* 
	* @lang A struct of translated keys based on selected language
	* @app A struct of data for this plugin persisted in the application scope() and save()
	* @req A struct containing  form and url variables for the request.
	*/
	function update( struct lang, struct app, struct req ) {
		// Set data back into memory
		app.note = req.note;
		// Persist data to disk
		save( app.note );
		// Redirect back to main page
		return 'redirect:overview';
	}
	 
}
```

## Views

Lucee will look for a `.cfm` file that matches the name of the current action being run.  This will happen even if there is no controller method for the action which means the simplest plugin can just be a view all by itself.


```
/plugins
  /myPlugin
    /overview.cfm
    /myCustomAction.cfm
```

There are no special requirements for views.  The HTML they output will be displayed to the screen.  Views are rendered inside your `Action.cfc` component so they have access to any methods and settings there including `action()` which is used for building links.  Views also have access to the same `lang`, `app`, and `req` variables that action methods get so they can interact with request variables, language translations, or application storage.

### Sample View

Here is a sample view.  Note the use of `action()` to generate the URL to the update page, the use of `req.note` to access data set in the controller, and `lang.btnSubmit` to get the correctly-translated text for the UI.

```
<cfoutput>
<form action="#action( 'update' )#" method="post">
	<textarea name="note">#req.note#</textarea>
	<br />
	<input type="submit" name="submit" value="#lang.btnSubmit#">
</form>	
</cfoutput>
```

