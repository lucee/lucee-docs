component {
    // CONSTRUCTOR
	public any function init() {
		request.logger = logger;
        if (not request.keyExists("logs"))
		    request.logs = [];
		request.loggerStart = getTickCount();
		return this;
	}

	public void function logger(string text, string type="INFO") {
		request.logs.append({
			text: arguments.text,
			type: arguments.type,
			timeMs: getTickCount() - request.loggerStart
		});
		cflog (text=arguments.text, type=arguments.type);
	};

    public void function showLogs(){
		if (request.logs.len() eq 0)
			return;
		writeOutput("<ol>");
		for (var log in request.logs)
			writeOutput("<li>#numberformat(log.timeMs)#ms <b>#log.type#</b> #log.text# </li>");
		writeOutput("</ol>");
	}
}
