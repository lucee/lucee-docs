```luceescript+trycf
	img = imageNew("", 105, 100, "rgb", "yellow");
	writeDump(img.GetEXIFTag('width'));
	writeDump(img.GetEXIFTag('height'));
```