### Exclude a value from the encodeFor attribute of cfoutput

```lucee+trycf
<cfset name = "<b>Susi</b> & Urs">
<cfset signature = "<i>The Lucee Team</i>">
<cfoutput encodeFor="html">
	#name#<br>
	#preserveEncoding( signature )#
</cfoutput>
```

The value of `name` is encoded, the value of `signature` is written as it is.

### Use outside of cfoutput

```luceescript+trycf
markup = "<b>Susi</b>";
writeOutput( preserveEncoding( markup ) );
```
