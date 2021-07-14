---
title: Content
id: docs-content
---

The contents of the Lucee documentation is our number one priority. This chapter deals with how the documentation content is organised and written and should provide a thorough reference for anyone wishing to contribute to the content of the docs.

## Overview

The documentation system is largely based on the [Grav](http://getgrav.org) static CMS. This system uses folders to represent pages, and Markdown files within those folders to provide the page content.

All of the source files for this documentation can be found in the `/docs` folder of the public repository; i.e. [https://github.com/lucee/lucee-docs/tree/master/docs](https://github.com/lucee/lucee-docs/tree/master/docs)

For more information on how the folder structure and various page types work, see [[docs-structure]].

## Markdown

The system uses Markdown files to provide the bulk of the documentation.

In addition to plain markdown, we are also using the popular [YAML front matter](https://duckduckgo.com/?q=YAML+front+matter) format to provide additional meta data for our pages (such as category tagging) and [Python Pygments](http://pygments.org/) to provide syntax highlighting.

For more information on our "LuceeDocs-flavoured" Markdown, see [[docs-markdown]].

## Reference pages

Documentation pages that provide pure reference material (i.e. function and tag pages) use a mixture of Markdown files and metadata from the Lucee source code itself to produce a final output.

This allows us to provide accurate and up to date reference material while also giving the community the ability to enhance the editorial content with code examples, better descriptions and cross-references.

For more information, see [[docs-reference-pages]].

## oEmbed support

Docs supports a limited range of [oembed](https://oembed.com) content, include the raw url as the link description for it to be processed, otherwise it would break up the flow of pages with links to external content. Lucee Jira urls are converted to a single one liner with the task title (see below)

i.e.```[https://luceeserver.atlassian.net/browse/LD-111](https://luceeserver.atlassian.net/browse/LD-111)```

Docs itself exposes oembed metadata thanks to [iframely](https://iframely.com/)

For more information see

[https://luceeserver.atlassian.net/browse/LD-111](https://luceeserver.atlassian.net/browse/LD-111)
