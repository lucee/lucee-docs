```lucee

<cffunction name="updateAddress" access="remote" output="false">
  <cfargument name="addressId" type="number" required="yes">
  <cfargument name="newAddress" type="string" required="yes">

  <cftransaction isolation="read_committed">
   	 <cfquery name="changeAddress" datasource="#application.config.DSN#">
  		update address
		set login_address = <cfqueryparam value="#arguments.newAddress#" cfsqltype="VARCHAR">
		where	id = <cfqueryparam value="#arguments.addressId#" cfsqltype="INTEGER">
	    </cfquery>
  </cftransaction>
</cffunction>
```
