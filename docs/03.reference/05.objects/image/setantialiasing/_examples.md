```luceescript+trycf
	imgObj = imageNew("",150,150,"rgb","149c82");
	imgObj.setAntialiasing('off');
	cfimage(action="writeToBrowser", source=imgObj);
```