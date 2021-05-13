```luceescript+trycf
img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
imageDrawArc(img,50,50,100,100,90,180,"yes");
cfimage(action="writeToBrowser", source=img);
```
