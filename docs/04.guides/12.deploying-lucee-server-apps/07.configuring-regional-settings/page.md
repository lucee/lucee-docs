---
title: Configuring Regional Settings
id: configuring-regional-settings
categories:
- datetime
- server
- timezone
description: Lucee by default, uses the JVM's default timezone, which comes from the operating system.
---

## Timezones

Lucee by default, uses the JVM's default timezone, which comes from the operating system.

You can override this default via the Lucee Admin under, Settings, Regional

Lucee uses a cascading hierarchy for configuration

- [[tag-application|Application.cfc]] 
- Web Context (`lucee-web.xml.cfm`)
- Server Context (`lucee-server.xml`)
- JVM (which defaults to the operating system)
- When no other default is found, Lucee defaults to GMT

The regional configuration in the `.xml` files are stored under the regional tag, these are the files which the Lucee Admin updates

`<regional locale="en_US" timeserver="pool.ntp.org" timezone="" use-timeserver="true"/>`

When deploying by Docker, the timezone defaults to `Etc/UTC`. To set the timezone of the container use a Docker environment variable with the name `TZ` and then a value with a timezone name, for example, `Pacific/Auckland` or `Europe/London`. A full list of timezone names can be found here:

[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

To check what your the JVM default is set to, use the following code.

```luceescript+trycf
dump(createObject("java", "java.util.TimeZone").getDefault());
```
