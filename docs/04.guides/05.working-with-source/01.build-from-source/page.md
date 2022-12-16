---
title: Building Lucee 5 & 6 from source
id: working-with-source-build-from-source
forceSortOrder: 1.5
---

## Building Lucee 5 and 6 from source #

The following text assumes that you have basic knowledge of how to use `git` and `mvn`, if not please first consult the documentation for this tools.

See [[building-testing-extensions]] for instructions regarding Extensions

### 1. Before you get started

Before you can start building Lucee from source, you will need a few things installed on your machine:

1. **Java JDK** - since you're going to compile Java code you need the JDK and not just the JRE.  

- Lucee requires JDK 8 or later in order to compile.  [Oracle](https://www.oracle.com/technetwork/java/javase/downloads/) or [AdoptOpenJDK](https://adoptopenjdk.net/)
- Java 11 is *recommended*, Java 15 is *not yet supported* due the removal of the Nashorn JavaScript engine which is used in the build process 
- Java 17 *isn't yet fully supported* due to some Apache Felix issues (fixed in 5.3.9, but some extensions need updating)

1. **Apache Maven** - the source code contains several build scripts that will automate the build process for you. you will need Maven installed in order to run these build scripts. <http://maven.apache.org/>

1. **Apache Ant** - the source code contains several build scripts that will automate the build process for you. you will need Maven installed in order to run these build scripts. <http://ant.apache.org/bindownload.cgi>

### 2. Get the source code

Lucee's source code is version-controlled with Git, [Lucee GitHub repository](https://github.com/lucee/lucee).

The repository contains a few branches, with the most important ones being "Master" (current release) and "Develop" (alpha and beta releases), currently the main branch for development is the *6.0 branch*, so best start there.

So simply clone the 6.0 branch (or fork your own copy) from the git repository to your local drive with the following command:

    git clone -b 6.0 https://github.com/lucee/Lucee.git

### 3. Build it

To run the test suite using Maven:

    cd loader
    mvn test

To build the server using Maven:

    cd loader
    mvn clean install

To build the server using Ant:

    cd loader
    ant

To build the server using Ant but without running the test suite:

    cd loader
    ant fast

To build only the update .lco file:

    cd loader
    ant quick

#### Troubleshooting Build

If you are are getting errors trying to compile the code, you may need to flush your Maven cache. Running the following command to refresh your dependency cache:

```
mvn dependency:purge-local-repository
```

### 4. Deploy

Deployment (and testing PRs) is automated via [GitHub Actions](https://github.com/lucee/Lucee/actions) for all push and pull requests

See **deployLco** below

### 5. Submitting Pull Requests (PRs)

- Create an new [issue/ticket](https://issues.lucee.org)
- Create a [Pull Request](https://github.com/lucee/Lucee/) against the *6.0 Branch* with the issue number in the title (i.e Fix error deserialising JSON LDEV-101) and include the issue URL in the description
- Finally add the URL to the Pull Request to the issue
- Please include tests!

### Build Performance Tips

On Windows, excluding your Lucee working directory from both `Windows Defender` and `Windows Search Indexer` will speed up the build process a bit.

Lucee 6.0 adds some extra options to the build process (they can be combined)

If you are using VS Code and the cflint plugin, make sure you exclude the `temp/**` and `loader/**` folders, otherwise cflint may go bananas (maxing out your CPU and slowing everything else down) during the build process.

**testFilter** allows you to pass in test filter(s) i.e filtering by filename, so you don't have to run the full test suite whilst hacking.

    ant -DtestFilter="image"
    ant -DtestFilter="mysql,oracle"
    ant -DtestFilter="ldev1234"

**testLabels** allows you to filter tests by their assigned labels, i.e. `component labels="s3" {}` (only supported per cfc/bundle, not for individual methods).

    ant -DtestLabels="s3"
    ant -DtestFilter="mysql,orm"

**deployLco** automates the deployment of a new `.lco` build to a local Lucee install's deploy directory

	ant quick -DdeployLco="C:\lucee\tomcat\lucee-server\deploy"

**testExtensions** allows testing local extension build(s) `*.lex` from a local directory with the main test suite

	ant -DtestLabels="zip" -DtestExtensions="C:\work\lucee-extensions\extension-compress\dist"

**testAdditional** allows running additional tests from a directory

	ant -DtestFilter="zip" -DtestAdditional="C:\work\lucee-extensions\extension-compress\tests"

**testDebug** outputs debug information about tests which don't compile and why they are filtered out, plus full stacktraces. 

Any invalid tests (syntax errors etc) are skipped by default

	ant -DtestDebug="true"
	
**testDebugAbort** used with `testDebug` to check test cases

Build will abort after scanning tests cases for errors, good for finding invalid test cases

	ant -DtestDebug="true" -DtestDebugAbort="true"

**testSkip** allows running tests which are flagged `skip=true` or prefixed with an `_` (which also disables a test)

	ant -DtestSkip="false" -DtestFilter="_" -DtestDebug="true"

**testRandomSort** allows running tests in a random sort order. It takes a boolean or numeric argument. (since 6.0.0.305)

- `false` (default) tests are sorted by `textnocase`
- `numeric` the value is passed into the `randomize()` function before applying the random sort, (i.e. repeatable random order)
- `true` a random seed number is chosen to pass to `randomize()` which is listed after `----Start Tests----` so the run can be repeated

		ant -DtestRandomSort="true"

		ant -DtestRandomSort="3"

**testServices** allows restricting which Test Services (db, mail, ftp, s3 etc) to enable, if configured, whilst disabling any other configured services

	ant -DtestServices="s3,orm"

**testJavaVersionExec** allows running the test suite with a different java version, pass in the path to the Java executable (the build currently uses javascript which isn't available since java 15+)

	ant -DtestJavaVersionExec="/opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.1-12/x64/bin/java"

**testSuiteExtends** by default, only test suites extending `org.lucee.cfml.test.LuceeTestCase` are run, this allows specifying other valid BaseSpecs

	-DtestSuiteExtends="org.lucee.cfml.test.LuceeTestCase,testbox.system.BaseSpec"
