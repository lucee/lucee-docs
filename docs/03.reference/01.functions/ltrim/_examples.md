<cfscript>
  // create variable with a string of text that has leading and trailing spaces
  foo = " Hello World!  ";
  // output variable
  writeDump("-" & foo & "-");
  // output variable without leading spaces
  writeDump("-" & LTrim(foo) & "-");
</cfscript>
