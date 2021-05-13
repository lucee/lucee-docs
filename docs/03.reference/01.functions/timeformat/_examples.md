```luceescript+trycf

//simple Function
writeDump(TimeFormat(CreateDateTime( 2009, 6, 29, 24, 0, 0),"h TT"));//12 AM

//Member function
dt=CreateDateTime(2018,07,04,13,12,12);
writeDump(dt.TimeFormat("hh:mm:ss"));//01:12:12

```
