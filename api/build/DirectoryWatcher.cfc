component {
	public void function onAdd(required string fileDetails){
        cflog(text="file changed #serializeJson(arguments.fileDetails)#");
    }
    public any function onMissingMethod() {
		cflog(text="missing method #serializeJSON(arguments)#");
	}
}

