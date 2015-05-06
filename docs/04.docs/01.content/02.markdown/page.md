---
title: LuceeDocs-flavoured Markdown
id: docs-markdown
---

# LuceeDocs-flavoured Markdown

The base markdown engine used is [pegdown](https://github.com/sirthias/pegdown). Please see both the [official markdown website](http://daringfireball.net/projects/markdown/) and the the [pegdown repository](https://github.com/sirthias/pegdown) for the supported syntax.

On top of this base layer, the Lucee Documentation system processes its own special syntaxes for syntax highlighting, cross referencing and notice boxes. It also processes YAML front matter to glean extra metadata about pages.

## Syntax highlighting

Syntax highlighted code blocks start and end with three backticks on their own line with an optional lexer after the first set of ticks. 

For example, a code block using a 'lucee' lexer, would look like this:

<pre>
```lucee
x = y;
WriteOutput( x );
```
</pre>

A code block without syntax higlighting would look like this:

<pre>
```
x = y;
WriteOutput( x );
```
</pre>

>>> For a complete list of available lexers, see the [Pygments website](http://pygments.org/docs/lexers/). We have added a 'lucee' alias in anticipation of an official lexer at some point in the future.



