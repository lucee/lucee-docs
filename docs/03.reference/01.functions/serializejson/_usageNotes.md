### Date format

By default `serializeJSON` writes date/time values in the traditional Lucee format, for example `January, 29 2021 11:45:26 +0100`.

From Lucee 9.0 you can change this with the setting `dateFormat`, either per application in the `Application.cfc` (`this.serialization.dateFormat`) or for the whole server in the configuration (`serialization.dateFormat` in `.CFConfig.json`). A value defined in the `Application.cfc` overrides the value in the configuration.

| Value | Result |
| --- | --- |
| `cf` (default) | traditional Lucee format, `January, 29 2021 11:45:26 +0100` |
| `iso` (or `iso8601`) | ISO 8601, `2021-01-29T11:45:26+01:00` |
| `isoms` (or `isoMillis`) | ISO 8601 including milliseconds, `2021-01-29T11:45:26.123+01:00` |
| any other value | used as a custom date/time mask, for example `yyyy-MM-dd HH:mm:ss` |

An invalid mask throws an exception.

The date is written in the time zone of the current request (see [[tag-application]] attribute `timezone`).

The setting only affects `serializeJSON`. In the format `iso`, a date in the UTC time zone is written with the offset `Z`, for example `2021-01-29T10:45:26Z`.

The setting can also be defined with the system property `lucee.serialization.dateformat` or the environment variable `LUCEE_SERIALIZATION_DATEFORMAT`.

For versions before 9.0, format the dates yourself before you serialize the data, for example with `dateTimeFormat( date, "iso8601" )`.
