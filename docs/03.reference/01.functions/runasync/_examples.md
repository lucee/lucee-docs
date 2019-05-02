```luceescript+trycf
	future = runAsync(function(){
		return 10;
	}).then( function(input){
		return input + 20;
	});
	dump(future);
	result = future.get(10); // 10 is timeout(in ms)
	writeOutput(result); // output is 30
```