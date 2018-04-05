Characters that show how Lucee displays a time:
- h: hours; no leading zero for single-digit hours (12-hour clock)
- hh: hours; leading zero for single-digit hours (12-hour clock)
- H: hours; no leading zero for single-digit hours (24-hour clock)
- HH: hours; leading zero for single-digit hours (24-hour clock)
- m: minutes; no leading zero for single-digit minutes
- mm: minutes; a leading zero for single-digit minutes
- s: seconds; no leading zero for single-digit seconds
- ss: seconds; leading zero for single-digit seconds
- l or L: milliseconds, with no leading zeros
- t: one-character time marker string, such as A or P
- tt: multiple-character time marker string, such as AM or PM
- z: Time zone in literal format, for example, IST
- Z: Time zone in hours of offset (RFC 822 TimeZone), for example, +0530
- X: Time zone in hours of offset in ISO 8601 format. The following are the three ways of using 'X':
         X: +05
         XX: +0530
         XXX: +5:30

- short: equivalent to h:mm tt
- medium: equivalent to h:mm:ss tt
- long: equivalent to h:mm:ss tt {timezone-3-letters}
- full: equivalent to h:mm:ss tt {timezone-3-letters}