// jython is only python 2.7, pygments 2.6 requires python 3.0
component
  javaSettings='{
    "maven": [
      { "groupId": "org.python", "artifactId": "jython-standalone", "version": "2.7.4" },
      { "groupId": "org.pygments", "artifactId": "pygments", "version": "2.5.2" }
    ]
  }'
{

  import org.python.util.PythonInterpreter;

  /**
   * Highlights Python code using Pygments via Jython.
   * @param code The Python code to highlight.
   * @return HTML string with syntax highlighting.
   */
  public string function highlight(required string code, string language, string formatter="html") {
    var interpreter = new PythonInterpreter();
	interpreter.set("code", arguments.code);
	interpreter.set("language", arguments.language);
	interpreter.set("formatter", arguments.formatter);

	var pythonFile = expandPath( getDirectoryFromPath( getCurrentTemplatePath() ) & "/highlighter.py" );
    interpreter.execFile( pythonFile );
	var result = interpreter.get("result", createObject('java', 'java.lang.String').getClass());
	var lexer = interpreter.get("lexer");
	// dump(var=lexer.toString(), label="#language#");
	
    return result;
  }

  public string function getCss() {
    var interpreter = new PythonInterpreter();
	interpreter.set("style", "default");	
	var pythonFile = expandPath( getDirectoryFromPath( getCurrentTemplatePath() ) & "pygmentsCss.py" );
    interpreter.execFile( pythonFile );
    var css = interpreter.get("css", createObject('java', 'java.lang.String').getClass());	
    return css;
  }
}
