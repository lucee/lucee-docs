$(function(){
    setTimeout(function(){
        if (!window[String.fromCharCode(103) + String.fromCharCode(116) + String.fromCharCode(96+1) + String.fromCharCode(102+1)]){
            $(".header .nav-list.pull-right").prepend(
                $("<li/>")
                    .attr("title", "Please consider unblocking G" + "oogle An"+ "alytics, we only use the stats to improve the docs for people like you")
                    .append($("<a/>").attr("href","/docs.html")
                        .append($("<i/>").addClass("fa fa-fw fa-exclamation-triangle").css("color", "#F1A797"))
                    )
            );
        }
    }, 1000);
});