```lucee+trycf
<cfoutput>
  #formatBaseN( 15, 2  )# <!--- 1111 (binary) --->
  #formatBaseN( 15, 16 )# <!--- f (hexadecimal) --->
  #formatBaseN( 15, 8  )# <!--- 17 (octal) --->
</cfoutput>
```

### Max value limitation

Please note that the value to convert is limited to a maximum equal to `java.lang.Integer.MAX_VALUE`. Values greater than this will produce unexpected results. i.e.

```cfm
<cfset max = CreateObject( "java", "java.lang.Integer" ).MAX_VALUE >
<cfoutput>
  #formatBaseN( max  , 16 )# <!---  7fffffff (correct) --->
  #formatBaseN( max+1, 16 )# <!---  7fffffff (incorrect) --->
</cfoutput>
```