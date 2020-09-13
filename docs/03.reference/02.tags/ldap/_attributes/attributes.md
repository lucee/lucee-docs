Required if action = "Query", "Add", "ModifyDN", or "Modify"
For queries: comma-delimited list of attributes to return. For
queries, to get all attributes, specify "*".

If action = "add" or "modify", you can specify a list of update
columns. Separate attributes with a semicolon.

If action = "ModifyDN", CFML passes attributes to the
LDAP server without syntax checking.