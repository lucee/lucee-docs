---
title: Lucee 5 and OSGi
id: lucee-5-osgi
categories:
- java
description: Lucee 5 is completely based around OSGi
menuTitle: OSGi
---

## OSGi ##

**Lucee 5 is completely [OSGi](https://en.wikipedia.org/wiki/OSGi) based, OSGi is the defacto standard in most Java enterprise environments, to manage bundles (jar libraries) used by the environment.**

This means all libraries used are managed by Lucee itself as OSGi bundles, but this does not end with 3rd party libraries. Lucee handles it's own core as an OSGi bundle, Lucee archives (.lar files) and even our Java based extensions are all OSGi based.

So Lucee 5 is an OSGi engine that manages all libraries used.

## What is the benefit? ##

OSGi is a framework used in most major enterprise environments, it is well tested and stable.

OSGi allows for the running of different versions of the same library at the same time. Lucee for example is not using internally the latest version of the HSQLDB data source, but this does not stop you from using whichever version of this data source you like. OSGi allows you to use whichever version of a library you like, independent of what version of the same library Lucee itself is using or any other applications in the same environment.

We can update *every* library Lucee is using at any time without issue and without the need to restart the JVM. This means that Lucee patches can include updated libraries, making Lucee a lot more flexible than it was in the past.

## Can I benefit from OSGi somehow? ##

Yes you can, Lucee 5.0 also comes with some enhancements to the [[function-createObject]] function to use OSGi features directly.

Today you use `createObject('java',"my.class.Path")` to create Java objects, but with the power of OSGi under the hood we can do more!

Lucee 5 introduces two additional arguments to the `createObject()` function to load Java objects, this functions interface is optimized to OSGi:

```luceescript
createObject( string type , string className [, string bundleName, string bundleVersion]);
```

For example:

```luceescript
dtf=createObject( 'java' , 'org.joda.time.format.DateTimeFormat' , 'org-joda-time' , '2.1.0');
```

Only the type and class name are required all other arguments are optional. Lucee will also download the bundles from the update provider automatically if they are not available locally.

The Lucee update provider already provides a wide range of bundles in various versions and this will be added to continuously overtime.

You can therefore load a certain class in a specific version, even, for example, if the Lucee core is using the same class with a different version.

OSGi is the biggest change in the Lucee 5.0 release that brings Lucee to a completely new level. Whilst it maybe not a dazzling new feature, it is a necessary one for an engine to be used in the enterprise segment.
