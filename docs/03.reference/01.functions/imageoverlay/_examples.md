```luceescript+trycf
	myImg = imageNew("",152,152,"rgb","40739e");
	topImg = imageNew("",80,80,"rgb","fbc531");
	myImg.overlay(topImg);
	cfimage(action="writeToBrowser", source=myImg);
```
