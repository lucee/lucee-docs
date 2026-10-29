### encodeFor

With the attribute `encodeFor` every expression in the body of the tag is encoded for the given target, the same as wrapping it in the matching `encodeFor` function.
An expression that is already a call to an `encodeFor` function (for example `#encodeForHTML( value )#`) is not encoded a second time.

To exclude an expression from the encoding, for example a value that is already encoded or intentionally contains markup, wrap it with [[function-preserveencoding]]:

```lucee+trycf
<cfset name = "<b>Susi</b>">
<cfset signature = "<i>The Lucee Team</i>">
<cfoutput encodeFor="html">
	#name#<br>
	#preserveEncoding( signature )#
</cfoutput>
```
