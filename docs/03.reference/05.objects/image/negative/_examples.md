```luceescript+trycf
	img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	cfimage(action="writeToBrowser",source=img);
	img.Negative();
	cfimage(action="writeToBrowser",source=img);
```
