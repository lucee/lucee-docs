<!--
{
  "title": "Scheduled Tasks - efficiently updating in a single operation",
  "id": "cfschedule-bulk",
  "description": "How to update scheduled tasks in a single operation",
  "since": "6.2.3.16",
  "keywords": [
    "scheduled tasks",
    "config"
  ],
  "related": [
    "tag-schedule",
    "function-configimport",
    "deploying-lucee-server-apps"
  ],
  "categories": [
    "server"
  ]
}
-->

## Efficiently and reliably updating scheduled tasks in a single operation

Using the [[tag-schedule]] to update all tasks on application start has always been a bit slow, as each update reloads the config which is slow when updating many tasks.

With Lucee 6, all the tasks are stored in `.CFConfig.json`, before that they were stored in an xml file.

Note, this approach only works reliably since 6.2.3.16, as the config import / merging needed to be improved to handle array configs (like scheduled tasks) correctly.

[LDEV-5758](https://luceeserver.atlassian.net/browse/LDEV-5758)

### Updating tasks in a single transaction

An alternative and far more efficient approach is to 

1. Extract the **scheduledTasks** from `.CFConfig.json`, 
2. Check and modify the array of tasks if needed (i.e. track changes)
3. Import the modified tasks (if changed) all at once using [[function-configimport]] or by dropping a config snipper in the `/deploy` folder.

```cfml
var cfconfig = deSerializeJson( fileRead( expandPath( '{lucee-config}.CFConfig.json' ) ) );
```

The scheduled tasks array looks like this

```json
  "scheduledTasks": [
    {
      "name": "test",
      "startDate": "{d '2025-06-18'}",
      "startTime": "{t '00:00:18'}",
      "url": "http://127.0.0.1:8888/task.cfm?scheduled=true",
      "port": 9888,
      "interval": "3600",
      "timeout": 50000,
      "resolveUrl": false,
      "publish": false,
      "hidden": false,
      "readonly": false,
      "autoDelete": false,
      "unique": false,
      "paused": false
    }
  ]
```

Extract that object, it may be empty, so use an elvis.

```cfml
var tasks = cfconfig.scheduledTasks ? [];
```

### Update the tasks

Loop over the array and modify it as needed.

### Tip: avoid updates when there is no change

It's good to avoid updating the config if there is no change, but not so important when using this efficient approach.

An easy way is to simply compare the source tasks array with the updated tasks array.

```cfml
var changed = compare( serializeJson( var=srcTasks, compact=false ), serializeJson( var=updateTasks, compact=false ) );
```

### Importing via configImport()

[[function-configimport]]

```cfml
if ( changed ) {
  configImport( path=tasks, type="server", password="your-admin-password" );
  systemOutput("updated scheduled tasks", true );
}
```

### Importing via /deploy

The alternative approach is then serialize that object to json and drop into the `/deploy` folder.

[[deploying-lucee-server-apps]]

```cfml
if ( changed ){
  var tasksJson = serializeJson( tasks );  
  var deployConfig = SerializeJson( expandPath('{lucee-config}deploy/.CFConfig.json') );
  systemOutput("updating scheduled tasks via /deploy", true );
  fileWrite( deployConfig, tasksJson );
}
```

The Lucee background controller process will then import that configuration within 60s and update the scheduled tasks.