---
title: Building Lucee 5 & 6 from source
id: working-with-source-build-from-source
---

## Building Lucee 5 and 6 from source #

The following text assumes that you have basic knowledge of how to use `git` and `mvn`, if not please first consult the documentation for this tools.

### 1. Before you get started

Before you can start building Lucee from source, you will need a few things installed on your machine:

1. **Java JDK** - since you're going to compile Java code you need the JDK and not just the JRE.  Lucee requires JDK 8 or later in order to compile.  <https://www.oracle.com/technetwork/java/javase/downloads/>

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

### 4. Deploy

Deployment is automated via Travis CI on merge/commit

See **deployLco** below

### 5. Submitting Pull Requests (PRs)

- Create an new [issue/ticket](https://issues.lucee.org)
- Create a [Pull Request](https://github.com/lucee/Lucee/) against the *6.0 Branch* with the issue number in the title (i.e Fix error deserialising JSON LDEV-101) and include the issue URL in the description
- Finally add the URL to the Pull Request to the issue
- Please include tests!

### Build Performance Tips

On Windows, excluding your Lucee working directory from both `Windows Defender` and `Windows Search Indexer` will speed up the build process a bit.

Lucee 6.0 adds some extra options to the build process (they can be combined)

**testFilter** allows you to pass in test filter(s) (filters on path), so you don't have to run the full test suite whilst hacking.

    ant -DtestFilter="image"
    ant -DtestFilter="mysql,oracle"

**deployLco** automates the deployment of a new `.lco` build to a local Lucee install's deploy directory

	ant quick -DdeployLco="C:\lucee\tomcat\lucee-server\deploy"
