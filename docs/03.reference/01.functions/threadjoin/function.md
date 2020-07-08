---
title: ThreadJoin
id: function-threadjoin
related:
- tag-thread
- function-threadjoin
- function-threadterminate
categories:
- thread
---

Makes the current thread wait until the thread or threads specified in the name attribute complete processing,
or until the period specified in the timeout argument passes, before continuing processing.

If you don't specify a timeout and thread you are joining to doesn't finish, the current thread also cannot finish processing.
