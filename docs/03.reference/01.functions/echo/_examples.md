```luceescript+trycf
stru={};
stru.name="Susi";
echo(stru.name);
echo("<br>I love lucee");
```
### Nice trick with echo and cfcatch

```luceescript+trycf
try {
    throw "demo echo trick";
} catch (e){
    echo(e); // outputs the error nicely using the error template
}
```