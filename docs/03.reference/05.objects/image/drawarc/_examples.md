```luceescript+trycf
	img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
	img.DrawArc(70,50,70,100,90,180,"yes");
	cfimage(action="writeToBrowser", source=img);
```