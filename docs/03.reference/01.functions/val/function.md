---
title: Val
id: function-val
related:
- function-tonumeric
- function-parsenumber
categories:
- number
- parsing
description: Converts numeric characters that occur at the beginning of a string to an number.
---

Converts numeric characters that occur at the beginning of a string to a number by stripping off all remaining characters once a non-numeric character is reached.

If the string does not start with any numeric characters or is empty, a 0 is returned. A period will be included, so val() will return a decimal.
