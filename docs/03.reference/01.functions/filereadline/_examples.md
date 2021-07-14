```luceescript
// Example reads lines of file one at a time into an array
filePath = "/path/to/file.txt"
openFile = fileopen( filePath, "read" );
lines = [];

// IMPORTANT: must close file, use try/catch/finally to do so
try {
    while( !fileIsEoF( openFile ) ) {
        arrayAppend( lines, fileReadLine( openFile ) );
    }
} catch( any e ) {
    rethrow;
} finally {
    fileClose( openFile );
}
```
