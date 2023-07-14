```lucee+trycf
<cfset session.name = "lucee" />
<cfdump var="#session#" label="Before sessionRotate">

<cfset sessionRotate()/>

<cfset session.name = "Susi" />
<cfdump var="#session#" label="After sessionRotate">

```