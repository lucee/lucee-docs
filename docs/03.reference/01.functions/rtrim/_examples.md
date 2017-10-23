<cfscript>
  // create variable with a string of text that has leading and trailing spaces
  foo = " Hello World!  ";
  // output variable
  writeDump("-" & foo & "-");
  // output variable without trailing spaces
  writeDump("-" & RTrim(foo) & "-");
</cfscript>
