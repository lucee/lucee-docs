
```luceescript+trycf
	imgObj = imageNew("",200,200,"rgb","149c82");
	imgObj.translate(40,40);
	imgObj.drawRect(50,50,70,50,"yes");
	cfimage(action="writeToBrowser", source=imgObj);
	imgObj.translate(40,40);
	cfimage(action="writeToBrowser", source=imgObj);
```