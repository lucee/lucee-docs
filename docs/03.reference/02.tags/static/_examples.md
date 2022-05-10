```lucee+trycf
<cfcomponent>
    <!--- inside the static constructor you can define static variables, this code is executed when the "class" instance is loaded --->
    <cfstatic>
        <cfset susi=1> <!--- written to the static scope (defining the scope is not necessary) --->
        <cfset static.sorglos=2> <!--- again written to the static scope --->
    </cfstatic>
<cfcomponent>
```
