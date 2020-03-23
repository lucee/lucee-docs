---
title: Build
id: docs-build
---

## Prerequisites

The only dependency required is [CommandBox](http://www.ortussolutions.com/products/commandbox). Ensure that commandbox is installed and that the `box` command is in your path.

## Fork and contribute to the documentation

Fork the repository and clone a local copy, or you can simply use the GitHub links on any page of the docs to edit the docs and submit changes.

[Lucee Documentation](https://github.com/lucee/lucee-docs)

## Building the static documentation output

The purpose of the structure of the documentation is to allow a human readable and editable form of documentation that can be built into multiple output formats. At present, there is a single "HTML" builder, found at `./builders/html` that will build the documentation website.

To run the build and produce a static HTML version of the documentation website, execute the `build(.sh|bat)` script found in the root of the project, i.e.

	documentation>./build.sh or build.bat

Once this has finished, you should find a `./builds/html` directory with the website content.

## Running a server locally

We have provided a utility server who's purpose is to run locally to help while developing/writing the documentation. To start it up, execute the `serve.(sh|bat)` script found in the root of the project, i.e.

    documentation>./serve.sh or serve.bat

This will spin up a server using CommandBox on port 4040 and open it in your browser. You should also see a tray icon that will allow you to stop the server. Changes to the source docs should trigger an internal rebuild of the documentation tree which may take a little longer than regular requests to the documentation.

## Local Editing

When running the server locally, you can edit the content inline and it will save your changes back to your local file system.

Once you have finished making your changes, simply use your preferred git client to create a pull request to publish your changes.

## Recent improvements
[https://dev.lucee.org/t/building-lucee-documentation-on-windows-and-performance-tuning/3662](https://dev.lucee.org/t/building-lucee-documentation-on-windows-and-performance-tuning/3662)

[https://dev.lucee.org/t/lucee-documentation-visual-and-navigation-improvements/3683](https://dev.lucee.org/t/lucee-documentation-visual-and-navigation-improvements/3683)
