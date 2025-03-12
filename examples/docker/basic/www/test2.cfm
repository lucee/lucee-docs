
<cfscript>
function addListener() {
    var pc=getPageContext();
    var c=pc.getConfig();
    var eng=c.getFactory().getEngine();
    var sc=pc.getServletContext();
    var listener=createObject("java","lucee.runtime.engine.listener.CFMLServletContextListener").init(eng);
    sc.addListener(listener);
}
addListener();


</cfscript>
done