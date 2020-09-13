---
title: <cffinally>
id: tag-finally
related:
- tag-catch
- tag-throw
- tag-try
---

Used inside a cftry tag.
Code in the cffinally block is processed after the main cftry code and, if an exception occurs, the cfcatch code.
The cffinally block code always executes, whether or not there is an exception.
