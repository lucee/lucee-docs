```luceescript+trycf
	v = ListToArray(server.lucee.version,".");
	if ((v[1] >= 6) ||
			(v[1] >= 5 && v[2] >= 3 && v[3] >= 6) ||
			(v[1] == 5 && v[2] >= 4)){
		InspectTemplates();
	} else {
		echo (server.lucee.version);
		echo (" doesn't support InspectTemplates(), only 5.3.6+");
	}
```