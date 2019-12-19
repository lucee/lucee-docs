
```luceescript+trycf
	img = imageNew("",100,80,"rgb","B33771");
	img.Shear(4,"vertical");
	cfimage(action="writeToBrowser", source=img);
	img.Shear(4);
	cfimage(action="writeToBrowser", source=img);
```