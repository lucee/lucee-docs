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

If you are using thread in cfscript, you can also access these via the arguments scope..
