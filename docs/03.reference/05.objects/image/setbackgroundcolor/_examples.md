
```luceescript+trycf
	img=imageread("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	img.SetBackGroundColor("red");
	img.ClearRect(20,20,70,50);
	cfimage(action="writeToBrowser",source=img);
```