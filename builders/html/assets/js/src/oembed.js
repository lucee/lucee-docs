setTimeout(
    function(){
        $(function(){           
            $(".content-inner .body a").each(function(){
                var url = $(this).attr("href");
                if (url.indexOf("http") === 0)
                    $(this).oembed();
            });       
        });
    }, 
    500
);    
