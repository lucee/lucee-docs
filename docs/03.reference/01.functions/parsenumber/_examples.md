<cfscript>
  number = "1000";

  echo(ParseNumber(number, "dec")); // 1000
  echo(ParseNumber(number, "bin")); // 8
  echo(ParseNumber(number, "oct")); // 512
  echo(ParseNumber(number, "hex")); // 4096
</cfscript>
