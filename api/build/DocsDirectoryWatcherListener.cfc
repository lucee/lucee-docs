component {
	public void function onAdd(required any fileDetails){
        cflog(text="file changed #serializeJson(arguments.fileDetails)#");
    }

    public void function onDelete(required any fileDetails){
        cflog(text="file deleted #serializeJson(arguments.fileDetails)#");
    }

    public any function onMissingMethod(required string missingMethod ) {
  		cflog(text="missing method #missingMethod#");
    }
}

