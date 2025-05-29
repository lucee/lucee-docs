Path to a custom tag library or a JSP tag library descriptor (TLD).

As cfimport is a compiler directive,  `Application.cfc` mappings won't work, but mappings configured via the admin will.

Used in conjunction with the `prefix` attribute to import custom tags:

```cfml
<cfimport prefix="my" taglib="/path/to/tags/">
```

In script:

```cfml
cfimport(prefix="my", taglib="/path/to/tags/");
```