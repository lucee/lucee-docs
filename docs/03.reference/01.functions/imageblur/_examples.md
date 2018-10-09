```luceescript+trycf
img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
imageBlur(img,10);
cfimage(action="writeToBrowser", source=img);
```