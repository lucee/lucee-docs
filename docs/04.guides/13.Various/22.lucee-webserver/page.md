---
title: Lucee Server & web servers
id: lucee-server-webserver
---

### How Lucee Server works with web servers ###

We think of web servers as simply serving up HTML and graphics, and application servers as doing all the "complex stuff"... but the distinction between what application servers do and what web servers do can be blurred. In many ways, they can do elements of each others' work.

For example, a web server can do some fairly complex processing, such as server-side includes, and application servers, such as Lucee Server can serve up graphics, PDFs, and of course HTML files.

The distinction between the two is really their intended purpose. A web server is optimised for day-to-day web serving tasks, for example it will be pre-configured to support different file types, to respect permissions, and so on. The application server, on the other hand, expects the developer to provide logic or configuration for even basic tasks, such as serving up a single page.