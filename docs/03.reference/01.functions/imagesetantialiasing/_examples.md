```luceescript+trycf
	imgObj = imageNew("",200,200,"rgb","149c82");
 	imgObj.setAntialiasing('off');
 	cfimage(action="writeToBrowser", source=imgObj);
```