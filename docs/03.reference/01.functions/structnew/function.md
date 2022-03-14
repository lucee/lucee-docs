---
title: StructNew
id: function-structnew
categories:
- collection
- struct
description: 'Creates an empty structure.'
---

Creates an empty structure.

The shorthand syntax for structNew is ``` {}; ```

The shorthand syntax to create an ordered structure is ``` [:]; ``` or ``` [=]; ```

You can also create structures with data using this syntax:

- a normal structure ``` { "key": value }; ```
- a linked/ordered structure use ``` [ "key": value ]; ```

To preserve the case of the struct key, use a quoted value for the key, otherwise, it will be converted to uppercase.
