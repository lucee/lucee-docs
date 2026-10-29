<!--
{
  "title": "Troubleshooting FTP and SFTP connections",
  "id": "ftp-troubleshooting",
  "description": "How to see what is happening on the wire when cfftp or an ftp:// path fails, using the FTP and SFTP debug switches.",
  "keywords": [
    "FTP",
    "SFTP",
    "cfftp",
    "debug",
    "troubleshooting",
    "JSch",
    "console"
  ],
  "related": [
    "environment-variables-system-properties",
    "running-lucee-system-properties",
    "virtual-file-system",
    "console-logging",
    "troubleshooting"
  ],
  "categories": [
    "server"
  ]
}
-->

# Troubleshooting FTP and SFTP connections

When a connection made with `cfftp` or an `ftp://` path fails, the exception often only tells you that something went wrong. Two debug switches make the FTP extension print what is sent to and received from the server, much like the log of a desktop FTP client.

| Protocol | System property | Environment variable | What it prints |
|----------|-----------------|----------------------|----------------|
| FTP | `-Dlucee.debug.ftp=true` | `LUCEE_DEBUG_FTP=true` | Every FTP command sent and every reply received |
| SFTP | `-Dlucee.debug.jsch=true` | `LUCEE_DEBUG_JSCH=true` | The JSch (SSH) trace: key exchange, host key and authentication negotiation, and channel setup |

Both switches are off by default.

## Enabling the switches

Set them before Lucee starts, either as a Java system property or as an environment variable. See [[running-lucee-system-properties]] for the different ways to do this.

```bash
# system properties, e.g. in setenv.sh / CATALINA_OPTS
-Dlucee.debug.ftp=true
-Dlucee.debug.jsch=true

# or environment variables
export LUCEE_DEBUG_FTP=true
export LUCEE_DEBUG_JSCH=true
```

The setting is read when the FTP or SFTP client is first created, so restart Lucee after changing it.

## Where the output goes

The output is written to the console (stdout) of the Lucee process, not to a Lucee log file. With Tomcat that is `catalina.out`, in Docker it is the container log. See [[console-logging]] for more on console output.

The trace contains the user name and the server replies, so switch the debug flag off again once you have your answer, and take care before sharing the output.

## Typical things to look for

- **FTP**: the reply codes after `USER`, `PASS`, `PASV`/`EPSV` and `STOR`/`RETR` show whether the login, the passive mode data connection or the transfer failed.
- **SFTP**: the key exchange and host key lines show which algorithms the client and server offer. A server that only offers algorithms the client does not accept will fail before authentication starts.
