```lucee+trycf

<cfdump var="#sessionExists()#" label="Before declaring session">

<cfset session.name = "lucee" />

<cfdump var="#sessionExists()#" label="After declaring session">

```