aNames = array("Marcus","Sarah","Josefine");

arrayEach(
    aNames,
    function(element){
        dump(var="#ucase(element)#",label="ucase element");
    }
);

//member function version
aNames.each(
    function(element){
        dump(var="#lcase(element)#",label="lcase element");
    }
);
