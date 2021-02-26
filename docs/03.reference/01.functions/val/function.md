---
title: Val
id: function-val
related:
- function-tonumeric
- function-parsenumber
categories:
- number
- parsing
description: Converts numeric characters that occur at the beginning of a string to an integer.
---

Converts numeric characters that occur at the beginning of a string to an integer by stripping off all remaining characters once a non-numeric character is reached.

If the string does not start with any numeric characters or is empty, a 0 is returned. A period is not considered a numeric character, so val() will stop if it reaches a period.
