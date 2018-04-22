When type task, this attribute define an execution plan for additional tries of execution. You can define a single rule or multiple rules as an array.

Example single rule:

```luceescript
#{interval:createTimeSpan(0,0,0,5),tries:5}#
```

In this case Lucee replays the thread for a maximum of 5 times, when the execution fails, Lucee waits for 5 seconds before doing the next try.

Example multiple rules:

```luceescript
#[{interval:createTimeSpan(0,0,0,5),tries:5},{interval:createTimeSpan(0,0,0,10),tries:5}]#
```

In this case Lucee replays the thread for a maximum of 10 times, when the execution fails, 5 times every 5 seconds, then 5 times every 10 seconds.
