---
title: Building and Testing Lucee Extensions
id: building-testing-extensions
categories:
- extensions
description: How to build, test and submit changes to Lucee extensions, using Ant, GitHub and Lucee script-runner
menuTitle: Building Extensions
---

Lucee Extensions are decoupled from the Lucee core using OSGI, which reduces memory usage, enables custom configuration and allows updating extensions without requiring an update to the Lucee Core.

The Lucee core has a [MANIFEST.MF](https://github.com/lucee/Lucee/blob/6.0/core/src/main/java/META-INF/MANIFEST.MF) (under `core/src/main/java/META-INF/MANIFEST.MF`, see section `Require-Extension:`) which defines which specific extensions and versions are going to be bundled with the full Lucee jar (internally we call this the fat jar).

In order to update or add a bundled extension to the fat jar, the manifest must be updated and a new Lucee core version published.

This guide uses Windows commands as an example, but all these commands work on Linux or MacOS, just change the paths.

## Building and deploying an extension

Lucee uses Apache Ant for all of it build processes.

To build/compile a Lucee Extension

- install Java (Java 11 recommended, Java 14 is the latest version currently supported)
- install [Apache Ant](https://ant.apache.org/) (add to path on Windows)
- fork the extension repository on GitHub and check out a copy of your forked repository locally
- run `ant` in the root of the checked out folder

If the extension compiles successfully, a `.lex` file (lucee extension installer) will be produced, usually in the `/dist` or `/target` sub-directory.

The `.lex` file can then be installed into an existing Lucee installation via the following methods:

- copying the `.lex` file in the `\lucee\tomcat\lucee-server\deploy` folder, Lucee checks this folder every 60s and automatically installs any extensions (`*.lex`) or Lucee core updates (`*.lco`) it finds
- manually uploading the extension via the Lucee Administrator, via the form under Extension, Applications

By default, Lucee's `deploy.log` is set to `ERROR`, to debug or see more detailed logging, change the log level for `deplog.log`, under **Settings, Logging** in the Lucee Server Administrator to `TRACE`.

## Testing a Lucee Extension using GitHub Actions

Most Lucee extensions have already been setup with a GitHub Action which automatically runs on commits against the repository (or your fork).

If you find an extension without a GitHub Action configured, it's pretty easy to copy it over from another Lucee Extension [.github/workflows/main.yml](https://github.com/lucee/extension-s3/blob/master/.github/workflows/main.yml) and configure it for the specific extension.

These Lucee Extension GitHub Actions have the relevant services (Redis, Oracle, MySQL etc) all configured and automatically run a subset of the full Lucee 6.0 testsuite, using test labels to run only the relevant tests using Lucee Script Runner.

Most of the major services are included with the [Lucee Core build GitHub Action](https://github.com/lucee/Lucee/blob/6.0/.github/workflows/main.yml), but some heavier services like Oracle are only run for the extension's [GitHub Action](https://github.com/lucee/extension-jdbc-oracle/blob/master/.github/workflows/main.yml), due to time and memory constraints on the main build process.

The tests for Lucee Extensions are usually all included in the [Lucee Core test suite](https://github.com/lucee/Lucee/tree/6.0/test), that way they are all tested each time any changes are made to Lucee core.

## Testing a Lucee Extension locally

How to run the automated tests locally for an extension (without committing and relying on the GitHub Action):

Assuming your working dir for Lucee is `c:\work\` and you want to test the [S3 Extension](https://github.com/lucee/extension-s3)

- fork [Lucee](https://github.com/lucee/Lucee) and check out to `c:\work\lucee6`
- fork (or just checkout) the [Lucee script-runner](https://github.com/lucee/script-runner) to `C:\work\script-runner`
- fork the [Lucee S3 extension](https://github.com/lucee/extension-s3) and checkout into `C:\work\lucee-extensions\extension-s3` (there's a lot of Lucee extensions, so I prefer to group them under a sub-directory)

Create a batch/shell script in the root of the extension repository, i.e. `C:\work\lucee-extensions\extension-s3\test.bat` as follows

```
call ant
if %errorlevel% neq 0 exit /b %errorlevel%
set testLabels=s3
set testFilter=

ant -buildfile="C:\work\script-runner" -DluceeVersion="6.0.0.114-SNAPSHOT" -Dwebroot="C:\work\lucee6\test" -Dexecute="/bootstrap-tests.cfm" -DextensionDir="C:\work\lucee-extensions\extension-s3\dist"
```

This script will compile the extension using Ant, start a lightweight js-223 instance of Lucee 6.0.0.114, installs the built extension and then runs any tests found with [labels="s3"](https://github.com/lucee/Lucee/blob/6.0/test/extension/S3.cfc#L19) in the Lucee 6.0 testsuite. in the Lucee 6.0 testsuite.

**Initially this won't actually run any tests**, they will all be run but bypassed, as the S3 tests depend on a S3 service being configured for the test suite.

## Configuring Test Services

To configure the Lucee test suite with local or remote services, you can either set environment variables, or you can create a `c:\work\lucee-env.json` file containing all the enviromment variables you want to configure and simply set `LUCEE_BUILD_ENV='c:\work\lucee-env.json'`.

The full list of supported environment variables for test services can be found under [C:\work\lucee6\test\_setupTestServices.cfc](https://github.com/lucee/Lucee/blob/6.0/test/_setupTestServices.cfc)

If you want to add some extended tests locally to the extension itself, you can create them under `C:\work\lucee-extensions\extension-s3\tests\`, with the labels="s3" (change appropriately) and then run them by adding the command line argument `-DtestAdditional="C:\work\lucee-extensions\extension-s3\tests\"` to the above ant command.

This could be useful for extended, slow complex tests, which don't need to be run with every build of the Lucee core.

## Submitting Pull Requests (PRs)

Firstly, depending on the change you are making, **please first post to the [mailing list](https://dev.lucee.org/)**, so the Lucee team and community can help you and let you know if we agree with the change and will accept your PR.

Once you have that all sorted out, it's time to create an issue in [Lucee's Jira](https://luceeserver.atlassian.net/projects/LDEV/summary) (if there isn't already an existing issue).

Then file a PR against the [Extension Repository](https://github.com/lucee/extension-s3/pulls), including a link back to the Jira ticket in the initial comment.

If you have modified or added tests under the Lucee core, then file another PR with those tests against the [Lucee repository](https://github.com/lucee/Lucee/pulls), linking to both the PR against the extension repository and the jira ticket.

Then finally, post links to any PR(s) against the ticket in Jira.

## Questions and Support

Please post any questions to the mailing list, **please do not file jira tickets** without posting to the [mailing list](https://dev.lucee.org/) first and being asked to by the Lucee team.
