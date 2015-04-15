# Lucee documentation source and builder

This repository contains the source and build scripts for creating Lucee's documentation. 

It is currently a work in progress and we are working as fast as we can to deliver a published product that is ready for general consumption.

Until that time, read on below to see how you can get involved.

## Build and experiment locally

### Prerequisites

The only dependency required is [CommandBox](http://www.ortussolutions.com/products/commandbox). Ensure that commandbox is installed and that the `box` command is in your path.

### Building the static documentation output

The purpose of the structure of the documentation is to allow a human readable and editable form of documentation that can be built into multiple output formats. At present, there is a single "HTML" builder, found at `./builders/html` that will build the documentation website. The source of the documentation can be found in the `./docs` folder.

To run the build and produce a static HTML version of the documentation website, execute the `build.sh` file found in the root of the project, i.e.

	documentation>./build.sh

Once this has finished, you should find a `./builds/html` directory with the website content.

### Running a server locally

We have provided a utility server who's purpose is to run locally to help while developing/writing the documentation. To start it up, execute the `serve.sh` file found in the root of the project, i.e.

    documentation>./serve.sh

This will spin up a server using CommandBox on port 4040 and open it in your browser. You should also see a tray icon that will allow you to stop the server. Changes to the source docs should trigger an internal rebuild of the documentation tree which may take a little longer than regular requests to the documentation.

> Note: there is currently no batch file equivalent for Windows. If you are running on windows, it should be fairly trivial to copy and adapt what is found in the `.sh` file (please let us know if you get this working).

## Pitch in

### Formatting of the website

The source code for building the HTML website can be found at `./builders/html/`. The build process will call `./builders/html/Builder.cfc$build()` and hopefully you should be able to follow the logic from there (and/or figure out what you want to edit based on the folder and file structure).

All the css, js and imagery for the website can be found in `./builders/html/assets`.

Right now, the biggest need is for formatting and creating features for the function and tag documentation pages.

### Better and more accurate tag and function descriptions

The content of the tag and function reference could do with improving. These pages of the documentation are built by taking descriptions found in markdown files (e.g. `/docs/03.reference/01.functions/abs/function.md`) and merging them with specifications from the source code.

#### Functions

Function descriptions can be edited in the `function.md` file in the given function's folder.

Descriptions for a function's arguments can be edited in the `/_arguments/argumentName.md` file within the given function's folder.

Examples can be provided and edited in a `_examples.md` file in the root of the function's folder.

#### Tags

Tag descriptions can be edited in the `tag.md` file in the given tag's folder.

Descriptions for a tag's attributes can be edited in the `/_attributes/attributeName.md` file within the given tag's folder.

Examples can be provided and edited in a `_examples.md` file in the root of the tag's folder.


### Documentation articles

This is perhaps the hardest part of all. For the documentation to really work, we require articles and guides that go further than simply reference material of functions and tags. Guides might go under the name of things like 'Lucee Components (CFCs)' or "Using Lucee's built in PDF functionality". These pages can be cross referenced in the reference material to provide rich documentation.

#### What is needed

1. A structure
2. The content

All input is welcome here.

## Raise issues and suggestions

Issues and suggestions are always welcome (though pull requests are preferred!). Please use the issue tracker in BitBucket.

