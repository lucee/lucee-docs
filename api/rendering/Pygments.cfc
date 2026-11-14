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

  variables.pool = application.pygmentsPool ?: _initPool();
  variables.stringClass = createObject( "java", "java.lang.String" ).getClass();
  variables.highlighterPy = expandPath( getDirectoryFromPath( getCurrentTemplatePath() ) & "/highlighter.py" );
  variables.cssPy = expandPath( getDirectoryFromPath( getCurrentTemplatePath() ) & "/pygmentsCss.py" );

  private any function _initPool() {
    var pool = createObject( "java", "java.util.concurrent.LinkedBlockingQueue" ).init();
    application.pygmentsPool = pool;
    return pool;
  }

  private any function borrowInterpreter() {
    var interp = variables.pool.poll();
    if ( isNull( interp ) )
      interp = new PythonInterpreter();
    return interp;
  }

  private void function returnInterpreter( required any interpreter ) {
    variables.pool.put( arguments.interpreter );
  }

  /**
   * Highlights code using Pygments via Jython.
   * @param code The code to highlight.
   * @return HTML string with syntax highlighting.
   */
  public string function highlight( required string code, string language, string formatter="html" ) {
    var interpreter = borrowInterpreter();
    try {
      interpreter.set( "code", arguments.code );
      interpreter.set( "language", arguments.language );
      interpreter.set( "formatter", arguments.formatter );
      interpreter.execFile( variables.highlighterPy );
      var result = interpreter.get( "result", variables.stringClass );
      return result;
    } finally {
      returnInterpreter( interpreter );
    }
  }

  public string function getCss() {
    var interpreter = borrowInterpreter();
    try {
      interpreter.set( "style", "default" );
      interpreter.execFile( variables.cssPy );
      var css = interpreter.get( "css", variables.stringClass );
      return css;
    } finally {
      returnInterpreter( interpreter );
    }
  }

  public string function getCssDark() {
    var interpreter = borrowInterpreter();
    try {
      interpreter.set( "style", "monokai" );
      interpreter.execFile( variables.cssPy );
      var css = interpreter.get( "css", variables.stringClass );
      return css;
    } finally {
      returnInterpreter( interpreter );
    }
  }
}
