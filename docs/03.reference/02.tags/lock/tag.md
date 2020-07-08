---
title: <cflock>
id: tag-lock
description: 'Provides two types of locks to ensure the integrity of shared data:
  Exclusive lock and Read-only lock.'
---

Provides two types of locks to ensure the integrity of shared data: Exclusive lock and Read-only lock.

An exclusive lock single-threads access to the CFML constructs in its body. Single-threaded access
  implies that the body of the tag can be executed by at most one request at a time. A request executing
  inside a cflock tag has an "exclusive lock" on the tag. No other requests can start executing inside the
  tag while a request has an exclusive lock. Lucee issues exclusive locks on a first-come, first-served
  basis.

A read-only lock allows multiple requests to access the CFML constructs inside its body concurrently.
  Therefore, read-only locks should be used only when the shared data is read only and not modified. If another
  request already has an exclusive lock on the shared data, the request waits for the exclusive lock to be
  released.
