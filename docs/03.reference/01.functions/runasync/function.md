---
title: RunAsync
id: function-runasync
categories:
- async
- future
- thread
description: A function that returns a Future object, which is an eventual result of an asynchronous operation
---

A function that returns a Future object, which is an eventual result of an asynchronous operation (like a promise in javascript)

The Future Object has the following functions:

- cancel() returns Boolean
- isCancelled() returns Boolean
- isDone() returns Boolean
- error() returns Future
- get(closure, timezone) returns Future
- then(closure, timezone) returns Future
