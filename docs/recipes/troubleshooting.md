
<!--
{
  "title": "Troubleshooting Lucee Server problems",
  "id": "troubleshooting",
  "categories": [
    "server",
    "debugging"
  ],
  "description": "A guide to diagnosing problems with Lucee",
  "keywords": [
    "startup",
    "deployment",
    "logs"
  ],
  "related":[
  ]
}
-->

# Troubleshooting Lucee Problems

This guide is about how to troubleshoot problems with Lucee, including crashes, startup problems etc.

Sadly, this guide isn't about why the code you're writing isn't working!

## Logs

Lucee and Tomcat have comprehensive logging, which is the best starting place to start looking when diagnosing why something server related isn't working.

### Servlet Engine - i.e. Tomcat

Your Servlet Engine will have its own logging, as Lucee is distributed with Tomcat, this guide will focus and refer to Tomcat, but the same principle applies more or less to every Servlet Engine.

Under your Lucee install directory, there will be a `tomcat` folder, inside this folder is a `logs` directory.

The main log file for tomcat is called `catalina-{date}-.log` and this log will contain the startup logs and shutdown logs, plus any exceptions along the way from the Servlet engine.

### Lucee Server

Lucee is a Servlet which runs on a Servlet Engine, it deploys itself into a directory called `lucee-server`.

Under this directory is a `context/logs` directory, which contains all the Lucee log file in a default configuration.

Lucee startup has two stages

#### Initial startup / deployment

This happens before log4j is loaded and configured, so Lucee writes out it's early logs and any problems to these two log files, it's also the fallback "global" log if log4j ever isn't working

- `out.log` which is the standard log, including deploying files and loading configuration
- `err.log` which contains any errors encountered during this early stage.

Once the initial startup and deployment has got far enough along to have loaded configuration and configure log4j, Lucee then switches to using its normal logging files.

- `application.log` the default log for Lucee and applications, aka the util folder of logging
- `exception.log` any errors or exceptions
- `deploy.log` Logs about the deployment of Extensions

#### Deleting the felix cache

Sometimes the Felix cache gets corrupted, perhaps when updating or messing around with extensions.

It's found under `lucee-server\felix-cache`. Sometimes, stopping Tomcat, deleting that folder and restarting will solve problems. 

Lucee will automatically recreate it on startup.

#### Starting Tomcat manually and redirecting logs to console.

The best first step when debugging a Lucee Server is start Tomcat manually, in a Terminal, as opposed to auto starting or running as service/daemon.

In the `tomcat/bin` directory, there's a bash/batch file called `catalina.sh` or `catalina.bat` which can be run with the run option, i.e `./cataline.sh run` or `catalina run`

By default, this will show all the `catalina.log` information in the console.

Since Lucee 6.2, you can also redirect all the log4j logging to the console. (TODO out.log and err.log!)

On Windows

```batch
set LUCEE_LOGGING_FORCE_APPENDER=console
set LUCEE_LOGGING_FORCE_LEVEL=info # or trace, or debug

```

On Linux

```bash
export LUCEE_LOGGING_FORCE_APPENDER=console
export LUCEE_LOGGING_FORCE_LEVEL=info # or trace, or debug
```

This will override writing to your logs to files and instead it will stream all the logs out to the console. Changing the `LUCEE_LOGGING_FORCE_LEVEL` is optional, as it can be quite verbose, but it provides useful clues when something isn't working.

### Summary

Hopefully, this guide will help you navigate around the Lucee and Tomcat logs, which should provide some clues to help your solve whatever problem you are facing.

### Reaching out for help.

Please first check whatever search engine or LLM, you prefer and/or search the [https://dev.lucee.org](https://dev.lucee.org) Developer forum and our issue tracking system [https://luceeserver.atlassian.net/](https://luceeserver.atlassian.net/) Jira.

If you can't find a solution to your problem, please post to the dev forum first and include all the relevant details.

Ask yourself, if you were assisting someone else with your problem, what questions would you ask when you read your support request before you press send.

- Lucee version, i.e. 6.2.1.188
- Servlet engine, i.e. Tomcat
- Operating system: i.e, Ubuntu 24
- Distribution, i.e. Lucee Installer, Lucee Docker images, CommandBox, homegrown etc

Plus whether you are using an older install which has been upgraded, or a fresh installation.

If you find any relevant exceptions / stacktraces, please include them, not just the exception message.

[[tutorial-reporting-bugs]]
