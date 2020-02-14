```luceescript+trycf
	imgOne=imageNew("",100,100,"RGB","red");
	imgTwo=imageNew("",40,30,"RGB","##ffffff");
	imgOne.drawImage(imgTwo,30,10);
	cfimage(action="writeToBrowser",source=imgOne);
```