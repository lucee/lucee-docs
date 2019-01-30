# Lucee documentation source and builder

[![Build Status](https://travis-ci.org/lucee/lucee-docs.svg?branch=master)](https://travis-ci.org/lucee/lucee-docs)

This repository contains the source and build scripts for creating Lucee's documentation. The website output of the docs can be found at [http://docs.lucee.org](http://docs.lucee.org).

Issues can be reported and tracked at [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD).

Find out more about the project at: [http://docs.lucee.org/docs.html](http://docs.lucee.org/docs.html).

## Build locally

### Prerequisites

The only dependency required is [CommandBox](http://www.ortussolutions.com/products/commandbox). Ensure that commandbox is installed and that the `box` command is in your path.

### Building the static documentation output

The purpose of the structure of the documentation is to allow a human readable and editable form of documentation that can be built into multiple output formats. At present, we have an "HTML" builder and a "Dash docs" builder, found at `./builders/html` and `./builders/dash` that will build the documentation website and dash docset respectively. The source of the documentation can be found in the `./docs` folder.

To run the build, execute the `build.sh` or `build.bat` script found in the root of the project, i.e.

	documentation>./build.sh|bat

Once this has finished, you should find `./builds/html` and `./builds/dash` directories with the website content / dash docsets built.

### Running a server locally

We have provided a utility server who's purpose is to run locally to help while developing/writing the documentation. To start it up, execute the `serve.sh` or `serve.bat` script found in the root of the project, i.e.

    documentation>./serve.sh|bat

This will spin up a server using CommandBox on port 4040 and open it in your browser. You should also see a tray icon that will allow you to stop the server. Changes to the source docs should trigger an internal rebuild of the documentation tree which may take a little longer than regular requests to the documentation.

When running locally there are the following urls available

* [Lucee documentation home](http://127.0.0.1:4040/)
* [Build all documentation](http://127.0.0.1:4040/build_docs/all/)
* [Build html documentation](http://127.0.0.1:4040/build_docs/html/)
* [Build dash documentation](http://127.0.0.1:4040/build_docs/dash/)
* [Import any new tags or functions](http://127.0.0.1:4040/build_docs/import/)
* [View static html docs](http://127.0.0.1:4040/static/) (you need to have built the html documentation first)

## Contributing

There is a lot of work to do and we appreciate contribution in all forms. The issues list can be found and expanded upon here: [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD) 

Ask questions or post suggestions over on the [Lucee mailing List](https://dev.lucee.org/c/documentation) under the documentation category.

More information on how the documentation is built and formatted can be found at [http://docs.lucee.org/docs.html](http://docs.lucee.org/docs.html).

The workflow for contributions would be:
* Submit the contributor's agreement: http://docs.lucee.org/guides/get-involved/contributing-contributors-agreement.html
* Fork lucee-docs on github.
* Make your changes in the master branch.
* Push your changes to your github repo.
* Create a pull request.

### Raise issues and suggestions

Issues and suggestions are always welcome (though pull requests are preferred!). Please use the issue tracker: [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD).

### License

The project is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
