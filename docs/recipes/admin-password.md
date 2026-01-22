<!--
{
  "title": "Setting the Lucee Admin Password",
  "id": "admin-password",
  "categories": ["configuration", "security"],
  "description": "How to set, hash, and reset the Lucee Administrator password",
  "keywords": [
    "admin",
    "password",
    "security",
    "LUCEE_ADMIN_PASSWORD",
    "CFConfig"
  ],
  "related": [
    "config",
    "environment-variables-system-properties",
    "single-vs-multi-mode",
    "troubleshooting",
    "cookbook-configuration-administrator-cfc",
    "function-configimport",
    "archives-creating-and-deploy",
    "deploying-lucee-server-apps",
    "locking-down-lucee-server",
    "function-configimport"
  ]
}
-->

# Setting the Lucee Admin Password

This guide covers the various ways to set the Lucee Administrator password, security considerations, and how to reset a forgotten password.

The Lucee admin password is used both for logging into the admin and for performing configuration updates, so even if the Admin is not installed / deployed, you may still need a password defined to perform certain tasks.

The Lucee admin, which is written in CFML simply uses the [[cfadmin-docs]] `<cfadmin>` with a password to perform operations.

## Overview

Lucee's administrator interface (`/lucee/admin/index.cfm`) is protected by a password. 

There are several ways to set this password:

- Placing a `password.txt` in the `lucee-server/context` directory
- Environment variable / system property
- `.CFConfig.json` configuration file (pre-hashed only)

For background on Lucee's configuration hierarchy, see [[config]].

## Using password.txt

For initial setup, you can drop a `password.txt` file into the `lucee-server/context` directory containing just the password.

**Note:** This only works when no password is already set (i.e., no `hspw` exists in `.CFConfig.json`).

## Environment Variable

The simplest approach for Docker or automated deployments is using the `LUCEE_ADMIN_PASSWORD` environment variable:

```bash
LUCEE_ADMIN_PASSWORD=mysecretpassword
```

Or as a Java system property:

```bash
-Dlucee.admin.password=mysecretpassword
```

**Note:** This sets the password in plaintext. While convenient for development or Docker environments, the password is visible in process listings and environment dumps.

## Using .CFConfig.json

You can set the password in your `.CFConfig.json` file using a pre-hashed value. See [[config]] for details on configuration file locations.

**Important:** There is no plaintext password option in `.CFConfig.json`. For plaintext passwords, use `password.txt` or the `LUCEE_ADMIN_PASSWORD` environment variable instead.

### Password Keys

Two keys are supported for pre-hashed passwords:

- `hspw` + `salt` - hashed with salt (preferred, more secure)
- `pw` - hashed without salt (legacy, less secure)

Lucee always writes passwords using `hspw` + `salt`. The `pw` key exists for backwards compatibility.

### Hashed Password Example

```json
{
  "hspw": "hashed-password-here",
  "salt": "salt-value-here"
}
```

To generate a hashed password:

1. Set the password via `password.txt` or the `LUCEE_ADMIN_PASSWORD` environment variable
2. Start Lucee and let it hash the password
3. Copy the resulting `hspw` and `salt` values from `.CFConfig.json`

For implementation details, see [PasswordImpl.java](https://github.com/lucee/Lucee/blob/6.2/core/src/main/java/lucee/runtime/config/PasswordImpl.java) in the Lucee source.

## Single Mode vs Multi Mode

In **single mode** (Lucee 6+ default for new installations, only mode in Lucee 7), there's one admin password for the entire server.

In **multi mode** (Lucee 5, or upgraded Lucee 6 installations), there are two types of admin:

- **Server Admin** - Controls server-wide settings
- **Web Admin** - Controls per-web-context settings

Each can have its own password. The server admin password is set in the server `.CFConfig.json`, while web admin passwords are set in each web context's `.CFConfig.json`.

For more details, see [[single-vs-multi-mode]].

## Disabling the Admin

For production environments where you don't need the admin interface, you can disable it entirely:

```bash
LUCEE_ADMIN_ENABLED=false
```

Or in `.CFConfig.json`:

```json
{
  "adminEnabled": false
}
```

This is the most secure option for production deployments where configuration is managed via files or environment variables.

## Resetting a Forgotten Password

If you've forgotten your admin password:

### Option 1: Delete the Password and Use Environment Variable

1. Stop Lucee
2. Open the `.CFConfig.json` file (typically at `lucee-server/context/.CFConfig.json`)
3. Remove the `hspw` and `salt` keys (or set them to `null`)
4. Set the `LUCEE_ADMIN_PASSWORD` environment variable
5. Restart Lucee

**Note:** The environment variable is only used as a fallback when no password is set in `.CFConfig.json`. It does not override an existing password.

### Option 2: Delete the Password and Use password.txt

1. Stop Lucee
2. Open the `.CFConfig.json` file (typically at `lucee-server/context/.CFConfig.json`)
3. Remove the `hspw` and `salt` keys (or set them to `null`)
4. Create a `password.txt` file in the same directory with your new password
5. Restart Lucee - Lucee will hash the password and delete `password.txt`

## Programmatic Configuration

You can also manage the admin password programmatically using `Administrator.cfc` or the `cfadmin` tag. See [[cookbook-configuration-administrator-cfc]] for details.

For importing configuration at startup, see [[function-configimport]].

## Script-Runner

Lucee Script Runner is used for running Lucee headless via the command line, for tests, batch jobs or CI.

The default password for [Lucee Script Runner](https://github.com/lucee/script-runner) is `admin`

## Security Considerations

- **Avoid committing passwords** to version control when possible - use environment variables instead
- **Use environment variables** or secrets management for production deployments
- **Consider disabling the admin** entirely in production if not needed
- **Use strong passwords** - the admin has full control over your Lucee installation
- **Restrict network access** to the `/lucee/` path in your web server configuration
