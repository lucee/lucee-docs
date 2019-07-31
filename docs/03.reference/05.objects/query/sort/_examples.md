
```luceescript+trycf
news = queryNew("id,items",
    "integer,varchar",
    [ {"id":1,"items":"chocolate"}, {"id":2,"items":"juice"}, {"id":3,"items":"vegitable"} ]);
//sort it
news.sort("items","desc");
//dump it
writeDump(news);
news.sort("items","asc");
writeDump(news);
```