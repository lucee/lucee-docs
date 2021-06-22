```luceescript+trycf
    	var n = 1234.56;
	writeOutput( getlocale() );
	dump( dateTimeFormat( now() ) );
	dump( LSdateTimeFormat( now() ) );
	dump( numberFormat( n ) );
	dump( LSnumberFormat( n ));

	writeOutput(' To ');
	setLocale( 'french(switzerland)' );

	writeOutput( getlocale() );
	dump( dateTimeFormat( now() ) );
	dump( LSdateTimeFormat( now() ) );
    	dump( numberFormat( n ) );
	dump( LSnumberFormat( n ) );

	writeOutput(' To ');
	setLocale( 'German' );

	writeOutput( getlocale() );
	dump( dateTimeFormat( now() ) );
	dump( LSdateTimeFormat( now() ) );
    	dump( numberFormat( n ) );
	dump( LSnumberFormat( n ) );
```
