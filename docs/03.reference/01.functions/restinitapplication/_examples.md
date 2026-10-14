```luceescript
restInitApplication( dirPath="path_to_cfc_dir", serviceMapping="api", password="webAdminPassword" );
```

### Simple REST enabled CFC example

```luceescript
component restpath="/restExample" rest="true" {

	remote function getApplicationName() restpath="getApplicationName" httpmethod="GET,HEAD" {
		return "applicationName:" & getApplicationSettings().name;
	}

}
```