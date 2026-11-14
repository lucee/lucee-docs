---
title: HKDFExtract
id: function-hkdfextract
related:
- function-hkdfexpand
- function-generatehkdfkey
categories:
- crypto
---

First step of two-phase key derivation: concentrates the entropy from a secret into a fixed-size intermediate key (PRK).

Use with HKDFExpand() to efficiently derive multiple keys from the same secret.