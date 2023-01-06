component {

    // CONSTRUCTOR
	public any function init(opts, force=false) {
        if (not request.keyExists("logs") || arguments.force){
            // only init once!
            request.logger = logger;
            request.loggerComponent = this;
		    request.logs = [];
		    request.loggerStart = getTickCount();
            request.loggerFlushEnabled = false;
            this.textOnly = (url.KeyExists("textlogs") and url.textlogs ); // nice for curl --trace http://localhost:4040/build_docs/all/
            this.console = false;
            if (isStruct(arguments.opts)){
                if (arguments.opts.keyExists("textOnly"))
                    this.textOnly = arguments.opts.textOnly;
                if (arguments.opts.keyExists("console"))
                    this.console = arguments.opts.console;
            }
        }
		return this;
	}

	public void function logger(string text, string type="INFO", string link="") {
		request.logs.append({
			text: arguments.text,
			type: arguments.type,
            link: arguments.link,
			timeMs: getTickCount() - request.loggerStart
		});
		cflog (text=arguments.text, type=arguments.type);
        if (request.loggerFlushEnabled){
            request.loggerComponent._renderLog( request.logs[request.logs.len()] );
            flush;
        }
	};

    public void function enableFlush(required boolean _flush){
        request.loggerFlushEnabled = arguments._flush;
        if (request.loggerFlushEnabled){
            if (!this.textOnly)
                writeOutput("<ol>");
            return;
        }
    }

    public void function renderLogs(){
        if (request.loggerFlushEnabled){
            // logs were output as they were generated;
            if (!this.textOnly)
                writeOutput("</ol>");
            return;
        }

		if (request.logs.len() eq 0)
			return;
        if (!this.textOnly)
		    writeOutput("<ol>");
		for (var log in request.logs)
			_renderLog(log);
        if (!this.textOnly)
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

        if (this.console)
            systemOutput("#numberformat(arguments.log.timeMs)#ms #arguments.log.type# #arguments.log.text#", true);
        if (this.textOnly) {
            writeOutput("#numberformat(arguments.log.timeMs)#ms #arguments.log.type# #arguments.log.text##chr(10)#");
        } else {
		    writeOutput("<li #style#>");
            if (arguments.log.link.len() gt 0)
                writeOutput('<a href="#arguments.log.link#">');
            writeOutput("#numberformat(arguments.log.timeMs)#ms <b>#arguments.log.type#</b> #arguments.log.text#");
            if (arguments.log.link.len() gt 0)
                writeOutput('</a>');
            writeOutput("</li>#chr(10)#");
        }
	}
}
