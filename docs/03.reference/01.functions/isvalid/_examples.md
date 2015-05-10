```lucee
<cfset anArray = []>
<cfset boolean = true>
<cfset email = "test@test.com">
<cfset guid = createGUID()>
<cfset integer = 15>
<cfset string = "Hello World">
<cfset url = "http://www.test.com">
<cfset uuid = createUUID()>

<cfoutput>
	Array: #isValid('array', anArray)#<br>
	Boolean: #isValid('boolean', boolean)#<br>
	Email: #isValid('email', email)#<br>
	GUID: #isValid("guid", guid)#<br>
	Integer: #isValid("integer", integer)#<br>
	String: #isValid("string", string)#<br>
	URL: #isValid("url", url)#<br>
	UUID: #isValid("uuid", uuid)#
</cfoutput>
```