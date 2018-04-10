setTimeout(
    function(){
        $(function(){
            var oembedFallback = function (container, resourceURL){
                if (resourceURL.toLowerCase().indexOf("https://luceeserver.atlassian.net/browse/") !== 0)
                    return;
                $.ajax("http://open.iframe.ly/api/oembed?url=" + resourceURL + "&origin=lucee")
                    .done(function(oembedData) {
                        oembedData.code = $.fn.oembed.getGenericCode(resourceURL, oembedData);
                        $.fn.oembed.insertCode(container, "replace", oembedData);
                    })
                    .fail(function(err) {
                        console.error(err);
                    }
                );
            };
            $(".content-inner .body a").each(function(){
                if ($(this).hasClass("edit-link") || $(this).hasClass("local-edit-link") || $(this).hasClass("no-oembed"))
                    return;
                var url = $(this).attr("href");
                if (url && url.indexOf("http") === 0 ){ // avoid local content!
                    $(this).oembed(url, {
                        fallback : false,
                        onProviderNotFound: oembedFallback
                    });
                }
            });
        });
    },
    200
);

