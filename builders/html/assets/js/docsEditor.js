$(function(){
    'use strict';
    var editors = {};

    $(".local-edit-link").on("click", function(ev){
        ev.stopPropagation();

        var $el = $(ev.currentTarget);
        var source = $(this).data('src');
        var str = "/docs/";
        var offset = source.indexOf(str);
        var page = source.substr(offset+str.length-1);

        var editorOpen = $el.data("editor-open");
        if (editorOpen){
            removeEditor($el, page);
            return false;
        }
        var $icon = $el.find(".fa");
        toggleLoadingIcon($icon, true);

        $.ajax({
            url: "/source" + page,
            type: "GET"
        }).done(function(data) {
            toggleLoadingIcon($icon, false);
            $el.data("editor-open", true);
            renderEditor(data, $el, page);
        }).error(function(jqXHR){
            toggleLoadingIcon($icon, false);
            alert(jqXHR.statusText);
        });
        return false;
    });

    var toggleLoadingIcon = function (icon,state){
        if (state)
            icon.removeClass("fa-pencil").addClass("fa-spin fa-spinner");
        else
            icon.addClass("fa-pencil").removeClass("fa-spin fa-spinner");
    }

    var removeEditor = function($el, page){
        var $editor = editors[page];
        if ($editor.length === 0){
            return;
        }
        $editor.remove();
        delete editors[page];
        $el.data("editor-open", false);
    };
    var renderEditor = function(data, $el, page){
        var $editor = $('<div class="panel panel-default doc-editor">').data("src", escape(page) );
        $editor.append($('<div class="panel-heading">Edit</div>'));

        var $body = $('<div class="panel-body"></div>');
        if (data.properties){
            renderProperties($body, data);
        }
        var $textarea = $('<textarea class="content"/>').height("200px").width("100%").val(data.content);
        $body.append($textarea);
        $editor.append($body);

        var $error = $('<div class="panel-error"></div>').hide();
        $editor.append($error);

        var $footer = $('<div class="panel-footer text-right"></div>');
        $editor.append($footer);

        var $cancel = $('<button class="btn">Cancel</button>');
        var $save = $('<button class="btn">Save</button>');
        $cancel.click(function(){
            removeEditor($el, page);
        });
        $save.click(function(){
            $(this).attr("disabled", true);
            var content = $editor.find(".content").val();
            $error.hide().html();
            var props = getProperties($editor);
            $.ajax({
                url: "/source" + page,
                type: "POST",
                data: {
                    content: content,
                    properties: JSON.stringify(props)
                }
            }).done(function(data) {
                document.location.reload();
            }).error(function(jqXHR){
                $(this).attr("disabled", false);
                $error.show().html(jqXHR.responseText);
            });
        });
        $footer.append($cancel, $save);

        $el.after($editor);

        $(".list-item-sub-group").on("click", function(){
            var list = $(this).next();
            var basic = $(this).hasClass("property");
            if (basic)
                list = $(this);

            var hidden = list.find("LABEL:hidden");
            var total = list.find("LABEL");
            var state = ( hidden.length > 0);
            list.find("LABEL").each(function(){
                if ($(this).find("INPUT:checked").length)
                    $(this).show();
                else
                    $(this).toggle(state);
            });
            if (!basic){
                list.toggle(hidden.length !== total.length || state);
            }
        });

        editors[page] = $editor;
        console.log(data);
    }
    var orderProperties = function(unOrderedProps){
        // preserve order
        var props = JSON.parse( JSON.stringify(unOrderedProps) ); // deep copy;
        var orderedProps = [];
        var propOrder = ['title','id','related','categories','visible'];
        for ( var po = 0; po < propOrder.length; po++){
            if (props.hasOwnProperty(propOrder[po])){
                orderedProps.push(propOrder[po]);
                delete props[propOrder[po]];
            }
        }
        for (var other in props){
            if (props.hasOwnProperty(other))
                orderedProps.push(props[other]);
        }
        return orderedProps;
    }
    var getProperties = function($editor){
        var props = {};
        $editor.find(".property").each(function(){
            var cfg = $(this).data();
            switch (cfg.type){
                case "check":
                    props[cfg.name] = [];
                    $(this).find("INPUT:checked").each(function(){
                        props[cfg.name].push($(this).val());
                    })
                    break;
                case "text":
                    props[cfg.name] = $(this).find("INPUT").val();
                    break;
                default:
                    throw new Error("unknown input type");
            }
        });
        for (var p in props){
            if (props[p].length === 0)
                delete props[p];
        }
        return props;
    };
    var renderProperties = function($body, data){
        if (Object.keys(data.properties).length > 0){
            if (!data.properties.title)
                data.properties.title = "";
            if (!data.properties.id)
                data.properties.id = "";
        }
        if (data.reference){
            if (!data.properties.categories)
                data.properties.categories = [];
            if (!data.properties.related)
                data.properties.related = [];
        }

        var props = orderProperties(data.properties);

        for (var idx in props){
            var p = props[idx];
            var $prop = $("<div class='property'/>").data("property", p).data("name",p);
            $prop.append($('<div class="property-item"/>').text(p));
            switch (p){
                case "related":
                    var related = {
                        tag: data.reference.pages.tag
                        , function: data.reference.pages.function
                    };

                    renderList($prop, p, data.properties[p], related);
                    $prop.data("type","check");
                    break;
                case "categories":
                    renderList($prop, p, data.properties[p], data.reference.categories);
                    $prop.data("type","check");
                    break;
                default:
                    $prop.append($("<input type='text' size='75'>").val(data.properties[p])).width("100%");
                    $prop.data("type","text");
            }
            $body.append($prop);
        }
    }
    var renderList = function($label, propery, v, data) {
        var selected = {};
        for (var p in v)
            selected[v[p]] = true;
        var $list = $('<div class="list-items"/>');
        var hidden = 0;

        var renderItem = function(id, title){
            var $label = $("<label/>");
            var $ff = $('<input type="checkbox">').val(id);

            if (selected[id]){
                $ff.attr("checked", true);
                delete selected[ id ];
            } else {
                $label.hide();
                hidden++;
            }
            $label.append($ff, title);
            return $label;
        }
        var renderGroup = function(item, group){
            var $group = $('<div class="list-group"/>');
            $group.append($('<b class="list-item-sub-group"/>').text(item));
            var sel = 0,  prefix_len = item.length+1;
            var subtitle, title, prefix, id;
            var $subGroup = $('<span class="list-item"/>')
            for (var subitem in group){
                id = group[subitem];
                prefix = id.indexOf(item);
                if (selected[ id ])
                    sel++;
                if (prefix == 0)
                    subtitle = id.substr(prefix_len);
                else
                    subtitle = id;
                $subGroup.append(renderItem(id, subtitle));
            }
            if (sel === 0)
                $subGroup.hide();
            $group.append($subGroup);
            $list.append($group);
         }

        for (var item in data){
            var title = data[item];
            if (typeof title == "string"){
                $list.append(renderItem(title, title));
                $label.addClass("list-item-sub-group");
            } else {
                renderGroup(item, data[item]);
            }
        }
        // preserve/flag any list items not present in the dataset from the server
        if (Object.keys(selected).length > 0){
            renderGroup("other", Object.keys(selected));
        }

        /*
        var $select = $('<button class="btn">Expand</button>').data("hidden", true);
        $select.click(function(){
            var hidden = $select.data("hidden");
            $list.find("label").each(function(){
                if (hidden){
                    $list.find(":hidden").each(function(){
                        $(this).show();
                    });
                } else {
                    if (!$(this).find("INPUT").is(":checked"))
                        $(this).hide();
                }
            });
            if (hidden)
                $select.html("Expand");
            else
                $select.html("Select");
            $select.data("hidden", !hidden);
        });
        $list.append($select);
        */
        $label.append($list);
    }

});


