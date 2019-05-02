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