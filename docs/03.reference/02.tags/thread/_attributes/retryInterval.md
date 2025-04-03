When `type="task"`, this attribute defines an execution plan for automatic retry attempts when thread execution fails. You can specify either a single retry rule or multiple rules as an array.
 				
A single rule specifies the interval between retries and the number of retry attempts with a structure containing `interval` and `tries` keys. The `interval` is a timespan value defining the waiting period between retries, and `tries` is the number of retry attempts.

Example:

```luceescript
#{interval:createTimeSpan(0,0,0,5),tries:5}#
```

Multiple rules can be defined as an array of structures, each containing `interval` and `tries` keys. This allows for implementing progressive retry strategies with different intervals for different phases of the retry process.

Example:

```luceescript
#[{interval:createTimeSpan(0,0,0,5),tries:5},{interval:createTimeSpan(0,0,0,10),tries:5}]#
```