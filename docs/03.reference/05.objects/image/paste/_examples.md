
```luceescript+trycf
	firstImage = imageNew("",200,200,"rgb","red");
	secondImage = imageNew("",200,200,"rgb","yellow");
	firstImage.paste(secondImage,75,39);
	thirdimage = imageNew("",50,50,"rgb","blue");
	firstImage.paste(thirdimage,20,39);
	cfimage(action="writeToBrowser", source=firstImage);
```