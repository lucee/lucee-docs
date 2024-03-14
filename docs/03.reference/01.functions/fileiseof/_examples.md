```luceescript
filePath = "/path/to/file.txt"
openFile = fileopen(filePath, "read");
lines = [];
// IMPORTANT: must close file, use try/catch/finally to do so
try {
	// fileIsEOF(openFile) == false until we've read in the last line.
	while( !fileIsEoF(openFile) ) {
		arrayAppend(lines, fileReadLine( openFile ));
	}
} catch(any e) {
	rethrow;
} finally {
	fileClose(openFile);
}
```