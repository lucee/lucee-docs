---
title: Using scopes explicitly in code
id: using-scopes-explicitly-in-code
---

## Railo recommendation ##

Railo has delivered very many presentations about performance and code readability. Here is what they recommend to any of their customers and programmers:

* Scope everything BUT the closest scope
	* In Functions this is the local scope
	* In templates it is the variables scope
	* The above two do not scope

This is a simple rule to follow and therefore it is easy to understand. In order to support this pattern in Railo, just turn off scope cascading and that will help you scope accordingly.

In general unscoped variables are slower. In Railo the difference between using `variables.var` in comparison to just `var` is not too bad so it really doesn't matter, but as a general rule of thumb:

Scope everything, except the closest scope.
