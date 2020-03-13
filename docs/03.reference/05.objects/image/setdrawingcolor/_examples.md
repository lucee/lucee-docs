
```luceescript+trycf
	img=imageread("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	img.SetDrawingColor("black");
	ImageDrawLine(img,0,0,300,200)
	cfimage(action="writeToBrowser", source=img);
```