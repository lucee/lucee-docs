```luceescript+trycf
img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
ImageClearRect(img,180,50,20,30);
cfimage(action="writeToBrowser", source=img);
```