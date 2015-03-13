
Characters that show how Lucee displays a date:
- d: Day of the month as digits; no leading zero for single-digit days.
- dd: Day of the month as digits; leading zero for single-digit days.
- ddd: Day of the week as a three-letter abbreviation.
- dddd: Day of the week as its full name.
- m: Month as digits; no leading zero for single-digit months.
- mm: Month as digits; leading zero for single-digit months.
- mmm: Month as a three-letter abbreviation.
- mmmm: Month as its full name.
- yy: Year as last two digits; leading zero for years less than 10.
- yyyy: Year represented by four digits.
- gg: Period/era string. Ignored. Reserved. The following masks tell how to format the full date and cannot be combined with other masks:
- short: equivalent to m/d/y
- medium: equivalent to mmm d, yyyy
- long: equivalent to mmmm d, yyyy
- full: equivalent to dddd, mmmm d, yyyy