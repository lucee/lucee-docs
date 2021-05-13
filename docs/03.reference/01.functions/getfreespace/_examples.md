```luceescript+trycf
try{
	freeDiskSpace = getFreeSpace("c:");
	freeRAMSpace = getFreeSpace("c:");
	writeOutput('Free Hard Disk Space : ' & DecimalFormat(freeDiskSpace / (1024 * 1024 * 1024)));
	writeoutput('<br>');
	writeOutput('Free Application RAM Memory : ' & DecimalFormat(freeRAMSpace / (1024 * 1024)));
}
catch(any e){
	writeOutput(cfcatch.message);
	writeOutput(cfcatch.detail);
}
```
