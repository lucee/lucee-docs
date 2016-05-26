---
title: Building Lucee from source
id: working-with-source-build-from-source
---

# Building from source #

The following text assumes that you have basic knowledge of how to use git and ant, if not please first consult the documentation for this tools.

### 1. Before you get started

Before you can start building Lucee from source, you will need a few things installed on your machine:

1. **Java JDK** - since you're going to compile Java code you need the JDK and not just the JRE.  Lucee requires JDK 6 or later in order to compile.  http://www.oracle.com/technetwork/java/javase/downloads/

1. **Apache ANT** - the source code contains several build scripts that will automate the build process for you. you will need ANT installed in order to run these build scripts. http://ant.apache.org/bindownload.cgi

### 2. Get the source code

Lucee's source code is version-controlled with GIT and is hosted on github.com [GitHub](https://github.com/lucee/lucee).

The repository contains a few branches, with the most important ones being "Master" (current release) and "Develop" (alpha and beta releases).

So simply clone the repository to your local drive with the following command:
$ git clone https://bitbucket.org/lucee/lucee.git


### 3. Edit /lucee-core/src/lucee/runtime/Info.ini

The build process will generate a patch file that you can deploy as an update to Lucee servers. In order for the patch to work, its version must be higher than the current version on the server that you wish to patch.

You should set the version in **/lucee-java/lucee-core/src/lucee/runtime/Info.ini**

The content of this file will look similar to this:

    [version]
    number=4.5.0.042
    level=os
    state=final
    name=Neo
    name-explanation=https://www.facebook.com/neo.cfm
    release-date=2015/01/01 00:00:00 CET

Simply edit the value of the number property so that it is higher than the version on the server that you plan to patch.
It is not necessary to set the release date, this is made by the build process.

### 4. Build with ANT

Open a Command Prompt (or Shell) and change the working directory to the root of the project, then simply execute:

    ant

The build process should take a less than a minute.  Once it's finished, you can find the newly built patch files in /dist/**.

To also build the different bundles we provide to download (war, jars, express, tomcat installer), simply execute:

    ant express

to build Lucee and the express bundles

    ant custom

to build Lucee and all custom bundles (jars zip, war file ...)

    ant installer

to builld Lucee and the Tomcat installers

    ant all

to build everything mention above

    ant fast
    
to build without running the test cases

You can also build Lucee using Maven via:

    mvn clean install

### Java notes
Currently the build process requires Java 6 to build successfully, however support for Java 7 and 8 will be added soon. Java 6 is available for Windows and Linux from the Oracle website at the following link:

http://www.oracle.com/technetwork/java/javase/archive-139210.html

### Java for Mac OS X
For Mac OS X you will need to obtain a package from the Apple Developer site, as until Java 7, Java on Mac OS X was maintained and provided by Apple. To do this go to the following URL:

https://developer.apple.com

and sign in using an Apple developer account or register for an account (it's free). Once you have signed in go to the download section and search for the following package:

Java for OS X 2013-005 Developer Package

Download this package and install it. Once installed go to the terminal window and run ```javac -version``` and make sure it is version 1.6. If not then you already have another version of the Java SDK installed and need to override the Java home by adding the following to either your .profile or .bash_profile file in your home folder (whichever already exists):

    export JAVA_HOME="/Library/Java/JavaVirtualMachines/1.6.0_65-b14-462.jdk/Contents/Home/"

Once you have added this, exit terminal and open a new terminal and check the Java version again using the `javac -version` command.

### Ant notes
If when you run Ant you get an error message that says:

    java.lang.OutOfMemoryError: Java heap space

This means you need to give Ant more memory to run. To do this you can set an environment variable, ANT_OPTS, with the JVM memory settings in it, like so:

Linux / Mac: `export ANT_OPTS="-Xms256m -Xmx1024m"`

Windows: `set ANT_OPTS=-Xms256m -Xmx1024m`

Once set this should allow Ant to run without issue. For Linux and Mac you can add this export to your bash profile to load automatically.

### IntelliJ IDEA notes
The cloned repository can be easily imported into a new, empty Java project in IntelliJ IDEA 14. You should end up with 4 modules within the project: lucee-core, lucee-debug, lucee-instrumentaion, lucee-loader. Opening the main build.xml in the project root should give you all the build options as outlined above.

The default setup in IntelliJ IDEA provides 128m heap memory for the build process. This will most likely be not enough. The heap memory setup strategy as explained in the previous is not applicable for building from within the IDE though. Instead find the properties dialog for the build file and change the setting of 128m to 256m or as high as necessary.

Further information is provided in Jetbrains IntelliJ IDEA documentation: https://www.jetbrains.com/idea/help/controlling-behavior-of-ant-script-with-build-file-properties.html
