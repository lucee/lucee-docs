---
title: Build
id: docs-build
---

Contributions to the Lucee docs are welcome. You can edit them online in GitHub or by building the docs locally. Your proposed change will be considered by the Lucee docs team, and you'll be notified if the change is accepted or rejected for some reason which will be given.

Like most docs based on GitHub, the Lucee docs are plain text files formatted as "markdown". If you may be new to working with markdown, see any of various introductory docs, including GitHub's [Basic writing and formatting syntax(https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)] page.

# Editing the docs online

To edit the docs online, noticee that while viewing any docs page there is a GitHub icon at the top right, such as is shown [on this page itself(https://docs.lucee.org/docs/build.html)]. Clicking that will take you to the [Lucee docs repository(https://github.com/lucee/lucee-docs)] for that page.

GitHub also offers [more details on editing files online this way([https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files#editing-files-in-another-users-repository)], including editing, committing changes, creating pull requests, and more. 

# Editing the docs by building them locally 

If you may prefer to edit files locally, and especially if you may want to change many files, you can instead download the repository. Further, you can even build a local copy of the docs, and view them as a full web site. This is a more involved process than just editing a single page via GitHub online, but it's easily performed by following the steps below.

## Prerequisites for building docs locally

The only application dependency required to build the docs locally is [CommandBox](https://www.ortussolutions.com/products/commandbox). Ensure that commandbox is installed and that the `box` command is in your path.

Fork the repository and clone a local copy:

[Lucee Documentation](https://github.com/lucee/lucee-docs)

## Building the static documentation output

The purpose of the structure of the documentation is to allow a human readable and editable form of documentation that can be built into multiple output formats. At present, there is a single "HTML" builder, found at `./builders/html` that will build the documentation website.

To run the build and produce a static HTML version of the documentation website, execute the `build(.sh|bat)` script found in the root of the project, i.e.

	documentation>./build.sh or build.bat

Once this has finished, you should find a `./builds/html` directory with the website content.

## Running a server locally

We have provided a utility server whose purpose is to run locally to help while developing/writing the documentation. To start it up, execute the `serve.(sh|bat)` script found in the root of the project, i.e.

    documentation>./serve.sh or serve.bat

This will spin up a server using CommandBox on port 4040 and open it in your browser. You should also see a tray icon that will allow you to stop the server. Changes to the source docs should trigger an internal rebuild of the documentation tree which may take a little longer than regular requests to the documentation.

## Local editing

When running the server locally, you can edit the content inline and it will save your changes back to your local file system.

Once you have finished making your changes, simply use your preferred git client to create a pull request to publish your changes.

## Related resources

[https://dev.lucee.org/t/building-lucee-documentation-on-windows-and-performance-tuning/3662](https://dev.lucee.org/t/building-lucee-documentation-on-windows-and-performance-tuning/3662)

[https://dev.lucee.org/t/lucee-documentation-visual-and-navigation-improvements/3683](https://dev.lucee.org/t/lucee-documentation-visual-and-navigation-improvements/3683)
