---
title: InterruptThread
id: function-interruptthread
related:
- function-threadinterrupt
categories:
- thread
---

Interrupts a specified thread by setting its interrupt status flag.

This function sets the interrupt status flag on a CFThread. The behavior depends on the thread's current state:

- If the thread is blocked in a ThreadJoin or sleep method call: its interrupt status will be cleared and it will receive an InterruptedException
- If the thread is executing a long-running operation with interrupt checks: the operation may terminate early
- If the thread is not alive: the interrupt request may have no effect

This is an alias for [[function-threadinterrupt]], Adobe didn't follow CFML naming patterns