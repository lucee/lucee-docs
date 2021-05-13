```luceescript+trycf
	img = imageRead("https://dev.lucee.org/uploads/default/original/2X/1/140e7bb0f8069e4f7f073b6d01f55c496bbd42e3.png");
	img.blur(10);
	cfimage (action="writeToBrowser" source=img);
```
