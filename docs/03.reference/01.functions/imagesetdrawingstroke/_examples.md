
```luceescript+trycf
	lineAttributes = { width="2", endcaps="round", dashArray=[8,4]};
	imgObj = imageNew("",152,152,"rgb","149c82");
  	imgObj.setDrawingStroke(lineAttributes);
  	imgObj.drawLines([0,38,76,114,152],[0,152,0,152,0],"no","no");
  	cfimage(action="writeToBrowser", source=imgObj);
 ```