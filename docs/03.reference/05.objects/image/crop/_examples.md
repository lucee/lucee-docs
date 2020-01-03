```luceescript+trycf
	img=imageRead("https://dev.lucee.org/uploads/default/original/2X/1/140e7bb0f8069e4f7f073b6d01f55c496bbd42e3.png");
	img.Crop(50,40,100,100);
	cfimage(action="writeToBrowser", source=img);
```