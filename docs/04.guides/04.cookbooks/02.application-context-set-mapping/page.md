---
title: Set a Mapping (regular, component and custom tag mapping)
id: cookbook-application-context-set-mapping
related:
- tag-application
menuTitle: Set a Mapping
---

# Set a regular Mapping #

Lucee allows to set directory mappings in your Application.cfc, this mappings are only valid for the current request.

```cfs
// Application.cfc
component {
    this.mappings['/shop']=getDirectoryFromPath(getCurrentTemplatePath())&"shop";
}
```

We define the mappings as a struct, where the key of the struct is the virtual path.

Now you can simply use that mapping in your code

```coldfusion
<cfinclude template="/shop/whatever.cfm"> <!--- load a template from the "shop" mapping --->
<cfset cfc=new shop.Whatever()><!--- load a CFC from the "shop" mapping (see also "this.componentpaths" for handling components) --->
```

## Component and Custom Tag Mappings ##

The previous example only has shown how to do a regular mapping, but Lucee is providing 3 types of mappings, regular component and custom tag mappings.

```cfs
// Application.cfc
component {
   this.componentpaths=[getDirectoryFromPath(getCurrentTemplatePath())&"testbox"];// mapping testbox components
   this.customtagpaths=[getDirectoryFromPath(getCurrentTemplatePath())&"helper"];// mapping a collection of helper custom tags

}
```

In difference to "this.mappings", " this.componentpaths" and "this.customtagpaths" are taking arrays as input and not structs, because in that case there is not "virtual path" that needs to be defined.

## Advanced ##

In the previous example we have simply set a path, like you can see in the admin a mapping can contain more data than only a physical path, of course you can use this settings also with a mapping done in the Application.cfc

```cfs
// Application.cfc
component {
   this.mappings['/shop']={
      physical:getDirectoryFromPath(getCurrentTemplatePath())&"shop",
      archive:getDirectoryFromPath(getCurrentTemplatePath())&"shop.lar",
      primary:"archive"
   };
}
```

In that case we not only define a physical path, we also define a Lucee archive (.lar). "primary" defines where Lucee is checking first for a resource, let's say you have the following code

```coldfusion
   <cfinclude template="/shop/whatever.cfm">
```

In that case Lucee first checks in the archive for "whatever.cfm", if not found there, it looks inside the physical path.

Of course this can be done for all mapping types

```cfs
// Application.cfc
component {
   this.componentpaths=[{archive:getDirectoryFromPath(getCurrentTemplatePath())&"testbox.lar"}];// loading testbox from an archive
   this.customtagpaths=[{archive:getDirectoryFromPath(getCurrentTemplatePath())&"helper.lar"}];// a collection of helper custom tags

   };
}
```
