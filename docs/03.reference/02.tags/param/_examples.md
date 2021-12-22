### Simple Example

### Tag example

```lucee+trycf
<cfparam name="FORM.test" default="1">
<cfif FORM.test EQ '1'>
    <cfset isError = false>
<cfelse>
  <cfset isError = true>
</cfif>
<cfoutput>#isError#</cfoutput>
```

### Script example

```luceescript+trycf
  param name="FORM.test" default="1";
    if(FORM.test EQ '1') {
        isError = false;
    }
    else {
        isError = true;
    }
    writeoutput("#isError#")
```