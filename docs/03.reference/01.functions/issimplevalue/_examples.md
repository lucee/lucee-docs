```luceescript+trycf
	writeOutput( "string " & isSimpleValue("string") & "<br>" );
	writeOutput( "123456 " & isSimpleValue(123456) & "<br>" );
	writeOutput( "getTimezone() " & isSimpleValue(getTimezone()) & "<br>" );
	writeOutput( "now() " & isSimpleValue(now()) & "<br>" );
	writeOutput( 'javacast("char","A") ' & isSimpleValue(javacast("char","A")) & "<br>" );
	writeOutput( "nullValue() " & isSimpleValue(nullValue()) & "<br>" );
	writeOutput( "[] " & isSimpleValue([]) & "<br>" );
	writeOutput( "{} " & isSimpleValue({}) & "<br>" );
	writeOutput( 'queryNew("test") ' & isSimpleValue(queryNew("test")) & "<br>");
	writeOutput( " " & isSimpleValue("") );
```