```luceescript+trycf
testCondition = true;
cnt = 0;
while(testCondition) {
    cnt = cnt + 1;
    if (cnt EQ 5) {
        testCondition = false;
    }
}
echo(cnt);
```

```luceescript+trycf
// breaking out using a label
x = 0;
WhileLabel: while (x < 10){
    writeOutput("x is #x#<br>");
    switch (x){
        case 1:
            break;
        case 3:
            break WhileLabel;
    }
    x++;
    writeOutput("end of loop<br>");
}
writeOutput("After loop, x is #x#<br>");
```