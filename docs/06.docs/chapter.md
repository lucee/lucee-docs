---
title: About the docs
sortOrder: 99
id: about
description: Good documentation is at the heart of all successful open source projects. This section of the documentation describes how the documentation is built and how you can get involved with contribution.
---

## Mission statement

Good documentation is at the heart of all successful open source projects. With this platform, we aim to:

* Provide a platform that is easy to contribute to and maintain
* Provide documentation that is a joy to read and navigate
* Provide a system that can build the same documentation source to multiple output formats
* Provide stewardship such that the documentation is well kept and ever-growing

## Contributing

This documentation is built from an open source repository that is open to all to contribute. The repository can be found under the official Lucee team's GitHub account at [https://github.com/lucee/lucee-docs](https://github.com/lucee/lucee-docs).

You'll find information on ways in which you can contribute in the [[docs-content]] and [[docs-build]] sections. However, if you're ever in doubt, we encourage you to use the [issue tracker](https://luceeserver.atlassian.net/projects/LD) and [community forums](https://lucee.org/get-involved.html) to help get you started or discuss your ideas.

## Technology

### Lucee

The documentation build is achieved using Lucee code. The only dependency required to build and locally run the documentation is [CommandBox](http://www.ortussolutions.com/products/commandbox).

This choice was both obvious and difficult. Difficult because there are multiple other solutions out there that we could easily have picked. We could have chosen to use a Wiki, or other static file based documentation generators. These would all have saved us time and effort in the short term. In the end however, the choice was made to allow the Lucee community to take **full** ownership of the documentation by writing the system from scratch using Lucee code. It's built using the language we use day in day out, and the entire code base is open source and editable in one place.

### Markdown

While we could stomach writing a build system from scratch using Lucee (which was both rapid and joyous), we absolutely did not want to reinvent the wheel when it came to the source of the documentation.

With that in mind, we chose to use [Markdown](http://daringfireball.net/projects/markdown/) with a few common and custom enhancements.

We also based the system on a popular open source static CMS system called [Grav](http://getgrav.org). This gives us a proven foundation to build the source from and should help make contributing as easy as it can be.

For more information on how the documentation is formatted, see the [[docs-content]] section.
