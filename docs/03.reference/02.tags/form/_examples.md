```lucee+trycf
<cfform name="mycfform">
    -- year --
    <br />
    <cfselect name="year" enabled=true style="color:blue;" size=2>
        <option name="0" selected=true>--2024--</option>
        <option name="1">--2023--</option>
        <option name="3">--2022--</option>
        <option name="2">--2021--</option>
    </cfselect> <br />
    -- color --
    <br />
    <cfselect name="color" >
        <option name="0">--red--</option>
        <option name="1">--green--</option>
        <option name="2">--blue--</option>
    </cfselect>
</cfform>
```