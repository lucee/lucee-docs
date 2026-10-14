---
title: HOTPVerify
id: function-hotpverify
related:
- function-hotpgenerate
- function-totpverify
categories:
- crypto
---

Verifies a counter-based One-Time Password (HOTP) against a secret and expected counter value.

Supports a window parameter to handle counter desync when users generate codes without submitting them.