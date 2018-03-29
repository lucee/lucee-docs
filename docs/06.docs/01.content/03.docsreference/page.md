---
title: Cross referencing documentation pages
id: docs-reference-pages
---

Pages that document [[functions]] and [[tags]] are a little more involved than standard documentation page types. They still use the same basic [[docs-structure|page tree system]] but pull in extra information from Lucee source code and make use of multiple markdown files to produce the final output.

>>>>>> Folders and markdown files that begin with an underscore, `_`, are ignored by the documentation tree builder and are used to supplement various page types such as function and tag reference pages.

## Functions

The basic folder structure of a function reference is as follows:

```
/nameoffunction
    /_arguments
    	argument1name.md
    	argument2name.md
    _examples.md
    function.md
```

The `function.md` file indicates that this page is a **function** page type. Its content will consist of YAML front matter to indicate its page title, id and any related content and categories, and the description of the function.

The `_examples.md` file is an optional plain markdown file that can be use to provide examples for the function. 

The `_arguments` folder should contain a single markdown file per named argument that the function accepts. The name of the file corresponds to the name of the argument. The content of the markdown file provides the description of the argument.

All other reference material, such as argument types and mandatory status, are taken from the Lucee source code.

## Tags

The basic folder structure of a function reference is as follows:

```
/nameoftag
    /_attributes
    	attribute1name.md
    	attribute2name.md
    _examples.md
    tag.md
```

The `tag.md` file indicates that this page is a **tag** page type. Its content will consist of YAML front matter to indicate its page title, id and any related content and categories, and the description of the tag.

The `_examples.md` file is an optional plain markdown file that can be use to provide examples for the tag. 

The `_attributes` folder should contain a single markdown file per named attribute that the tag accepts. The name of the file corresponds to the name of the attribute. The content of the markdown file provides the description of the attribute.

All other reference material, such as attribute types and mandatory status, and tag formatting options are taken from the Lucee source code.