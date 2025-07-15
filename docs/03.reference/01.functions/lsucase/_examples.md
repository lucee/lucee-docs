```lucee+trycf
<cfset text = "istanbul ısparta">
<cfoutput>
  Turkish upper case: #LSUCase(text, "tr-TR")#<br>
  Normal upper case: #UCase(text)#<br>
</cfoutput>
```