```luceescript+trycf
img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
imageCrop(img,50,10,100,100);
cfimage(action="writeToBrowser", source=img);
```