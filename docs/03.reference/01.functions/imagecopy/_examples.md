```luceescript+trycf
	newImg = imageNew("",200,200,"rgb","red");
	copiedImg = newImg.copy(50,50,50,50);
	cfimage(action="writeToBrowser", source=copiedImg);
```
