```luceescript+trycf
img=imageNew("",200,200,"RGB","4a69bd");
imageDrawLines(img,[10,50,100,50],[100,10,100,152],"yes","no");
cfimage(action="writeToBrowser",source=img);
```