```luceescript+trycf
img=imageRead("https://hostek.com/blog/wp-content/uploads/2015/11/magician_lucee_wide.jpg");
imageNegative(img);
imageresize(img, "20%","200");
cfimage(action="writeToBrowser",source=img);
```