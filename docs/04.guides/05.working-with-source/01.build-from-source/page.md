---
title: Building Lucee 5.x from source
id: working-with-source-build-from-source
---

# Building 5.x from source #

The following text assumes that you have basic knowledge of how to use git and mvn, if not please first consult the documentation for this tools.

### 1. Before you get started

Before you can start building Lucee from source, you will need a few things installed on your machine:

1. **Java JDK** - since you're going to compile Java code you need the JDK and not just the JRE.  Lucee requires JDK 6 or later in order to compile.  http://www.oracle.com/technetwork/java/javase/downloads/

1. **Apache Maven** - the source code contains several build scripts that will automate the build process for you. you will need Maven installed in order to run these build scripts. http://maven.apache.org/

1. **Apache Ant** - the source code contains several build scripts that will automate the build process for you. you will need Maven installed in order to run these build scripts. http://ant.apache.org/bindownload.cgi

### 2. Get the source code

Lucee's source code is version-controlled with GIT and is hosted on github.com [GitHub](https://github.com/lucee/lucee).

The repository contains a few branches, with the most important ones being "Master" (current release) and "Develop" (alpha and beta releases).

So simply clone the repository to your local drive with the following command:

    git clone https://github.com/lucee/Lucee.git

### 3. Build it

To run the test suite:

    cd loader
    mvn test

To build the server:

    mvn clean install

### 4. Deploy

TBD
