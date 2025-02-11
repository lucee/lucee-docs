<!--
{
  "title": "Supercharge your website",
  "id": "supercharge-your-website",
  "description": "This document explains how you can improve the performance of your website in a very short time with Lucee.",
  "keywords": [
    "Supercharge website",
    "Performance",
    "Caching",
    "Template cache",
    "Lucee"
  ],
  "categories": [
    "server"
  ]
}
-->

# Supercharge your website

How to improve performance of your production Lucee website using never inspect templates.

## Background

By default, when a source file has changed, Lucee will detect that change and recompile it, before executing it.

This is great when you are developing, but it's usually not needed for production servers, as you can imagine, checking every files for changes, does slow down performance.

For production servers, if you know your server does not produce or change any source files, using Inspect Templates `NEVER` avoids that overhead.

## Example:

```luceescript
// index.cfm
writeDump(now());
```

Run the above `index.cfm`, and you get a timestamp. Now change that file and call it again, the changes are automatically picked up.

Whenever we call our file, by default, Lucee checks once at every request if a file has changed or not (for files currently residing in the template cache).

## Setting InspectTemplates to NEVER using the Lucee Admin

- Go to _Admin -> Performance/ Caching -> Inspect Templates (CFM/CFC) -> Never_

- The default is "Once", checking any requested files one time within each request. You should check "Never" to avoid the checking at every request.

- Change the `index.cfm` and run it again. No changes happen in the output because Lucee does not check if the file changed or not. Now, you'll see the faster execution and less performance memory being used.

- You can flag all cached templates to be checked once for changes using [[function-inspectTemplates]]. This is more efficent than [[function-pagepoolclear]] which clears the entire template cache,  requiring every single template to be recompiled.

- Another option to clear the template cache is to use clear cache via the admin by clicking the button in _Admin -> Settings -> Performance/ Caching -> Page Pool Cache_.

Remember, the Lucee Admin is simply a GUI which edits `CFconfig.json`. It's written in CFML and if you want to do something the admin does, have a look at the source code.

## Setting InspectTemplates to NEVER using CFconfig.json

```
{ 
  "inspectTemplate": "never"
}
```

The `inspectTemplates` setting can also be configured per mapping, by default mappings inherit the server default.

```
{
  "mappings": {
    "/testbox": {
      "physical": "d:\\work\\TestBox",
      "primary": "physical",
      "topLevel": "true",
      "readOnly": "false",
      "inspectTemplate": "never"
    }
  }
}
```

## Footnotes

Here you can see these details on video also:

[Charge Your Website](https://youtu.be/w-eeigEkmn0)
