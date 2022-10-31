```luceescript+trycf
orgLocale = getLocale();
setLocale(orgLocale);
writeDump(label:"Date.Month.year", var:lsIsDate("02.01.2018"));
writeDump(label:"year in two digits", var:lsIsDate("02.01.04"));
writeDump(label:"Month in string", var:lsIsDate("2. January 2018"));
writeDump(label:"Month/Date with Locale", var:lsIsDate("12/31/2008",'english (us)'));
writeDump(label:"Date/Month", var:lsIsDate("31/12/2018",'english (us)'));
writeDump(label:"Month Date, year", var:lsIsDate("Feb 29, 2020",'english (us)'));
writeDump(label:"Date Month year", var:lsIsDate("29 February 2020",'english (uk)'));
writeDump(label:"day, Date Month year", var:lsIsDate("Saturday, 29 February 2020",'english (uk)'));
writeDump(label:"Date-Month-year", var:lsIsDate("30-Feb-2020",'english (uk)'));
```