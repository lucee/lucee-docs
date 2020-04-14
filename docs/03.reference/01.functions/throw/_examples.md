```luceescript+trycf
    // thrown as a statement example
	try {
		throw "thrown";
	} catch (e){
		dump(var=cfcatch, label="single argument keyword");
	}
    
    /* this won't work as expected, because thrown expects only a single 
        argument function in cfscript, only message will be populated
     see https://luceeserver.atlassian.net/browse/LDEV-2832
    */
	try {
		throw message="thrown"
			detail="deets"
			errorCode="403"
			type="Test";
	} catch (e){
		dump(var=cfcatch, label="additional arguments are ignored");
	}
	
	// use this syntax instead
	try {
		throw (message="thrown",
			detail="deets",
			errorCode="403",
			type="Test");
	} catch (e){
		dump(var=cfcatch, label="script throw with arguments");
	}
```