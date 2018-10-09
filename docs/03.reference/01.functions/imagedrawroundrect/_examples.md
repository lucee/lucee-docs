```luceescript+trycf
img=imageNew("",200,200,"RGB","b71540");
imageDrawRoundRect(img,45,50,75,125,25,25);
cfimage(action="writeToBrowser",source=img);
```