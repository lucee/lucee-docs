---
title: New and modified functions
id: lucee-5-functions-tags
---

# Core Functions #
**Functions to do use core functionality of the system.**


###ObjectNew (new)###
`objectNew(string componentName[, any arguments]):component`

This function is a replacement for `createObject("component",...)` and you can use this function in the same way, however unlike `createObject("component",...)` this functions invokes the `init` method of the component, if there is one, and allows you to pass arguments to the `init` method.

```
#!javascript
// create a component from type `FullName` and invokes the constructor with 2 arguments in the form of an array
c=objectNew("my.FullName", ["Susi","Sorglos"]);

// create a component from type `FullName` and invokes the constructor with named arguments
c=objectNew("my.FullName",{firstame:"Susi",lastname:"Sorglos"});
```

Maybe you ask yourself "why this function?" when I can do the same with the `new` operator as follows:
```
#!javascript
c=new my.FullName("Susi","Sorglos");
```
This is true, but this function is made for the dynamic loading of components, for example components defined in a configuration file.
```
#!javascript
c=objectNew(config.componentName, config.arguments);
```


###Render (new) ###
`render(string code [,string dialect]):string`

Similar to the function `evaluate`, this function allows to execute CFML/Lucee code that you provide as a string.
```
#!javascript
render('<cfmail subject="Hi There!" from="#from#"  to="#to#">Salve!</cfmail> ');
```


###getTagData/getFunctionData (extended) ###
These 2 functions are now supporting a new argument named `dialect`.
Possible values are `CFML` or `Lucee`.
With this argument you can define the dialect you want details for, if not defined the dialect of the current template is used.


# Locale/Regional Functions #
**Functions specific for dealing with `locale` and  `timezone`. Lucee 5 now handles `locale` (java.util.Locale) and `timezone` (java.util.TimeZone) objects natively.
So the function `getLocale()` now returns a locale object and `getTimeZone()` now returns a timezone object. Of course Lucee can still handle string representations of these types as previously.**


###GetLocaleInfo (new)###
`getLocaleInfo([,locale locale [, locale displayLocale]]):struct`

This function merges the `locale` functions `getLocaleCountry, getLocaleDisplayName, getLocaleInfo, getLocaleLanguage` to a single function and "deprecate" the existin locale functions.

```
#!javascript
dump(getLocaleInfo(getLocale())); // shows information from a locale object
dump(getLocaleInfo("de_ch")); // shows information to a locale string
```


# OSGi Functions #
**Functions specific for dealing with OSGi.**

###BundleInfo (new)###
`bundleInfo(any object):struct`

If the given object is loaded via an OSGi bundle, this function returns the information about the bundle.

```
#!javascript
dump(bundleInfo(obj)); // dumps from what bundle the class of the given object comes from
```


###ManifestRead (new)###
`manifestRead(string pathToJarOrManifestFile):struct`

Reads a manifest file and returns the contents as a struct.
```
#!javascript
dump(manifestread("C:\whatever\whatever.jar")); // dumps the manifest from whatever.jar as a struct
```


###JavaNew (new)###
`javaNew(string className, string nameOrPath, string versionOrDelimiter):any`

This function is a replacement for `createObject("java",...)` and you can use this function in the same way, but in addition you can also load a class by defining a OSGi bundle and version. In that case Lucee will check if that class is available locally, if not it will try to download the necessary bundle from the update provider.
```
#!javascript
// Load a class with the definition of the bundle name and version, in this case we are using a different version than the one Lucee has in the core.
POIFSFileSystem=javaNew("org.apache.poi.poifs.filesystem.POIFSFileSystem","apache.poi","3.11.0");

// The second and third argument are optional, if the version does not matter simply omit it.
POIFSFileSystem=javaNew("org.apache.poi.poifs.filesystem.POIFSFileSystem","apache.poi");

// Or if the class is available in the environment
POIFSFileSystem=javaNew("org.apache.poi.poifs.filesystem.POIFSFileSystem");

// You can also still load objects the classic way, but this is not recommended.
POIFSFileSystem=javaNew("org.apache.poi.poifs.filesystem.POIFSFileSystem","C:\whatever\apache-poi.jar");
```


# Web Service Functions #
**Functions to handle web services.**

###WebserviceNew (new)###
`webserviceNew(string url [, struct arguments]):webserviceProxy`

Creates a web service proxy object, a reference to a remote webservice. This function is a replacement for the `createObject("webservice",...)` function.


# Cache Functions #
**With Lucee 5 we have added some cache functions related to "regions", but these functions only have only been added for compatibility to other CFML Engines. These functions are already marked as "deprecated" and we strongly suggest not to use them in new code.**

The functions are:

* cacheregionexists()
* cacheregionnew()
* cacheregionremove()
