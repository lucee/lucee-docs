from pygments.formatters import HtmlFormatter
# nobackground=True prevents Pygments from setting background colors
# This allows our CSS variables to control the background via _code.scss
css = HtmlFormatter(style=style, nobackground=True).get_style_defs(['.highlight']);
