```luceescript+trycf
img=imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
imageDrawBeveledRect(img,50,50,50,100,"yes");
cfimage(action="writeToBrowser", source=img);
writeOutput("<br>");
imageDrawBeveledRect(img,50,50,50,100,"yes","yes");//FIlled rect
cfimage(action="writeToBrowser", source=img);
```