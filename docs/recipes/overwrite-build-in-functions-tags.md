<!--
{
  "title": "Overwriting and adding Built-in Functions and Tags",
  "id": "overwrite-build-in-functions-tags",
  "description": "Learn how to overwrite or add built-in functions and tags in Lucee to customize behavior or backport fixes.",
  "keywords": [
    "function",
    "BIF",
    "overwrite",
    "add functions",
    "custom tags",
    "Lucee customization",
    "Lucee server",
    "backport fixes",
    "ACF compatibility"
  ],
  "related": [
    "tag-function",
    "developing-with-lucee-server"
  ]
}
-->

# Overwriting and Adding Built-in Functions and Tags

In Lucee, you can overwrite or add built-in functions and tags with your own implementations. This is particularly useful for emulating the behavior of older Lucee versions in newer ones or for backporting fixes to older versions.

## Overwriting/Adding Functions

Let's consider an example with the `val` function. The behavior of `val` was updated in Lucee 6.1 to more closely align with Adobe ColdFusion (ACF). To replicate this updated behavior in versions prior to 6.1, follow these steps:

Create a file at `…/lucee-server/context/library/function/val.cfm` with the following content:

```javascript
<cfscript>
  public numeric function val(required obj) {
    if (!structKeyExists(server, "functionVal")) {
      lock name="functionVal" {
        if (!structKeyExists(server, "functionVal")) {
          server.functionVal = createObject("java", "lucee.runtime.functions.string.Val");
        }
      }
    }
    try {
      return server.functionVal.call(getPageContext(), obj);
    } catch (e) {
      return 0;
    }
  }
</cfscript>
```

After creating this file, restart Lucee. This custom implementation of the `val` function will now be used throughout your code. In this example, the original `val` function is called, but any exceptions are caught, and `0` is returned if an exception occurs.

This approach not only allows you to overwrite existing functions but also to add entirely new functions that will behave like built-in functions. You can find many built-in function templates in the `…/lucee-server/context/library/function/` directory.

## Overwriting/Adding Tags

The process for tags is similar. To create or overwrite a tag, use the `…/lucee-server/context/library/tags` directory. Custom tags need to follow the same interface as regular custom tags. You can refer to existing built-in tags in this directory as templates for your implementations.

By following these steps, you can extend or modify Lucee's capabilities to suit your specific needs.
