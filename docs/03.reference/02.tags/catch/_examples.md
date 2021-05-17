### Simple example with cfcatch

```lucee+trycf
<cftry>
  <cfset a = 3/0>
  <cfdump var="#c#" />
  <cfcatch>
    <cfdump var="#cfcatch#">
  </cfcatch>
</cftry>
```
### Nice trick with echo and cfcatch

```luceescript+trycf
try {
    throw "demo echo trick";
} catch (e){
    echo(e); // outputs the error nicely using the error template
}
```