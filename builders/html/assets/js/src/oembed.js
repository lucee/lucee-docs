setTimeout(
    function(){
        'use strict';
        $(function(){
            var oembedWhiteList = ["youtube.com","dev.lucee.org","luceeserver.atlassian.net","github.com"];
            var isWhiteListed = function (url){
                var whiteListed = false;
                for (var s in oembedWhiteList){
                    if (url.indexOf(oembedWhiteList[s]) > 0){
                        whiteListed = true;
                        break;
                    }
                }
                return whiteListed;
            };

            var oembedFallback = function (container, resourceURL){
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
                if (url && url.indexOf("http") === -1)
                    return;  // skip all  local content
                var whiteListed = isWhiteListed(String(url));
                whiteListed = (url == $(this).text());
                // only oembed raw urls and whiteListed sites
                if (whiteListed){
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

