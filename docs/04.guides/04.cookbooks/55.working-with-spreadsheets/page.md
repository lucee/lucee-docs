---
title: Working with Spreadsheets
id: cookbook-working-with-spreadsheets
related:
- tag-spreadsheet
- function-spreadsheetnew
---

# How to Work with Spreadsheets in Lucee #

While Lucee does not include native support for spreadsheet manipulation, third-party tooling provides several ways to read, generate, and modify Excel files. In particular, there are two established Lucee spreadsheet projects:

## \<cfspreadsheet /> Extension for Lucee 5.x

[https://github.com/Leftbower/cfspreadsheet-lucee-5](https://github.com/Leftbower/cfspreadsheet-lucee-5)

You can install this extension either via the Lucee Admin GUI or programmatically. Once installed, spreadsheet tags and functions availabe in Adobe CFML, such as `<cfspreadsheet>` and `spreadsheetnew()` are available for use within your application.

Note that there is a [version of this extension for Lucee 4.x](https://github.com/Leftbower/cfspreadsheet-lucee)

## *cfsimplicity/lucee-spreadsheet* Standalone Library

[https://github.com/cfsimplicity/lucee-spreadsheet](https://github.com/cfsimplicity/lucee-spreadsheet)

Developed by Julian Halliwell, this approach to working with spreadsheets does not require installing an extension. However, if you are working with an existing codebase, it will need to be rewritten in order to invoke the library's spreadsheet functions. That is, this library doesn't replicate Adobe CFML's spreadsheet functions or `<cfspreadsheet>` tag. The benefits of this approach include cross-engine compatibililty and a range of more powerful functions and options for working with spreadsheets.
