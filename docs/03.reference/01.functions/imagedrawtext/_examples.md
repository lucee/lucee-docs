```luceescript+trycf
img=imageNew("",300,300,"RGB","45aaf2");
style={size="26",style="Italic"};
ImageDrawText(img,"I love lucee",75,120,style);
cfimage(action="writeToBrowser",source=img);
```
