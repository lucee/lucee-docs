```lucee
// AI service name, e.g., "test_ai"
aiSession = LuceeCreateAISession("test_ai");
result = LuceeInquiryAISession(aiSession, "What is Lucee?");
writeDump(result);
```

### Cancel an inquiry from the listener *(since 9.0)*

Returning `false` from the listener stops the inquiry. The function returns what was received up to that point.

```lucee
aiSession = createAISession( name: "test_ai" );

// stop after the first 200 characters
received = "";
answer = inquiryAISession( aiSession, "Tell me a long story", function( chunk ) {
	received &= chunk;
	if ( len( received ) >= 200 ) return false; // cancels the inquiry
} );

// answer contains the text received so far
writeOutput( answer );
```

The listener can also be a function of a component, created with `new`:

```lucee
// StopAfter.cfc
component {

	variables.max = 0;
	variables.count = 0;

	function init( required numeric max ) {
		variables.max = arguments.max;
		return this;
	}

	function listen( chunk ) {
		variables.count++;
		// false cancels the inquiry
		return variables.count < variables.max;
	}

}
```

```lucee
aiSession = createAISession( name: "test_ai" );

stopper = new StopAfter( 5 );
answer = inquiryAISession( aiSession, "Count from 1 to 100", stopper.listen );
writeOutput( answer ); // only what arrived in the first 5 chunks
```

Or a static function of a component, using `import` and `::`:

```lucee
// Listeners.cfc
component {

	static function stopOnKeyword( chunk ) {
		return !findNoCase( "stop", chunk );
	}

}
```

```lucee
import Listeners;

aiSession = createAISession( name: "test_ai" );
answer = inquiryAISession( aiSession, "Count from 1 to 100", Listeners::stopOnKeyword );
```
