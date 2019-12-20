```luceescript+trycf
    mydate = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()));
    writeOutput("The time is " & timeFormat(myDate, "HH:MM:ss") & " on " & dateFormat(myDate, "dddd, d mmmm yyyy") & ".");
```