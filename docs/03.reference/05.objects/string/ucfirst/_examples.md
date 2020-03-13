```luceescript+trycf
	string = "submitting bugs and FEATURE requests via our online system";
	writedump(string.UcFirst());
	writedump(string.UcFirst( false, true));
	string = "SUBMITTING BUGS AND FEATURE REQUESTS VIA OUR ONLINE SYSTEM";
	writedump(string.UcFirst( true, true));
```