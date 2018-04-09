component {

    // CONSTRUCTOR
	public any function init() {
		if (not request.keyExists("logs")){
            // only init once!
            request.logger = logger;
            request.loggerComponent = this;
		    request.logs = [];
		    request.loggerStart = getTickCount();
            request.loggerFlushEnabled = false;
        }
		return this;
	}

	public void function logger(string text, string type="INFO") {
		request.logs.append({
			text: arguments.text,
			type: arguments.type,
			timeMs: getTickCount() - request.loggerStart
		});
		cflog (text=arguments.text, type=arguments.type);
        echo (text=arguments.text); // waves to travis ci
        if (request.loggerFlushEnabled){
            request.loggerComponent._renderLog( request.logs[request.logs.len()] );
            flush;
        }
	};

    public void function enableFlush(required boolean _flush){
        request.loggerFlushEnabled = arguments._flush;
        if (request.loggerFlushEnabled){
            writeOutput("<ol>");
            return;
        }
    }

    public void function renderLogs(){
        if (request.loggerFlushEnabled){
            // logs were output as they were generated;
            writeOutput("</ol>");
            return;
        }

		if (request.logs.len() eq 0)
			return;
		writeOutput("<ol>");
		for (var log in request.logs)
			_renderLog(log);
		writeOutput("</ol>");
	}

    public void function _renderLog(log){
        var style = "";
        switch (arguments.log.type){
            case "warn":
                style = "color: orangered;";
                break;
            case "error":
                style = "color: FireBrick ;";
                break;
            default:
                break;
        }
        if (style.len() gt 0)
            style = ' style="#style#" ';
		writeOutput("<li #style#>#numberformat(arguments.log.timeMs)#ms <b>#arguments.log.type#</b> #arguments.log.text# </li>");
	}
}
