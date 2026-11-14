---
title: HKDFExpand
id: function-hkdfexpand
related:
- function-hkdfextract
- function-generatehkdfkey
categories:
- crypto
---

Second step of two-phase key derivation: expands an intermediate key (from HKDFExtract) into one or more output keys.

Use different info strings to derive separate keys for different purposes (e.g. encryption vs authentication).