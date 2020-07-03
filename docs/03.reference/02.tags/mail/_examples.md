### Simple example for cfmail

```
<cftry>
    <cfmail from="aaa@bb.com" to="test01mail.com" subject="sample" cc="test02@gmail.com">Test Email
</cfmail>
  <cfcatch>
    <cfdump var="#cfcatch.message#">
  </cfcatch>
</cftry>
```