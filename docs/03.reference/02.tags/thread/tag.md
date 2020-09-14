---
title: <cfthread>
id: tag-thread
categories:
- thread
---

The cfthread tag enables you to create threads, independent streams of code execution, in your application.
You use this tag to run or end a thread, temporarily stop thread execution, or join together multiple threads.

You can pass in any additional attributes you like which are then available within the thread in the attributes scope,
which is useful for passing data into the thread.

In Lucee these attributes are passed **by reference**, unlike other CFML engines. This may cause problems with thread 
safety. You can wrap the attributes in a [[function-duplicate]] to avoid such problems.

If you are using thread in cfscript, you can also access these via the arguments scope, but this is not recommended or compatible with other CFML engines.

Each thread has it's own unqiue set of debugging data, which will not show up in the normal debugging report. You can access the debugging data inside the thread using `<cfadmin action=“getDebugData” returnVariable=“data”>`
