
```luceescript+trycf
	img=imageNew("",200,200,"RGB","00fcfc");
	img.DrawRect(45,50,75,125);
	img.DrawRect(70,50,75,10);
	cfimage(action="writeToBrowser",source=img);
```