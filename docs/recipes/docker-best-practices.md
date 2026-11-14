<!--
{
  "title": "Docker Image Best Practices",
  "id": "docker-best-practices",
  "categories": ["docker", "devops", "configuration"],
  "description": "Best practices for building your own Lucee Docker images: warmup at build time, pinned versions, configuration, Maven download policies, healthchecks, logging and secrets.",
  "keywords": [
    "Docker",
    "Dockerfile",
    "Container",
    "Best Practices",
    "Warmup",
    "CFConfig.json",
    "Maven",
    "Download Policy",
    "Healthcheck",
    "Logging",
    "Secrets"
  ],
  "related": [
    "docker",
    "warmup",
    "onbuild-function",
    "downloading-extensions",
    "extension-installation",
    "console-logging",
    "secret-management"
  ]
}
-->

# Docker Image Best Practices

The official [`lucee/lucee`](https://hub.docker.com/r/lucee/lucee) images are a good base for your own image. This recipe collects what makes such an image fast to start, reproducible and safe to run. For the basics, see [[docker]]. Ready to run examples live in the [lucee-docs examples folder](https://github.com/lucee/lucee-docs/tree/master/examples/docker).

## A complete example

```dockerfile
# pin the exact Lucee version
FROM lucee/lucee:7.0.3.43

# server configuration: extensions, datasources, loggers, ...
COPY ./.CFConfig.json /opt/lucee/server/lucee-server/context/.CFConfig.json

# your application
COPY ./www /var/www/

# install extensions and resolve everything at build time, then exit
RUN LUCEE_ENABLE_WARMUP=true /usr/local/tomcat/bin/catalina.sh run

# the final container must not download anything at startup
ENV LUCEE_MAVEN_DOWNLOAD_POLICY_STARTUP=error

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
  CMD wget -q -O /dev/null http://localhost:8888/health.cfm || exit 1
```

The sections below explain each step.

## Run warmup at build time

The most important step: run Lucee's [[warmup]] in a `RUN` step after copying your configuration. Warmup starts Lucee once, installs the extensions defined in `.CFConfig.json`, calls `onBuild` in `Server.cfc` (see [[onbuild-function]]) and exits. Everything it installs and downloads ends up in the image layer, so the container starts without downloading anything.

Warmup is enabled with the environment variable `LUCEE_ENABLE_WARMUP=true` or the system property `lucee.enable.warmup` (`lucee.build` / `LUCEE_BUILD` is the legacy alias). The official images already run warmup once while they are built, so the base image itself is warm. Your image needs its own warmup step because your configuration adds things.

Only set the variable for the `RUN` step, never with `ENV`. With `ENV`, every container started from the image would run warmup and then exit.

Java libraries from `javasettings` are resolved when they are first used, not at startup. The literal `javasettings` attribute of a component is downloaded when the component is compiled during warmup, see [[warmup]]. To bake the others in too, load them in `onBuild`, for example with `mavenLoad()` or `mavenImport()`. See [[maven]].

For more on where extensions come from, and how to download `.lex` files yourself (Maven, Docker multistage builds, curl), see [[downloading-extensions]].

## Pin versions

- Use an exact Lucee tag such as `lucee/lucee:7.0.3.43` instead of `latest` or `7.0`. Floating tags change under you, and a rebuild can then give you a different Lucee version.
- Pin extension versions in `.CFConfig.json` (or `LUCEE_EXTENSIONS`). Without a version, Lucee resolves the latest release, which can change between builds. See [[extension-installation]].
- Prefer final releases. Snapshots and pre-releases have a limited lifespan in the Maven repositories.

## Configuration: `.CFConfig.json` and environment variables

Copy your server configuration to `/opt/lucee/server/lucee-server/context/.CFConfig.json`, as all examples in the examples folder do. Keep values that differ between environments (hostnames, credentials, URLs) out of the file and use placeholders such as `${DB_HOST}`, which Lucee fills in from environment variables (as the [quartz-ai example](https://github.com/lucee/lucee-docs/tree/master/examples/docker/quartz-ai) does for its AI settings).

Settings that Lucee reads from environment variables or system properties can also be set with `ENV` in the Dockerfile or at `docker run`. See [[environment-variables-system-properties]].

Remember that extensions in `.CFConfig.json` are only processed on a fresh install, which is exactly what the warmup step does.

## Maven download policies

Lucee has two settings that control whether it may download Maven artifacts. Which one applies depends on whether the engine has finished starting:

| Setting | Applies to |
|---------|-----------|
| `LUCEE_MAVEN_DOWNLOAD_POLICY_STARTUP` (`lucee.maven.download.policy.startup`) | downloads while Lucee is starting up, for example extensions from `.CFConfig.json` |
| `LUCEE_MAVEN_DOWNLOAD_POLICY_RUNTIME` (`lucee.maven.download.policy.runtime`) | downloads after startup, for example `javasettings` libraries or `mavenLoad()` |

Both accept `ignore` (default), `warn` (download and log) or `error` (don't download, fail instead). In Lucee 8 they can also be set in `.CFConfig.json` as `maven.downloadPolicyStartup` and `maven.downloadPolicyRuntime`.

For a warmed image, set `LUCEE_MAVEN_DOWNLOAD_POLICY_STARTUP=error` in the final image (after the warmup step, as in the example above). If something wasn't baked in, startup fails right away instead of silently downloading it. Use `warn` for the runtime policy first to see what your application still downloads, and switch it to `error` once that list is empty.

## Multistage builds

If you'd rather ship `.lex` files than let warmup fetch them, download them in a separate build stage and copy only the result into the Lucee image. That keeps build tools such as Maven out of the final image. [[downloading-extensions]] has a complete multistage example.

## Healthchecks

The official images don't define a `HEALTHCHECK`. Add your own, pointing at a small page of your application that checks what matters to you (for example the database). The images include `wget`, so you don't have to install anything. Allow a `--start-period` that covers Lucee's startup.

## Logging to stdout

Containers should log to stdout so that `docker logs` and your log platform see everything. Since Lucee 6.2 you can redirect all logs to the console with environment variables:

```dockerfile
ENV LUCEE_LOGGING_FORCE_APPENDER=console
ENV LUCEE_LOGGING_FORCE_LEVEL=info
```

Alternatively configure single loggers with the `console` appender in `.CFConfig.json`. See [[console-logging]].

## Keep secrets out of the image

Everything in an image layer can be read by anyone who has the image, including values set with `ENV` or copied files that a later layer deletes. So:

- don't put passwords, API keys or tokens into the Dockerfile or `.CFConfig.json`; pass them in at runtime with environment variables or mounted files and reference them with placeholders
- set `LUCEE_ADMIN_PASSWORD` at `docker run` / in your compose file, not in the image
- for more control, use a secret provider (environment variables, files, AWS Secrets Manager, ...). See [[secret-management]] and the [secret-provider example](https://github.com/lucee/lucee-docs/tree/master/examples/docker/secret-provider).

## Related

- [[docker]]
- [[warmup]]
- [[onbuild-function]]
- [[downloading-extensions]]
- [[extension-installation]]
- [[console-logging]]
- [[secret-management]]
