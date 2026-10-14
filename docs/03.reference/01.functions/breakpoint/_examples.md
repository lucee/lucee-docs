```luceescript
// Simple breakpoint — like JavaScript's "debugger;" statement
// Suspends execution when a DAP debugger is attached
breakpoint();

// Labelled breakpoint — the label shows in the debugger UI,
// handy when you have multiple breakpoints in the same file
breakpoint( label="before query" );

// Conditional breakpoint — only suspends when the condition is true
// Great for breaking inside loops on a specific iteration
for ( i = 1; i <= 1000; i++ ) {
	breakpoint( condition=( i == 42 ) );
	processItem( items[ i ] );
}

// breakpoint() returns true if it actually suspended, false if skipped
// Use this to add debug logging only when actively debugging
if ( breakpoint( label="order check" ) ) {
	systemOutput( "Debug: order #order.id# total=#order.total#" );
}

// Safe to leave in production code — without the debugger extension
// installed and active, breakpoint() simply returns false with zero overhead

// Combine with isDebuggerEnabled() to skip expensive debug-only logic
if ( isDebuggerEnabled() ) {
	debugData = buildExpensiveDebugSummary( request );
	breakpoint( label="inspect debugData" );
}
```
