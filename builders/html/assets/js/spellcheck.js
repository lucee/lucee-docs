$(function(){
    'use strict';
    $(".whitelist").on("click", function(ev){
        var $el = $(ev.target);
        var $li = $el.closest("li");
        var $a = $li.find("a.missing");
        var word = $a.text();

        $.ajax({
            url: "/build_docs/spellcheck/",
            type: "POST",
            data: {
                whitelist: word
            }
        }).done(function(data) {
            $li.hide();
        }).fail(function(jqXHR){

        });

    });
});


