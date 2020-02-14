
```luceescript+trycf
	img = imageNew("",152,152,"rgb","149c82");
	img.shearDrawingAxis(0.5,0.5);
	imagedrawRect(img,40,50,70,50,"yes");
	cfimage(action="writeToBrowser", source=img);
	img.shearDrawingAxis(0.5,0.5);
	imageDrawOval(img,60,50,50,100,"no");
	cfimage(action="writeToBrowser", source=img);
```