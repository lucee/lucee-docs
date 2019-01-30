```luceescript+trycf
img=imageNew("",200,200,"RGB","e55039");
imageDrawOval(img,60,50,50,100,"no");
cfimage(action="writeToBrowser",source=img);
```