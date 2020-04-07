```luceescript+trycf
    yell = function (name){
     echo(name);
     dump(var=getFunctionCalledName(), label="Function was called as");
    };
    
    yell("yell");
    
    say = yell; // copy function
    say("say from ");
    
    yell = say; // copy function again
    yell("yell from say");
```
