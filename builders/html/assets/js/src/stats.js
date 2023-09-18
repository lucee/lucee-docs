$(function(){
    setTimeout(function(){
        if (!window[(String.fromCharCode(103) + String.fromCharCode(96+1))]){
            $(".header .nav-list.pull-right").prepend(
                $("<li/>")
                    .attr("title", "Please consider unblocking G" + "oogle An"+ "alytics, we only use the stats to improve the docs for people like you")
                    .append($("<a/>").attr("href","/docs.html")
                        .append($("<i/>").addClass("fa fa-fw fa-exclamation-triangle").css("color", "#F1A797"))
                    )
            );
        }
    }, 750);
    // track outbound links
    $("a").click(function(){
        let href = $(this).attr("href");

        // ignore if no href or no length
        if(!href || !href.length) return;

        try {
            // ignore if same hostname
            if(window.location.hostname == new URL(href).hostname) return;
        } catch(e){
            // ignore invalid url
            return;
        }

        // only track outgoing links
        try {
            gtag('event', 'click', {
                'event_category': 'outbound',
                'event_label': href,
                'transport_type': 'beacon'
            });
        } catch(e){}
    });
});

window.onerror = function(message, url, line, col, err) {
    try {
        var error = [message, [url,line,col].join(":"), document.location.toString()];
        if (err.stack)
            error.push(err.stack.toString().substr(0, 400));
        gtag('event', 'exception', {
            'description': error.join("," + String.fromCharCode(13) ),
            'fatal': true
        });
    } catch (e){
        // ignore
    }
}