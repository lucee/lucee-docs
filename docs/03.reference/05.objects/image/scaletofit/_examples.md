
```luceescript+trycf
	myImg = imageNew("",400,400,"rgb","70a1ff");
	myImg.ScaleToFit(80,"","highPerformance");
	cfimage(action="writeToBrowser", source=myImg);
```
