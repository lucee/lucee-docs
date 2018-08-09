```luceescript+trycf
try{
	totalDiskSpace = getTotalSpace("c:");
	totalRAMSpace = getTotalSpace("c:");
	writeOutput('Total Hard Disk Space : ' & DecimalFormat(totalDiskSpace / (1024 * 1024 * 1024)));
	writeoutput('<br>');
	writeOutput('Total Application RAM Memory : ' & DecimalFormat(totalRAMSpace / (1024 * 1024)));
}
catch(any e){
	writeOutput(cfcatch.message);
	writeOutput(cfcatch.detail);
}
```