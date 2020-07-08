---
title: Lucee Command Line Interface
id: command-line-interface
menuTitle: Command Line Interface
---

The Lucee CLI allows you to run your CFML in an operating system context-- that is, from your command line, without having to start a servlet container first!

Integration at this level of the OS is pretty new to CFML, and we're trying to learn from what has come before us in this area (Perl, Python, Ruby, etc.), by repeating things that work well and avoiding potential pitfalls.

Right now, at the beginning, we would like to lay a solid foundation for the future.

To this end, feel free to hop into the user group and join the conversation!

### Download ###

The CLI is currently available for Windows (win32 version), Linux and OS X (bin version).

[http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli/0.1.1/](http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli/0.1.1/)

There are RPM and DEB packages for Linux, as well as a platform neutral Jar.

(The DEB/RPM packages put the CLI @ /usr/bin/lucee)

It is available with or without a JRE, and there is an experimental "CLI Express" version, which uses the CLI in "server" mode to run an instance of Lucee.

[http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli.jre/0.1.1/](http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli.jre/0.1.1/)

[http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli.express/0.1.1/](http://cfmlprojects.org/artifacts/org/getlucee/lucee.cli.express/0.1.1/)

### Installation ###

Call lucee or lucee.exe (depending on OS) directly, or put it somewhere in your system path, or modify your system path to include the executable's location.

The current incarnation of the CLI contains the libs needed to run Lucee, and expands them into $HOME/.lucee (if they're not there), which is also where it stores configuration data (datasources, etc.).

The first run might take a few seconds to start up, but after that it's faster.

### Updating ###

If you download a new version of the CLI, replace the old executable (or install the new rpm/deb), and then update the resources in $HOME/.lucee by running

```lucee
lucee -update
```

Using $HOME/.lucee allows users relying on the CLI to update their own configurations and libs when they are ready to, even after the system CLI executable has been updated, and avoids potential library conflicts which would occur if all users were sharing the same resource.

Installing and updating will change, as the discussion/experimentation evolves.

### This is a test of a test -- Issues ###

For now, as an option for tracking strong ideas and problems (not that the two are related), and towards the impossible goal of being the best we can be:

[https://github.com/denuno/lucee-build/issues](https://github.com/denuno/lucee-build/issues)

These "issues" are one option for collaboration until we're settled, and the user group is a fine place for discussion as well.

### Usage ###

To run a file:

```lucee
lucee supercool.cfm
```

Or (does not need cfm/cfc suffix):

```lucee
lucee foo
```

Pass in variables (available in the URL scope currently)

```lucee
lucee awesome.cfm param1=5&param2=susi
```

The current directory is the "root", so any files generated, etc. will be relative to the directory you executed the CLI in.

### NIX ###

*Ubuntu, CentOS6, FreeBSD and OS X*

If you install the RPM or DEB on linux (or copy the bin to /usr/bin/lucee manually, as you would for OS X), you can leverage /usr/bin/env to write scripts like this:

mindblown.sh:

```lucee
#!/usr/bin/env lucee
<cfoutput>#now()#</cfoutput>
```

$chmod +x mindblown.sh

$./blowmind.sh

```lucee
#!/usr/bin/env lucee
{ts '2012-08-01 15:25:15'}
```

As you can see we still need to figure out a way to "eat" the #!/usr/bin/env line, but it's pretty awesome anyway.

### Interactive Shell / REPL ###

There is an initial stab at an interactive shell, or REPL (Read-Eval-Print-Loop) as well.

Eventually we will probably embed it into the CLI itself, but for now it should be in the zip, and the sources are available here at the moment:

[https://github.com/denuno/lucee-build/blob/master/build/resource/cli/shell.cfm](https://github.com/denuno/lucee-build/blob/master/build/resource/cli/shell.cfm)

Eventually the CLI will have its own project space however.

To run the shell

```lucee
lucee shell.cfm
```

### Server mode ###

You can run the CLI in "server" mode (embedded jetty), for traditional interaction.

Start the server (webroot is current dir):

```lucee
lucee -server
```

Start the server with log level=DEBUG mode (This is awesome! Shows classloader hierarchies y todo. ):

```lucee
lucee -server -debug
```

Start the server and background it:

```lucee
lucee -server -background
```

To stop it:

```lucee
lucee -stop
```

There is also a taskbar item that controls the server process, if you are using a windowing system (default positions are top right for Linux/OS X, bottom right for Windows)

### Server mode options and defaults ###

Default http port is 8088, and configurable with the --port argument:

```lucee
lucee -server -background --port=8888
```

Default stop-port (socket to listen on for shutdown request) is 8779, and configurable with the --stop-port argument:

```lucee
lucee -server -background --stop-port=9899
```

Default URL to open after starting is http://$host:$port, and configurable with the --open-url argument:

```lucee
lucee -server -background --open-url=http\:\/\/$host\:$por
```

open url with relative path:

```lucee
lucee -server --open-url=./foo/bar/index.cfm
```

Misc other options, some more experimental than others (-libs for exec):

```lucee
 -c,--context <context>                 context path.  (/)
 -d,--dirs <path,path,...>              List of external directories to serve
                                        from
 -ajp,--ajp-port <ajp port>             AJP port.  Disabled if not set.
 -enableajp,--enable-ajp <true|false>   Enable AJP.  Default is false
 -level,--loglevel <level>              log level [DEBUG|INFO|WARN|ERROR]
                                        (DEBUG)
 -libs,--libdir <path,path,...>         List of directories to add contents of
                                        to classloader
 -logdir,--log-dir <path/to/log/dir>    Log directory.  (WEB-INF/logs)
 -requestlog </path/to/log>             Log requests to specified file
 -t,--timeout <seconds>                 Startup timeout for background process.
                                        (50)
```
