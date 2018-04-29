```luceescript+trycf
dump(getLocale());
setLocale("english (australian)");
dump(getLocale());
dump(Server.Coldfusion.SupportedLocales.listToArray().sort("text"));
```