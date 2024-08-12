```luceescript+trycf
	writeOutput( isSimpleValue("string") & "<br>" );
	writeOutput( isSimpleValue(123456) & "<br>" );
	writeOutput( isSimpleValue(getTimezone()) & "<br>" );
	writeOutput( isSimpleValue(now()) & "<br>" );
	writeOutput( isSimpleValue(javacast("char","A")) & "<br>" );
	writeOutput( isSimpleValue(nullValue()) & "<br>" );
	writeOutput( isSimpleValue([]) & "<br>" );
	writeOutput( isSimpleValue({}) & "<br>" );
	writeOutput( isSimpleValue(queryNew("test")) );
```