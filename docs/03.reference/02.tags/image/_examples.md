### Simple Example
```lucee+trycf
<cfset newImg = imageNew("",200,200,"rgb","blue")>
<cfimage action="write" source="#newImg#" name="writeimg" destination="pathname" overwrite="true">
```