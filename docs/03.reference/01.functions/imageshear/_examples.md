```luceescript+trycf
myImg = imageNew("",100,50,"rgb","B33771");
imageShear(myImg,4,"vertical");
cfimage(action="writeToBrowser", source=myImg);
```
