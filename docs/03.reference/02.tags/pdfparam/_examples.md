

```lucee
<cfset x = 1>

<cfdocument format="pdf" pagetype="A4" name="myVar">

<cfdocumentsection>

Hi there

</cfdocumentsection>

</cfdocument>



<cfpdf action="merge" destination="D:/myPDF.pdf" overwrite="yes">

<cfpdfparam source="myVar" /> 

</cfpdf>


```