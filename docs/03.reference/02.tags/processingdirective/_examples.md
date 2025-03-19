### Simple Example

```lucee+trycf
<cfprocessingdirective suppresswhitespace="true" executionlog="true" pageencoding="UTF-8" preservecase="false">
    <cfset myStruct = {}>
    <cfset myStruct.dotNotation = "Hello World">
    <cfset myStruct["bracketNotation"] = " utf-8 Encoding">
<cfdump var="#myStruct#" label="preservecase"/>
    <cfoutput>
        Dot Notation :   #myStruct.DOTNOTATION#<br>
        Bracket Notation : #myStruct["bracketNotation"]#
    </cfoutput>
</cfprocessingdirective>
```
