---
title: <cfqueryparam>
id: tag-queryparam
related:
- function-querysetcell
categories:
- compat
- query
description: Checks the data type of a query parameter.
---

Checks the data type of a query parameter. The cfqueryparam tag is nested within a cfquery tag and embedded within the SQL statement.
	
This tag:
- Improves security by preventing SQL injection attacks
- Provides data validation for parameter values
- Enhances performance by enabling database query caching
- Correctly handles type conversion between CFML and database types
