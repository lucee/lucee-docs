---
title: Compatibility / Migration with other CFML engines
id: category-compat
categories:
- category-core
- core
related:
- https://dev.lucee.org/t/lucee-5-4-to-6-2-upgrade-guide/14854
- https://download.lucee.org/changelog/?version=6.2
description: Whilst Lucee is broadly compatible with Adobe ColdFusion, there are some differences.
menuTitle: Compatibility / Migration
---

Whilst Lucee is broadly compatible with Adobe ColdFusion, there are some differences.

Some are for performance reasons, others due to Adobe mis-adopting or adding features whch conflict with Lucee additions to the language. Sometimes it's a trade off between being compatible and respecting our existing users.

Our issue tracker has an [acf-compat](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20%22acf-compat%22)  label which tracks all the known differences.

In addition, with Lucee 6, we decided to change some incompatible implementations and also change some older insecure defaults to be more secure, please refer to the following epic [All Breaking changes in Lucee 6](https://luceeserver.atlassian.net/browse/LDEV-4534)
