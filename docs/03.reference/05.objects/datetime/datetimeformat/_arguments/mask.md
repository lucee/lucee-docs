Mask that has to be used for formatting. 
the following characters are pattern letters (case sensitive) representing the components of a datetime string. All other characters are not interpreted
- a,..,aaaa: AM/PM marker (see also "t" and "tt"; Example:AM)
- d: Day in month, no leading zero for single-digit days (Example:3)
- dd: Day in month, leading zero for single-digit days (Example:03)
- D: Day in year, no leading zero for single-digit days (Example:4)
- DD: Day in month, leading zero for single-digit days (Example:04)
- DDD: Day in month, 2 leading zero for single-digit days (Example:004)
- E,EE,EEE: Day of week as a three-letter abbreviation (Example:Tue)
- EEEE: Day of week as its full name (Example:Tuesday)
- F: Day of week in month, no leading zero for single-digit days (Example:4)
- FF: Day of week in month, leading zero for single-digit days (Example:04)
- G,GG: Era designator (Example:AD)
- h: Hour in am/pm (1-12), no leading zero for single-digit hours (Example:3)
- hh: Hour in am/pm (1-12), leading zero for single-digit hours (Example:03)
- H: Hour in day (0-23), no leading zero for single-digit hours (Example:14)
- HH: Hour in day (00-23), leading zero for single-digit hours (Example:14)
- k: Hour in day (1-24), no leading zero for single-digit hours (Example:15)
- kk: Hour in day (1-24), leading zero for single-digit hours (Example:15)
- K: Hour in am/pm (0-11), no leading zero for single-digit hours (Example:2)
- KK: Hour in am/pm (0-11), leading zero for single-digit hours (Example:02)
- l,L: milliseconds, with no leading zeros (Example:3)
- ll,LL: milliseconds, leading zero for single-digit days (Example:03)
- lll,LLL: milliseconds,  2 leading zero for single-digit days (Example:003)
- m,M: Month as digits, no leading zero for single-digit months (Example:6)
- mm,MM: Month as digits, leading zero for single-digit months (Example:06)
- mmm,MMM: Month as a three-letter abbreviation (Example:Jun)
- mmmm,MMMM: Month as its full name (Example:June)
- n,N: minutes in hour, no leading zero for single-digit minutes (Example:3)
- nn,NN: minutes in hour, leading zero for single-digit minutes (Example:03)
- s,S: seconds in minute, no leading zero for single-digit seconds (Example:3)
- ss,SS: seconds in minute, leading zero for single-digit seconds (Example:03)
- t,T: one-character time marker string (Example:P)
- tt,TT: multiple-character time marker string (Example:PM)
- w: Week in year, no leading zero for single-digit hours (Example:27)
- ww: Week in year, leading zero for single-digit hours (Example:27)
- W: Week in month, no leading zero for single-digit hours (Example:2)
- WW: Week in month, leading zero for single-digit hours (Example:02)
- y,yy,yyy: Year as last two digits, leading zero for single-digit (Example:09)
- yyyy: Year represented by four digits (Example:2009)
- z,zz,zzz: General time zone as a 3 to 4 lettesr abbreviation (Example:PST)
- zzzz: General time zone as its full name (Example:Pacific Standard Time)
- Z,..,ZZZZ: RFC 822 time zone (Example:-0800)
  
The following masks can be used to format the full date and time and may not be combined with other masks:
- short: equivalent to "m/d/y h:mm tt"
- medium: equivalent to "mmm d, yyyy h:mm:ss tt"
- long: medium followed by three-letter time zone; i.e. "mmmm d, yyyy h:mm:ss tt zzz"
- full: equivalent to "dddd, mmmm d, yyyy h:mm:ss tt zz"
- ISO8601: equivalent to "yyyy-mm-dd'T'HH:nn:ss'Z'Z"

The function follows Java date time mask.  For details, see the section Date and Time Patterns at https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html