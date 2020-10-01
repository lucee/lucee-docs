```luceescript+trycf
wood_image = imageNew("",300,200,"rgb","brown");
filter = "wood";
wood_params = {
	  turbulence = 0,
	  stretch = 10,
	  angle = 25,
	  rings = 1,
	  fibres = 1,
	  scale = 100
}
ImageFilter(image = wood_image, filtername = filter, parameters = wood_params);	
ImageWriteToBrowser(wood_image);
```
