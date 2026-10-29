---
title: PreserveEncoding
id: function-preserveencoding
related:
- tag-output
- function-encodeforhtml
- function-esapiencode
- function-preservesinglequotes
categories:
- ESAPI
- HTML
---

Returns the value unchanged and marks the expression as an exception within a cfoutput tag that has the attribute encodeFor set.
The output of the expression is not encoded, which is useful for values that are already encoded or intentionally contain markup, in the same way the encodeFor functions (for example encodeForHTML) are not encoded a second time.
Outside of such a cfoutput tag it simply returns the value.
