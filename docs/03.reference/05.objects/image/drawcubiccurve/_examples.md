```luceescript+trycf
	img=imageNew("",100,100,"RGB","3c6382");
	img.DrawCubicCurve(0,45,45,75,40,75,0,100);
	cfimage(action="writeToBrowser",source=img);
```