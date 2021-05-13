```luceescript+trycf
firstImage = imageNew("",200,200,"rgb","red");
secondImage = imageNew("",200,200,"rgb","yellow");
imagepaste(firstImage,secondImage,75,75);
//Member function
//firstImage.paste(secondImage,10,10);
cfimage(action="writeToBrowser", source=firstImage);
```
