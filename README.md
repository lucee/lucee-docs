# Lucee documentation source and builder

[![Lucee Docs Builder](https://github.com/lucee/lucee-docs/actions/workflows/main.yml/badge.svg)](https://github.com/lucee/lucee-docs/actions/workflows/main.yml)
[![Lint](https://github.com/lucee/lucee-docs/actions/workflows/lint.yml/badge.svg)](#lucee-documentation-source-and-builder)

This repository contains the source and build scripts for creating Lucee's documentation. The website output of the docs can be found at [https://docs.lucee.org](https://docs.lucee.org).

Issues can be reported and tracked at [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD).

Find out more about the project at: [https://docs.lucee.org/docs.html](https://docs.lucee.org/docs.html).

## Build locally

### Prerequisites

The only optional dependency required is [CommandBox](https://www.ortussolutions.com/products/commandbox).

CommandBox is only required to run the build process via the command line, or if you don't setup a virtual server with an existing local Lucee install.

Ensure that CommandBox is installed and that the `box` command is in your path.

### Building the static documentation output

The purpose of the structure of the documentation is to allow a human readable and editable form of documentation that can be built into multiple output formats. At present, we have an "HTML" builder and a "Dash docs" builder, found at `./builders/html` and `./builders/dash` that will build the documentation website and dash docset respectively. The source of the documentation can be found in the `./docs` folder.

To run the build, execute the `build.sh` or `build.bat` script found in the root of the project, i.e.

	documentation>./build.sh|bat

Once this has finished, you should find `./builds/html` and `./builds/dash` directories with the website content / dash docsets built.

### Running a server locally

Lucee Docs Requires Lucee 7 and for [urlrewrite](https://tuckey.org/urlrewrite/) to be installed

You have two options

- Create a webserver virtual host with a normal Lucee install, with the virtual host's DocumentRoot set to `/lucee-docs/server`
- Run a custom docs instance via CommandBox

We have provided a utility server whose purpose is to run locally to help while developing/writing the documentation. To start it up, execute the `serve.sh` or `serve.bat` script found in the root of the project, i.e.

    documentation>./serve.sh|bat

This will spin up a server using CommandBox on port 4040 and open it in your browser. You should also see a tray icon that will allow you to stop the server. Changes to the source docs should trigger an internal rebuild of the documentation tree which may take a little longer than regular requests to the documentation.

When running locally there are the following URLs available (these URLs below are for a CommandBox instance, substitute them with the URL for your virtual host if appropriate)

* [Lucee documentation home](http://127.0.0.1:4040/)
* [Build all documentation](http://127.0.0.1:4040/build_docs/all/)
* [Build HTML documentation](http://127.0.0.1:4040/build_docs/html/)
* [Build dash documentation](http://127.0.0.1:4040/build_docs/dash/)
* [Import any new tags or functions](http://127.0.0.1:4040/build_docs/import/)
* [View static HTML docs](http://127.0.0.1:4040/static/) (you need to have built the HTML documentation first)

## Working with the bundled JS and CSS files

The build process for the JS and CSS bundles are found under `/builders/html/assets`.

### Quick Start

```bash
cd builders/html/assets
npm install
npm run build
```

For development with auto-rebuild on file changes:

```bash
npm run watch
```

### Publishing Changes

After you have made everything more beautiful via CSS, or added some funky new interactivity via JavaScript,
to publish a new build of the bundles:

1. Update the asset version in `builders/html/assets/package.json` (config.assetVersion)
2. Update `variables.assetBundleVersion` in `Application.cfc` to match
3. Update `this.assetBundleVersion` in `server/Application.cfc` to match
4. Run `npm run build` in the assets directory
5. Commit all files including the new versioned CSS/JS files

The docs are statically deployed via CloudFront and versioning of these files is required to break caching.

For detailed documentation on the asset build system, see [builders/html/assets/README.md](builders/html/assets/README.md).

## Contributing

There is a lot of work to do, and we appreciate contribution in all forms. The issues list can be found and expanded upon here: [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD)

Ask questions or post suggestions over on the [Lucee mailing List](https://dev.lucee.org/c/documentation) under the documentation category.

More information on how the documentation is built and formatted can be found at [https://docs.lucee.org/docs.html](https://docs.lucee.org/docs.html).

The workflow for contributions is:

* Submit the contributor's agreement: <https://docs.lucee.org/guides/get-involved/contributing-contributors-agreement.html>
* Fork lucee-docs on GitHub.
* Make your changes in a new feature branch.
* Push your changes to your GitHub repo.
* Create a pull request.

### Raise issues and suggestions

Issues and suggestions are always welcome (though pull requests are preferred!). Please use the issue tracker: [https://luceeserver.atlassian.net/projects/LD](https://luceeserver.atlassian.net/projects/LD).

### License

The project is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
