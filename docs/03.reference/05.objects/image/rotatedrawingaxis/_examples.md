```luceescript+trycf
	imgObj = imageNew("",152,152,"rgb","##bf4f36");
	imgObj.rotateDrawingAxis(75,71,71);
	imgObj.drawLines([0,38,76,114,152],[0,152,0,152,0],"no","no");
	cfimage(action="writeToBrowser", source=imgObj);
```