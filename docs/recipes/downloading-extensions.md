<!--
{
  "title": "Downloading Extensions for CI, Docker and Offline Installs",
  "id": "downloading-extensions",
  "description": "Where to download Lucee extensions (.lex) from, and how to fetch them with Maven, curl or a Docker multistage build.",
  "keywords": [
    "extension",
    "download",
    "lex",
    "maven",
    "Maven Central",
    "snapshot",
    "pre-release",
    "Docker",
    "multistage",
    "CI",
    "offline",
    "deploy directory",
    "copy-dependencies"
  ],
  "categories": [
    "extensions",
    "devops"
  ],
  "related": [
    "extension-installation",
    "docker",
    "maven-based-extensions"
  ]
}
-->

# Downloading Extensions for CI, Docker and Offline Installs

Sometimes you want the extension files (`.lex`) themselves, for example to bake them into a Docker image, to cache them in a CI pipeline, or to install Lucee on a machine without internet access.

This recipe shows where to download extensions from and how to do it reliably.

If you only want Lucee to install extensions for you at startup, see [[extension-installation]] instead.

## Where extensions are published

All Lucee extensions are published as Maven artifacts with the group id `org.lucee` and the type `lex`.

| Source | What you find there | URL |
| --- | --- | --- |
| Maven Central | Final releases | `https://repo1.maven.org/maven2/org/lucee/` |
| Lucee Maven repository | Pre-releases (betas and RCs) | `https://maven.lucee-services.com/org/lucee/` |
| Sonatype snapshot repository | Snapshots, kept for 90 days | `https://central.sonatype.com/repository/maven-snapshots/` |
| GitHub Releases | Final releases, attached to each release of the extension repository | e.g. [extension-esapi 3.1.0.1](https://github.com/lucee/extension-esapi/releases/tag/3.1.0.1) |
| download.lucee.org | Download links for any published version | e.g. [esapi-extension 3.1.0.1](https://download.lucee.org/download.cfm?groupId=org.lucee&artifactId=esapi-extension&version=3.1.0.1) |

A few things to know:

- Starting November 2026, only final releases are deployed to Maven Central. Betas, RCs and snapshots are not.
- Starting March 2027, `maven.lucee-services.com` no longer has any snapshots. Snapshots are then only available from the Sonatype snapshot repository, which already keeps them for 90 days today. Pre-releases may also get a limited lifespan, see [Snapshot retention](https://dev.lucee.org/t/17631).
- The repositories are not exact mirrors of each other. They complement each other, with some overlap. Older history was backfilled, but not completely, so some versions only exist in one of them. Listing several repositories (see below) takes care of that.

> **Note:** Older guides sometimes use flat links like `https://ext.lucee.org/<name>-<version>.lex`. That location was never documented or guaranteed, and newer releases are not published there. Please use one of the sources above.

## Finding the artifactId and version

The artifactId is the extension's Maven name, for example `mail-extension`, `esapi-extension` or `s3-extension`.

- Browse the repositories directly: [Maven Central](https://repo1.maven.org/maven2/org/lucee/) and [maven.lucee-services.com](https://maven.lucee-services.com/org/lucee/) list every extension as a folder, and every version as a subfolder.
- Each extension has a `maven-metadata.xml` listing all versions and the latest release, for example [mail-extension](https://repo1.maven.org/maven2/org/lucee/mail-extension/maven-metadata.xml).
- [download.lucee.org](https://download.lucee.org) lists the extensions with their versions.
- On a running server, the Lucee Administrator (**Extensions > Applications**) shows the installed extensions.

The `.lex` file itself carries its metadata in `META-INF/MANIFEST.MF`, including the extension `id` (UUID), `groupId`, `artifactId` and `version`. You can check it with:

```bash
unzip -p esapi-extension-3.1.0.1.lex META-INF/MANIFEST.MF
```

## Option 0: Let Lucee install them itself (no download needed)

Often you don't need the `.lex` files at all. You can list the extensions in `.CFConfig.json` (or the `LUCEE_EXTENSIONS` environment variable) and Lucee resolves and installs them at startup from its configured Maven repositories. The syntax differs between Lucee 7 and Lucee 8.

### Lucee 7.x: `.CFConfig.json` with `id`

On Lucee 7, each entry in `.CFConfig.json` is identified by the extension UUID (`id`). `version` is optional, but pinning it is recommended. An entry without a valid `id` is ignored, unless it has a `path`/`resource`/`url` pointing to a reachable `.lex` file.

```json
{
  "extensions": [
    {
      "id": "60772C12-F179-D555-8E2CD2B4F7428718",
      "version": "4.0.0.2"
    }
  ]
}
```

### Lucee 8.x: `.CFConfig.json` with `maven`

Lucee 8 accepts Maven coordinates (`groupId:artifactId:version`) directly with the `maven` key (alias `mvn`). An `id` is no longer required:

> **Note:** Lucee 8 still supports the Lucee 7 syntax. Entries with `id` (and optional `version`) in `.CFConfig.json` keep working, as do UUID entries in `LUCEE_EXTENSIONS`, so you don't have to change an existing configuration when upgrading.

```json
{
  "extensions": [
    {
      "maven": "org.lucee:redis-extension:4.0.0.2"
    }
  ]
}
```

### `LUCEE_EXTENSIONS` (Lucee 7 and 8)

The `LUCEE_EXTENSIONS` environment variable (or `-Dlucee.extensions` system property) accepts Gradle style Maven coordinates, comma separated, on both Lucee 7 and Lucee 8:

```plaintext
LUCEE_EXTENSIONS=org.lucee:s3-extension:2.0.2.21,org.lucee:redis-extension:4.0.0.2
```

See [[extension-installation]] for all formats and details, for example that `.CFConfig.json` extensions are only processed on a fresh install.

### Making failed downloads visible

By default a Maven download at startup is silent. Set `LUCEE_MAVEN_DOWNLOAD_POLICY_STARTUP` (system property `lucee.maven.download.policy.startup`) to `warn` to log every download, or to `error` to fail instead of downloading. With `error` you can check that an image really contains everything and never downloads at startup. The same exists for runtime downloads with `LUCEE_MAVEN_DOWNLOAD_POLICY_RUNTIME`.

### When downloading the files is still the better choice

- offline or air gapped servers and images
- locked down networks without access to the Maven repositories
- Docker images where you want everything baked in, so containers don't download anything at startup
- caching extensions in CI instead of fetching them on every run

For these cases, use one of the options below.

## Option 1: Maven (recommended)

The best approach is to declare the extensions as Maven dependencies with the type `lex`. You can list several repositories, and Maven picks each version from wherever it lives. Lucee itself resolves extensions the same way.

Create a small `pom.xml` that only lists your extensions:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
	<modelVersion>4.0.0</modelVersion>
	<groupId>local</groupId>
	<artifactId>lucee-extensions</artifactId>
	<version>1</version>
	<packaging>pom</packaging>

	<repositories>
		<repository>
			<id>central</id>
			<url>https://repo1.maven.org/maven2/</url>
		</repository>
		<repository>
			<id>lucee</id>
			<url>https://maven.lucee-services.com/</url>
		</repository>
		<repository>
			<id>sonatype-snapshots</id>
			<url>https://central.sonatype.com/repository/maven-snapshots/</url>
			<releases><enabled>false</enabled></releases>
			<snapshots><enabled>true</enabled></snapshots>
		</repository>
	</repositories>

	<dependencies>
		<dependency>
			<groupId>org.lucee</groupId>
			<artifactId>mail-extension</artifactId>
			<version>1.1.0.17</version>
			<type>lex</type>
		</dependency>
		<dependency>
			<groupId>org.lucee</groupId>
			<artifactId>esapi-extension</artifactId>
			<version>3.1.0.1</version>
			<type>lex</type>
		</dependency>
	</dependencies>
</project>
```

Maven ignores snapshot versions from a repository unless snapshots are enabled for it, which is why the Sonatype repository has `<snapshots><enabled>true</enabled></snapshots>`. If you only use final releases, you can leave the last two repositories out.

Then copy the `.lex` files to the folder you want:

```bash
mvn -q dependency:copy-dependencies -DoutputDirectory=/opt/lucee/server/lucee-server/deploy
```

Maven stores everything it downloads in its local repository (`~/.m2/repository`), so a second run doesn't download the files again. In CI, cache that folder between runs.

## Option 2: Docker multistage build

You don't need Maven in your final image. Use the official `maven` image in a first stage to download the extensions, then copy them into the Lucee image:

```dockerfile
# stage 1: download the extensions
FROM maven:3.9-eclipse-temurin-21 AS extensions
WORKDIR /build
COPY pom.xml .
RUN mvn -q dependency:copy-dependencies -DoutputDirectory=/build/deploy

# stage 2: the Lucee image
FROM lucee/lucee:7.0
COPY --from=extensions /build/deploy/ /opt/lucee/server/lucee-server/deploy/
```

The extensions are downloaded once, when the image is built, and are part of the image. Containers started from it don't download anything.

## Option 3: Plain download with curl

For a single file, download it directly from Maven Central. The URL follows the Maven layout:

```plaintext
https://repo1.maven.org/maven2/org/lucee/<artifactId>/<version>/<artifactId>-<version>.lex
```

For example:

```bash
curl -fsSL -o /opt/lucee/server/lucee-server/deploy/mail-extension-1.1.0.17.lex \
	https://repo1.maven.org/maven2/org/lucee/mail-extension/1.1.0.17/mail-extension-1.1.0.17.lex
```

Use `-f` so that a failed download fails your build instead of saving an error page as a `.lex` file.

Pre-releases use the same layout on `https://maven.lucee-services.com/`. Final releases can also be downloaded from the extension's GitHub Releases page, for example:

```bash
curl -fsSL -O https://github.com/lucee/extension-esapi/releases/download/3.1.0.1/esapi-extension-3.1.0.1.lex
```

The download page links work too, for example in a Dockerfile:

```dockerfile
ADD https://download.lucee.org/download.cfm?groupId=org.lucee&artifactId=esapi-extension&version=3.1.0.1 \
	/opt/lucee/server/lucee-server/deploy/esapi-extension-3.1.0.1.lex
```

## Installing the downloaded files

Copy the `.lex` files into `{lucee-installation}/lucee-server/deploy`. Lucee installs them at startup, or within about a minute on a running server. In the official Docker images that folder is `/opt/lucee/server/lucee-server/deploy`.

Check `lucee-server/context/logs/deploy.log` to see what was installed.

Alternatively, you can let Lucee download extensions itself with the `LUCEE_EXTENSIONS` environment variable or the `extensions` key in `.CFConfig.json`, see [[extension-installation]]. A `.CFConfig.json` entry can also point to a local file with `resource`, which is useful for offline installs.

## Best practices

- **Download once, not on every start.** Download extensions when you build the image, or cache them in CI. A container that downloads its extensions on every start can end up downloading them thousands of times a day if it gets stuck in a restart loop.
- **Pin versions.** Always use an exact version. For anything long-lived, such as production images and CI pipelines, pin final releases.
- **Don't depend on snapshots or pre-releases long term.** Snapshots are removed after 90 days, and pre-releases may get a limited lifespan too. They are meant for testing.
- **List several repositories** when you use Maven, so every version is found wherever it is published.
- **Fail on errors.** Make sure a failed download fails the build, for example with `curl -f`.
