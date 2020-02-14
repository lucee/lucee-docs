```luceescript+trycf
	img=imageNew("",300,300,"RGB","##bf4f36");
	style={size="40",style="BOLD"};
	img.DrawText("I love lucee",55,120,style);
	cfimage(action="writeToBrowser",source=img);
```