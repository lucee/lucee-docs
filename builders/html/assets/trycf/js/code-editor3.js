"use strict";
angular.module("code.editor", []).directive("codeEditor", function ($timeout) {
  var uid = +new Date().getTime() + "-" + guid();
  var editorTemplate =
    '<div id="{{id}}-editor" class="editor-wrapper"><h2 ng-hide="!title">{{title}}</h2>' +
    '<input type="hidden" name="{{fieldname}}" id="{{fieldname}}" value="{{code}}"/>' +
    '<div class="editor-container"><div>' +
    '	<div class="split-pane-frame">' +
    '		<div class="split-pane vertical-percent">' +
    '		    <div class="split-pane-component" id="left-component">' +
    '		        <div class="decoration">' +
    '					<form id="form-{{id}}" target="results-{{id}}" method="post" enctype="multipart/form-data" class="code-form">' +
    '						<input type="hidden" name="setupcode" id="setupcode" value="{{setupCode}}"/>' +
    '						<input type="hidden" name="code" id="code" value="{{code}}"/>' +
    '						<input type="hidden" name="postcode" id="postcode" value="{{postcode}}"/>' +
    '						<input type="hidden" name="key" id="key" value="{{id}}' +
    uid +
    '"/>' +
    '						<input type="hidden" name="asserts" id="asserts" value="{{asserts}}"/>' +
    "			        </form>" +
    '					<div class="code-editor"></div>' +
    "		        </div>" +
    "		    </div>" +
    '		    <div class="split-pane-divider my-divider"></div>' +
    '		    <div class="split-pane-component" id="right-component">' +
    '		        <div class="decoration">' +
    '		            <div class="results-wrapper">' +
    '		                <div class="results-div results"></div>' +
    '		                <div class="results-annotations"></div>' +
    '		                <span class="results-label">Results</span>' +
    "		            </div>" +
    "		        </div>" +
    "		    </div>" +
    "		</div>" +
    "	</div>" +
    "	</div>" +
    '	<div class="editor-toolbar">' +
    '	    <button class="submit-code btn {{runBtnClass || \'btn-primary\'}} pull-left">Run <span class="hidden-xs">Code</span> <i class="icon-play icon-white"></i></button>' +
    '	    <button ng-show="isMobileDevice()()" ng-click="saveGist()" id="save-code" class="btn btn-success pull-left">Save <span class="hidden-xs">Gist</span> <i class="icon-save icon-white"></i></button>' +
    '		<span class="code-editor-help text-muted hidden-xs" style="font-size:small;">&nbsp;Ctl+Enter to Run, Ctl+S to save Gist.</span>' +
    '		<span class="code-editor-message"></span>' +
    '	    <button class="toggle-fullscreen btn {{fullscreenbtnclass}} pull-right" ng-click="toggleFullscreen()"> <i class="icon-resize-full"></i></button>' +
    '	    <button class="editor-options btn btn-default {{optionsbtnclass}} pull-right"> <i class="icon-gear"></i></button>' +
    '		<span ng-hide="showResults == false || showResults == 0" class="alert alert-danger pull-right" style="padding: 5px;margin: 0px 3px 0px 3px;display: inline-block;"><span class="hidden-xs">&nbsp;</span> <span class="display-engine" style="line-height: 2.2;">></span></span>' +
    '		<div class="modal fade" style="display:none;" tabindex="-1" role="dialog">' +
    '		  <div class="modal-dialog">' +
    '		    <div class="modal-content">' +
    '		      <div class="modal-header page-header" style="margin: 5px;">' +
    '		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
    '		        <h4 class="modal-title">Editor Preferences</h4>' +
    "		      </div>" +
    '		      <div class="modal-body">' +
    '		        <label class="control-label">Change Editor Theme</label>' +
    "		        <div>" +
    '		         <select id="theme" class="form-control">' +
    '		           <optgroup label="Bright">' +
    '		             <option value="chrome">Chrome</option>' +
    '		             <option value="clouds">Clouds</option>' +
    '		             <option value="crimson_editor">Crimson Editor</option>' +
    '		             <option value="dawn">Dawn</option>' +
    '		             <option value="dreamweaver">Dreamweaver</option>' +
    '		             <option value="eclipse">Eclipse</option>' +
    '		             <option value="github">GitHub</option>' +
    '		             <option value="solarized_light">Solarized Light</option>' +
    '		             <option value="textmate" selected="selected">TextMate</option>' +
    '		             <option value="tomorrow">Tomorrow</option>' +
    '		             <option value="xcode">XCode</option>' +
    "		           </optgroup>" +
    '		           <optgroup label="Dark">' +
    '		             <option value="ambiance">Ambiance</option>' +
    '		             <option value="chaos">Chaos</option>' +
    '		             <option value="clouds_midnight">Clouds Midnight</option>' +
    '		             <option value="cobalt">Cobalt</option>' +
    '		             <option value="idle_fingers">idleFingers</option>' +
    '		             <option value="kr_theme">krTheme</option>' +
    '		             <option value="merbivore">Merbivore</option>' +
    '		             <option value="merbivore_soft">Merbivore Soft</option>' +
    '		             <option value="mono_industrial">Mono Industrial</option>' +
    '		             <option value="monokai">Monokai</option>' +
    '		             <option value="pastel_on_dark">Pastel on dark</option>' +
    '		             <option value="solarized_dark">Solarized Dark</option>' +
    '		             <option value="terminal">Terminal</option>' +
    '		             <option value="tomorrow_night">Tomorrow Night</option>' +
    '		             <option value="tomorrow_night_blue">Tomorrow Night Blue</option>' +
    '		             <option value="tomorrow_night_bright">Tomorrow Night Bright</option>' +
    '		             <option value="tomorrow_night_eighties">Tomorrow Night 80s</option>' +
    '		             <option value="twilight">Twilight</option>' +
    '		             <option value="vibrant_ink">Vibrant Ink</option>' +
    "		           </optgroup>" +
    "		         </select>" +
    "		        </div>" +
    '				<label class="control-label">Change CFML Engine</label>' +
    "		        <div>" +
    '		             <label class="radio-inline"><input type="radio" name="engine" class="luceeEngine"value="lucee7">Lucee 7 BETA</label>' +
    '		             <label class="radio-inline"><input type="radio" name="engine" class="luceeEngine" value="lucee6">Lucee 6 Latest</label>' +
    '		             <label class="radio-inline"><input type="radio" name="engine" class="luceeEngine" value="lucee5">Lucee 5.4 ( LTS )</label>' +
    '		             <label class="radio-inline"><input type="radio" name="engine" class="luceeEngine" value="lucee4">Lucee 4.5 ( EOL )</label>' +
    "		        </div>" +
    "		      </div>" +
    '		      <div class="modal-footer">' +
    '		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>' +
    "		      </div>" +
    "		    </div>" +
    "		  </div>" +
    "		</div>" +
    "	</div>" +
    "</div>" +
    "</div>";
  return {
    restrict: "AE",
    scope: {
      id: "@id",
      fieldname: "@fieldname",
      url: "@url",
      engine: "@engine",
      mode: "@mode",
      theme: "@theme",
      title: "@title",
      width: "@width",
      height: "@height",
      fullscreen: "@fullscreen",
      runBtnClass: "@runbtnclass",
      fullscreenBtnClass: "@fullscreenbtnclass",
      showOptions: "@showOptions",
      showError: "@showError",
      asserts: "@asserts",
      code: "@code",
      codeGist: "@codeGist",
      setupCode: "@setupCode",
      setupCodeGist: "@setupCodeGist",
      postcode: "@postcode",
      showResults: "@showResults",
      basepath: "@basepath",
    },
    template: editorTemplate,
    link: function (scope, element, attrs) {
      scope.code = attrs.code;
      scope.codeGist = attrs.codeGist;
      scope.setupCode = attrs.setupCode;
      scope.setupCodeGist = attrs.setupCodeGist;
      scope.asserts = attrs.asserts;
      scope.saveGist = saveGist;
      scope.engines = {
        lucee7: "Lucee 7 BETA",
        lucee6: "Lucee 6 Latest",
        lucee5: "Lucee 5.4 LTS",
        lucee4: "Lucee 4.5 EOL"
      };
      scope.engine = attrs.engine || "lucee6";
      scope.basepath = attrs.basepath || "/gist/";
      var editor = element.find(".code-editor"),
        codeForm = element.find(".code-form"),
        setupCode = element.find("#setupcode"),
        results = element.find(".results"),
        resultsDiv = element.find(".results-div"),
        resultsWrapper = element.find(".results-wrapper"),
        resultsFrame = angular
          .element(
            '<iframe name="results-' +
              attrs.id +
              '" id="results-' +
              attrs.id +
              '" class="results-frame" style="display:none;border:none;" width="100%" height="100%"></iframe>'
          )
          .prependTo(resultsWrapper),
        editorWrapper = element.find(".editor-wrapper"),
        resultsLabel = element.find(".results-label"),
        resultsAnnotations = element.find(".results-annotations"),
        splitPane = element.find(".split-pane"),
        submitCode = element.find(".submit-code"),
        message = element.find(".code-editor-message"),
        displayEngineSpan = element.find(".display-engine"),
        toggleFullscreenBtn = element.find(".toggle-fullscreen"),
        basepath = scope.basepath;
      if (!isMobileDevice()) {
        var aceEditor = window.ace.edit(editor[0]),
          session = aceEditor.getSession();
      } else {
        var textarea = document.createElement("textarea");
        textarea.name = "code-editor";
        textarea.maxLength = "5000";
        textarea.cols = "80";
        textarea.rows = "10";
        textarea.style =
          "width:100%;height: 100%;background-color:#333;color:#fff";
        textarea.value = scope.code;
        editor[0].appendChild(textarea);
        var resultsDisplay = document.getElementById("right-component");
        resultsDisplay.style =
          "width: 100% !important;background: #f3eee7;position: absolute;clear: both;height: 50%;bottom: 0px;top: 50%";
        var editorDisplay = document.getElementById("left-component");
        editorDisplay.style.width = "100%";
        var container = document.getElementsByClassName("editor-wrapper")[0];
        container.style.padding = 0;
        element.find(".my-divider").remove();
      }
      var mode = scope.mode || "coldfusion",
        theme = scope.theme || "monokai",
        showError =
          typeof attrs.showerror !== "undefined"
            ? attrs.showerror === "true" || attrs.showerror === "1"
            : true,
        asserts = attrs.asserts || "",
        showOptions =
          typeof attrs.showOptions !== "undefined"
            ? attrs.showOptions === "true" || attrs.showOptions === "1"
            : true,
        showResults =
          typeof attrs.showResults !== "undefined"
            ? attrs.showResults === "true" || attrs.showResults === "1"
            : t5rue,
        urlPool = {
          lucee4: ["https://lucee4-sbx.trycf.com/lucee4/getremote.cfm"],
          lucee5: ["https://lucee5-sbx.trycf.com/lucee5/getremote.cfm"],
          lucee5: ["https://lucee5-sbx.trycf.com/lucee5/getremote.cfm"],
          lucee6: ["https://lucee6-sbx.trycf.com/getremote.cfm"],
          lucee7: ["https://lucee7-sbx.trycf.com/getremote.cfm"]
        },
        url =
          attrs.url ||
          urlPool[scope.engine][
            Math.floor(Math.random() * urlPool[scope.engine].length)
          ];
      displayEngine();
      theme = theme.toLowerCase();
      element.find("#theme").val(theme);
      if (!isMobileDevice()) {
        aceEditor.setTheme("ace/theme/" + theme);
        session.setMode("ace/mode/" + mode);
        session.setUseWrapMode(true);
        ace.config.loadModule("ace/ext/language_tools", function () {
          aceEditor.setOptions({
            enableBasicAutocompletion: true,
            enableSnippets: true,
          });
          var snippetManager = ace.require("ace/snippets").snippetManager;
          var config = ace.require("ace/config");
          ace.config.loadModule("ace/snippets/coldfusion", function (m) {
            if (m) {
              snippetManager.files.coldfusion = m;
              m.snippets = snippetManager.parseSnippetFile(m.snippetText || "");
              snippetManager.register(m.snippets, m.scope);
            }
          });
        });
        aceEditor.commands.addCommand({
          name: "Run",
          bindKey: { win: "Ctrl-Enter", mac: "Command-Enter" },
          exec: function (editor) {
            if (submitCode) submitCode.trigger("click");
          },
        });
        aceEditor.commands.addCommand({
          name: "Save",
          bindKey: { win: "Ctrl-s", mac: "Command-s" },
          exec: function (editor) {
            saveGist();
          },
        });
        var langTools = ace.require("ace/ext/language_tools");
      }
      element.find("input.luceeEngine[type='radio'][value='" + scope.engine + "']").prop('checked',true);
      scope.$watch("code", function () {
        if (!isMobileDevice()) {
          session.setValue(scope.code);
        } else {
          editor.val(scope.code);
        }
      });
      if (scope.codeGist && scope.codeGist.length > 0) {
        loadGist(scope.codeGist).then(function (data) {
          var codeGist = "";
          for (var file in data.files) {
            codeGist += data.files[file].content;
          }
          scope.code = codeGist;
          if (!isMobileDevice()) {
            session.setValue(scope.code);
          }
        });
      }
      if (scope.setupCodeGist && scope.setupCodeGist.length > 0) {
        loadGist(scope.setupCodeGist).then(function (data) {
          var setupCodeGist = "";
          for (var file in data.files) {
            setupCodeGist += data.files[file].content;
          }
          setupCode.val(setupCodeGist);
        });
      }
      if (!isMobileDevice()) {
        session.setValue(scope.code);
        aceEditor.on("change", function (e) {
          scope.code = session.getValue();
          $("#code", codeForm).val(scope.code);
          $("#" + attrs.fieldname).val(scope.code);
        });
        splitPane.splitPane();
        splitPane.on("resize", function () {
          aceEditor.resize(true);
        });
      }
      editorWrapper.css("height", attrs.height);
      editorWrapper.css("width", attrs.width);
      scope.$watch("showOptions", function () {
        if (showOptions == 1 || showOptions == true) {
          element.find(".editor-options").show();
        } else {
          element.find(".editor-options").hide();
        }
      });
      scope.$watch("showResults", function () {
        if (showResults == 1 || showResults == true) {
          element.find("#right-component").show();
          element.find(".split-pane-divider").show();
          element.find(".code-editor-help").show();
        } else {
          element.find(".submit-code").hide();
          element.find("#right-component").hide();
          element.find(".split-pane-divider").hide();
          element.find("#left-component").css("width", "100%");
          element.find(".code-editor-help").hide();
        }
        if (!isMobileDevice()) {
          aceEditor.resize(true);
        }
      });
      if (!isMobileDevice()) {
        aceEditor.resize(true);
      }
      editor.show();
      if (scope.fullscreen !== undefined && scope.fullscreen == "true") {
        toggleFullscreen();
      }
      submitCode.on("click", function (e) {
        e.preventDefault();
        resultsFrame.attr("id", "results-" + attrs.id);
        resultsFrame.attr("name", "results-" + attrs.id);
        codeForm.attr("action", url);
        codeForm.attr("target", resultsFrame.attr("name"));
        var editorVal = isMobileDevice()
          ? editor.find("textarea").val()
          : aceEditor.getValue();
        if (!isMobileDevice()) {
          session.clearAnnotations();
        }
        $("#code", codeForm).val(editorVal);
        resultsFrame.hide();
        resultsDiv
          .html(
            '<div class="loading-title"><h1><i class="icon-rocket"></i> Working on it, <br>just a sec please...</h1></div>'
          )
          .fadeIn("fast");
        resultsFrame.on("load", frameOnLoad);
        codeForm.submit();
        element.find(".results-div div h1").fadeTo(2500, 0.2);
      });
      resultsWrapper.on("mouseover", function () {
        resultsLabel.css("opacity", 0).hide();
      });
      resultsWrapper.on("mouseout", function () {
        resultsLabel.fadeTo("fast", 0.3);
      });
      element.find(".editor-options").on("click", function (e) {
        e.preventDefault();
        var optionModal = element.find(".modal");
        optionModal.modal("show");
      });
      if (!isMobileDevice()) {
        element.find("#theme").on("change", function (e) {
          scope.theme = $(this).val();
          aceEditor.setTheme("ace/theme/" + $(this).val());
        });
      }
      element.find(".luceeEngine").on("change", function (e) {
        scope.engine = $(this).val();
        displayEngine();
        url =
          urlPool[scope.engine][
            Math.floor(Math.random() * urlPool[scope.engine].length)
          ];
      });
      function displayEngine() {
        displayEngineSpan.html(scope.engines[scope.engine]);
      }
      function saveGist() {
        var data = {
          description: "TryCF Gist",
          public: true,
          files: {
            "trycf-gist.cfm": {
              content: isMobileDevice()
                ? editor.find("textarea").val()
                : aceEditor.getValue(),
            },
          },
        };
        $.ajax({
          url: "https://api.github.com/gists",
          type: "POST",
          dataType: "json",
          data: JSON.stringify(data),
        })
          .success(function (response) {
            var gistId = response.id;
            var url = basepath + gistId + "/" + scope.engine;
            if (
              scope.setupCodeGist !== undefined &&
              scope.setupCodeGist.length > 0
            ) {
              url += "?setupCodeGistId=" + scope.setupCodeGist;
            }
            if (scope.theme.length > 0) {
              url +=
                (url.indexOf("?") > 0 ? "&" : "?") + "theme=" + scope.theme;
            }
            message.html(
              '<span class="alert alert-success" style="padding: 5px;margin: 5px 0 0 3px;display: inline-block;"><i class="icon-check icon-white"></i> Saved Gist: <a href="https://trycf.com' +
                url +
                '">' +
                response.id +
                "</a></span>"
            );
            document.title = "TryCF Gist : " + response.id;
            var domain = window.location.href.split("/")[2];
            window.history.pushState(
              { pageTitle: "TryCF Gist : " + response.id },
              "",
              "https://" + domain + url
            );
          })
          .error(function (e) {
            console.warn("gist save error", e);
            message.html(
              '<span class="alert alert-danger" style="padding: 5px;margin: 5px 0 0 3px;display: inline-block;"><i class="icon-warning-sign icon-white"></i> Couldn\'t save Gist: ' +
                e.detail +
                "</span>"
            );
          });
      }
      function loadGist(gistId) {
        return $.ajax({
          url: "https://api.github.com/gists/" + gistId,
          type: "GET",
          dataType: "json",
        })
          .success(function (response) {
            return response.files.content;
          })
          .error(function (e) {
            console.warn("gist save error", e);
          });
      }
      function frameOnLoad(e) {
        resultsFrame.off("load");
        var xhr = $.ajax({
          type: "GET",
          url: url + "?callback=?",
          data: { key: attrs.id + uid },
          timeout: 5000,
          dataType: "jsonp",
        })
          .always(renderResults)
          .fail(function (httpReq, status, exception) {
            if (status == "timeout") {
              renderResults({
                pattern: "",
                state: "execution",
                message:
                  "There was an error parsing your code.  This usually indicates a missing ; or another compile time syntax error.  Check your syntax and try again.",
                html: "There was an error parsing your code.",
                documentation: "",
                error:
                  "There was an error parsing your code.  This usually indicates a missing ; or another compile time syntax error.  Check your syntax and try again.",
                line: 0,
                column: 0,
              });
              return;
            }
            var html =
              '<div class="alert alert-info"><strong><i class="icon-time"></i> Oh snap</strong><br><p>Looks like someone is hogging all the resources.  Click run again and we\'ll try another server.</p>';
            url =
              urlPool[scope.engine][
                Math.floor(Math.random() * urlPool[scope.engine].length)
              ];
            resultsFrame.hide();
            resultsDiv.html(html).show();
          });
        function renderResults(data) {
          if (
            data.error !== undefined ||
            (asserts && asserts.length < 0 && data.hasfailedtest !== "false")
          ) {
            try {
              var html = "",
                htmlFull = "";
              if (typeof data !== "object") {
                data = $.parseJSON(data);
              }
              if (data.line !== undefined && data.line == 0) {
                if (data.state == "blacklist") {
                  html =
                    '<div class="alert alert-warning">' + data.html + "</div>";
                } else {
                  html =
                    '<div class="alert alert-danger"><strong><i class="icon-bug"></i> Error:</strong><br/>' +
                    data.error +
                    "</div>";
                }
              } else {
                html =
                  '<div class="alert alert-danger"><strong><i class="icon-bug"></i> Error:</strong><br/>' +
                  data.error +
                  " on line " +
                  data.line +
                  "</div>";
                if (!isMobileDevice()) {
                  session.setAnnotations([
                    {
                      row: data.line - 1,
                      column: data.column,
                      text: data.error || data.message,
                      type: "error",
                    },
                  ]);
                  aceEditor.gotoLine(data.line);
                }
                $timeout(function () {
                  makePopover(editor);
                }, 100);
              }
              htmlFull = html;
              if (data.pattern && data.pattern != "") {
                htmlFull +=
                  '<div class="alert alert-info"><strong><i class="icon-code"></i> Expected Pattern:</strong><br><pre><code>' +
                  decodeURIComponent(data.pattern) +
                  "</code></pre>";
              }
              if (data.documentation && data.documentation != "") {
                htmlFull +=
                  '<strong><i class="icon-book"></i> Documentation:</strong><pre>' +
                  decodeURIComponent(data.documentation) +
                  "</pre></div>";
              }
              resultsAnnotations.html(html);
              resultsDiv.html(htmlFull).show();
              resultsFrame.hide();
            } catch (e) {
              resultsDiv.hide();
              resultsFrame.show();
            }
          } else {
            if (asserts.length == 0 || !data.hasfailedtest) {
              resultsDiv.hide();
              resultsFrame.show();
            } else {
              if (typeof data !== "object") {
                data = $.parseJSON(data);
              }
              var html = data.html || "";
              if (data.tests && data.tests.length > 0) {
                var testFailed = 0;
                var resultList = $('<ul class="list-group"></ul>');
                var results = {};
                var filter = [];
                for (var test in data.tests) {
                  results = data.tests[test].results;
                  if (results.status === "fail") {
                    testFailed++;
                    if (filter.indexOf(results.message) == -1) {
                      resultList.append(
                        '<li class="list-group-item ' +
                          (results.status === "fail"
                            ? "alert-danger"
                            : "alert-success") +
                          '">' +
                          results.message +
                          "</li>"
                      );
                    }
                    filter.push(results.message);
                  }
                }
                if (testFailed > 0) {
                  resultList.prepend(
                    '<li class="list-group-item alert-danger"><i class="icon-bug"></i> Hmm... Something\'s not quite right...</li>'
                  );
                  resultsDiv.html(resultList.html()).show();
                  resultsFrame.hide();
                  return;
                }
              }
              if (data.status === "success") {
                resultsDiv.hide();
                resultsFrame.show();
              } else {
                resultsDiv.html(html).show();
                resultsFrame.hide();
              }
            }
          }
        }
        return;
      }
      scope.toggleFullscreen = toggleFullscreen;
      scope.isMobileDevice = isMobileDevice;
      function isMobileDevice() {
        var check = false;
        (function (a) {
          if (
            /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(
              a
            ) ||
            /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(
              a.substr(0, 4)
            )
          )
            check = true;
        })(navigator.userAgent || navigator.vendor || window.opera);
        return check;
      }
      function toggleFullscreen() {
        var height;
        element.find(".editor-container").toggleClass("fullscreen");
        element
          .find(".toggle-fullscreen i")
          .toggleClass("icon-resize-full")
          .toggleClass("icon-resize-small");
        if (element.find(".editor-container").hasClass("fullscreen")) {
          height = 600;
          $(document).on("keyup", scope.handleEscape);
        } else {
          height = 350;
          $(document).off("keyup", scope.handleEscape);
        }
       
        if (!isMobileDevice()) {
          aceEditor.resize(true);
          try {
            var _id = window.location.search.split("&")[1].split("=")[1];
            window.parent.postMessage({ src: "try-cf", height: height, id: _id });
          } catch (e) {
            console.error(e);
          }
        }
      }
      scope.handleEscape = function (e) {
        if (e.keyCode == 27) {
          scope.toggleFullscreen();
        }
      };
      function makePopover(editor) {
        var errorPos = $(".ace_error", "#" + attrs.id + "-editor").position(),
          errorTop = errorPos.top + 10,
          errorLeft = errorPos.left + 250,
          popover = $(".popover").length
            ? $(".popover")
            : $(
                '<div data-animation="true" class="popover" style="display:none;"></div>'
              ).prependTo($(".ace_error", "#" + attrs.id + "-editor"));
        popover.css({
          top: errorTop + "px",
          left: errorLeft + "px",
          position: "absolute",
          display: "block",
          "z-index": 9999,
        });
        popover.popover({
          title: "<i class='icon-warning-sign'></i> Oops...",
          content: $(".results-annotations").html(),
          trigger: "manual",
          html: true,
          placement: "bottom",
          container: "body",
        });
        $(".results-annotations").html("");
        popover.popover("show");
        $(".popover-title").css({
          background: "#F7AAAA",
          color: "maroon",
          "font-weight": "bold",
        });
        $("html").on("click.popover.data-api", function () {
          popover.popover("hide");
          popover.popover("destroy");
          popover.remove();
        });
      }
    },
  };
});
function s4() {
  return Math.floor((1 + Math.random()) * 0x10000)
    .toString(16)
    .substring(1);
}
function guid() {
  return (
    s4() +
    s4() +
    "-" +
    s4() +
    "-" +
    s4() +
    "-" +
    s4() +
    "-" +
    s4() +
    s4() +
    s4()
  );
}
