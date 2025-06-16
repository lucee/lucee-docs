from pygments import highlight
from pygments.lexers import get_lexer_by_name, guess_lexer
from pygments.formatters import HtmlFormatter

try:
    # First try explicit language
    if language:
        lexer = get_lexer_by_name(language)
    else:
        # Fallback to auto-detection if no language specified
        lexer = guess_lexer(code)
except:
    # If explicit language fails, attempt auto-detection
    try:
        lexer = guess_lexer(code)
    except Exception, e:
        lexer = get_lexer_by_name('text')  # Ultimate fallback

result = highlight(code, lexer, HtmlFormatter())
