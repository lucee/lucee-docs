---
title: HOTPGenerate
id: function-hotpgenerate
related:
- function-hotpverify
- function-totpsecret
categories:
- crypto
---

Generates a counter-based One-Time Password (HOTP).

Unlike TOTP which uses the current time, HOTP uses a counter that you increment after each use. Returns a 6-digit code by default.