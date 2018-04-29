---
title: <cfcache>
id: tag-cache
related:
categories:
- cache
---

Speeds up page rendering when dynamic content does not have to be retrieved each time a user accesses the page.

To accomplish this, cfcache creates temporary files that contain the static HTML returned from a page.

 You can use cfcache for simple URLs and URLs that contain URL parameters.