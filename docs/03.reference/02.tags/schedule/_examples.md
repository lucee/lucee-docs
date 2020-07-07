### Syntax for cfschedule

```luceescript
<cfschedule
    action="update"
    task="test"
    operation="HTTPRequest"
    startDate="6/02/2019"
    startTime="12:00 AM"
    url="https://www.test.com/schedule_task/test.cfm"
    interval="daily"
    publish = "Yes"
    file = "myfile.log"
    path = "#expandPath('./')#" />
```

### Action List

```luceescript
<cfschedule action="list" returnvariable="res">
```

### Action Run

```luceescript
<cfschedule action="run" task="taskOne">
```

### Action Pause

```luceescript
<cfschedule action="pause" task="taskOne">
```

### Action Resume

```luceescript
<cfschedule action="resume" task="taskOne">
```

### Action Delete

```luceescript
<cfschedule action="delete" task="taskOne">
```