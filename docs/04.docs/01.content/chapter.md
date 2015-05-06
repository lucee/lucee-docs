---
title: Content
id: docs-content
---

# Content

The contents of the Lucee documentation is our number one priority. This chapter deals with how the documentation content is organised and written and should provide a thorough reference for anyone wishing to contribute to the content of the docs.

## Overview

The documentation system is largely based on the [Grav](http://getgrav.org) static CMS. This system uses folders to represent pages, and markdown files within those folders to provide the page content. 

All of the source files for this documentation can be found in the `/docs` folder of the public repository; i.e. [https://bitbucket.org/lucee/documentation/src/master/docs/](https://bitbucket.org/lucee/documentation/src/master/docs/)

For more information on how the folder structure and various page types work, see [[docs-structure]].

## Markdown

The system uses markdown files to provide the bulk of the documentation. 

In addition to plain markdown, we are also using the popular [YAML front matter](https://duckduckgo.com/?q=YAML+front+matter) format to provide additional meta data for our pages (such as category tagging) and [Python Pygments](http://pygments.org/) to provide syntax highlighting.

For more information on our "LuceeDocs-flavoured" Markdown, see [[docs-markdown]].