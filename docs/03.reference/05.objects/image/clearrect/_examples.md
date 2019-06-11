```luceescript+trycf
	mgRect = imageRead("https://pbs.twimg.com/profile_images/1037639083135250433/fREb9ZhM_400x400.jpg");
	imgRect.clearrect(250,150,70,80);
	cfimage (action="writeToBrowser" source=imgRect);
```