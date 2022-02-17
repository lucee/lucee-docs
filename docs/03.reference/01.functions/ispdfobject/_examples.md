```lucee
<cfdocument name="test" format="pdf">
    <h1>Welcome to Lucee</h1>
</cfdocument>
<cfif IsPDFObject(test)> 
    This is PDF
<cfelse> 
    This is not a PDF
</cfif>
```