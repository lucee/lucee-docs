```luceescript+trycf
// timeout after 2sec
cftimeout( timespan=createTimeSpan(0, 0, 0, 2)){
	cfloop(times = "10"){
		cftimer(label = "Nap time" type = "outline") {
			echo("This case take run based upon time.");
			cfflush();
			sleep(400);
		}
	}
};
```