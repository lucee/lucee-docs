---
title: Lucee Docs Markdown
id: docs-markdown
---

The base Markdown engine used is [commonmark](https://github.com/commonmark/commonmark-java). Please see both the [official Markdown website](http://daringfireball.net/projects/markdown/) for the supported syntax.

On top of this base layer, the Lucee Documentation system processes its own special syntaxes for syntax highlighting, cross referencing and notice boxes. It also processes YAML front matter to glean extra metadata about pages.

## Syntax highlighting

Syntax highlighted code blocks start and end with three backticks on their own line with an optional lexer after the first set of ticks.

For example, a code block using a 'luceescript' lexer, would look like this:

<pre>
```luceescript
x = y;
WriteOutput( x );
```
</pre>

A code block without syntax highlighting would look like this:

<pre>
```
x = y;
WriteOutput( x );
```
</pre>

>>> We have implemented two lexers for Lucee, `lucee` and `luceescript`. The former is used for tag based code, the latter, script based. For a complete list of available lexers, see the [Pygments website](http://pygments.org/docs/lexers/).

### Embedded TryCF code runner

In addition to syntax highlighting, we also will take any lexer that is suffixed with `+trycf`, and convert the contained code into a runnable and editable sample using [TryCF](http://trycf.com) (in the website only). For example:

<pre>
```luceescript+trycf
x = 10;
WriteOutput( x );
```
</pre>

or:

<pre>
```lucee+trycf
&lt;cfset x = 10&gt;
&lt;cfoutput&gt;#x#&lt;/cfoutput&gt;
```
</pre>

## Cross referencing

Cross referencing between pages can be achieved using a double square bracket syntax surrounding the id of the page you wish to link to. For example:

```html
[[function-abs]]
```

When the link is rendered, the title of the page will be passed to the renderer. To provide a custom text for the link, use the following syntax:

```html
[[function-abs|Custom link text]]
```

## Notice boxes

Various "notice boxes" can be rendered by using a nested blockquote syntax. The nesting level dictates the type of notice rendered.

### Info boxes

Info boxes use three levels of blockquote indentation:

```html
>>> An example info box
```

>>> An example info box

### Warning boxes

Warning boxes use four levels of blockquote indentation:

```html
>>>> An example warning box
```

>>>> An example warning box

### Important boxes

Important boxes use five levels of blockquote indentation:

```html
>>>>> An example 'important' box
```

>>>>> An example 'important' box

### Tip boxes

Tip boxes use six levels of blockquote indentation:

```html
>>>>>> An example tip box
```

>>>>>> An example tip box

## Content Directives

Content directives allow you to embed dynamic content from the documentation system using the <code>&#91;&#91;content::type&#93;&#93;</code> syntax. These are rendered at build time.

The content wiki links are parsed in `api/rendering/WikiLinksRenderer.cfc` and dispatched via the `renderContent()` method in `api/data/DocTree.cfc`, which maps each content type to a renderer CFC in `api/rendering/content/`. To add a new content directive, add a case to the switch statement in `renderContent()` and create a corresponding CFC in that directory.

### System Properties / Environment Variables

To render the details for a single system property or environment variable inline:

```html
[[content::sysprop-envvar#LUCEE_EXTENSIONS_INSTALL]]
```

To render the full listing of all system properties and environment variables, grouped by category:

```html
[[content::sysprop-envvar-listing]]
```

The `sysprop-envvar-for-tag` and `sysprop-envvar-for-function` directives are used automatically in the tag and function reference templates to show related system properties.

### Latest Recipes

To render a list of the latest recipe pages:

```html
[[content::latest-recipes]]
```

### Latest Changelog

To render a list of the most recently introduced tags, functions, arguments and attributes (default 20 items, sorted by `introduced` version descending):

```html
[[content::latest-changelog]]
```

Pass a custom limit via the hash parameter:

```html
[[content::latest-changelog#10]]
```

## Inline Page References

In addition to the plain cross-reference <code>&#91;&#91;page-id&#93;&#93;</code>, the `::modifier` suffix renders a page's content inline rather than as a link.

### `::inline`

Renders a compact block with the linked title and a short description (from the page's frontmatter, or the first paragraph of the body). Works with any page type. For function and tag pages the usage signature is appended in a code block:

```html
[[function-mavenexists::inline]]
[[tag-http::inline]]
[[recipe-docker-onbuild::inline]]
```

### `::signature`

Renders just the signature in a code block — no title, no description. Useful when the surrounding prose already names the function or tag:

```html
[[function-abs::signature]]
[[tag-query::signature]]
```

`::signature` only supports function and tag pages. The signature is produced by `getUsageSignature()` on the page object — the same call used by the function and tag page templates — so tags with many attributes will emit the full multi-line signature.

The `::modifier` suffix is parsed in `api/rendering/WikiLinksRenderer.cfc` and dispatched through `renderContent()` in `api/data/DocTree.cfc` just like the `content::` directives above, which makes it cheap to add new modifiers.

## Front Matter

Front matter adds metadata that the build system uses for cross referencing, navigation, search indexing and rendering.

Two formats are supported depending on page type:

- **YAML** — used by guides, reference pages, categories, and most content under `/docs/`. Three dashes `---` at the top of the file, a YAML block, then three dashes on their own line.
- **JSON in HTML comment** — used by recipe pages under `/docs/recipes/`. An HTML comment containing a JSON object, before the body. New recipes must also be added to `/docs/recipes/index.json`.

YAML example:

```yaml
---
id: function-abs
title: Abs()
description: Returns the absolute value of a number.
categories:
    - number
    - math
related:
    - function-sgn
    - function-ceiling
---
```

JSON-in-HTML-comment example (recipes):

```html
<!--
{
    "title": "Recipe Title",
    "id": "recipe-slug",
    "description": "One-line description.",
    "keywords": ["keyword1", "keyword2"],
    "categories": ["category-name"],
    "related": ["other-recipe-id", "function-name"]
}
-->
```

Both formats accept the same fields, documented below.

### Required fields

| Field | Description |
| --- | --- |
| `id` | Unique page identifier. Used for cross referencing (`[[page-id]]`) and as the canonical key in the build's `idMap`. Must be unique across the whole site. |
| `title` | Page title used in headings, nav, and search results. |

### Common fields

| Field | Type | Description |
| --- | --- | --- |
| `description` | string | Single-line meta description used for SEO, the recipes index, and See Also blurbs. If omitted, the first paragraph of the body is auto-extracted and stored separately (so it doesn't appear as a custom description when editing). |
| `categories` | array | Category names; each renders a `[[category-name]]` link and lists this page on the category landing page. |
| `related` | array | Page ids or external URLs. Generates the "See Also" block automatically — don't add See Also sections manually. Strings starting with `http://` / `https://` are treated as external links. |
| `keywords` | array | Additional terms for the search index. |

### Visibility & navigation

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `visible` | boolean | `true` for directories with a `NN.` numeric prefix (e.g. `01.getting-started`), `false` otherwise | Whether the page appears in nav menus. `visible: false` still builds the page — the URL stays accessible. |
| `hidden` | boolean | `false` | Excludes the page from the build entirely — no HTML output, URL 404s. Use sparingly; for retiring pages, prefer a redirect mechanism. |
| `menuTitle` | string | falls back to `title` | Alternate title shown in nav only. |
| `sortOrder` | number | derived from the `NN.` directory prefix | Manual sort position within the parent. |
| `forceSortOrder` | number | `-1` (disabled) | Overrides the calculated sort multiplier. Only honoured for top-level entries under `/guides/` and `/recipes/`. |
| `slug` | string | last path segment with any `NN.` prefix stripped | URL slug override. Rarely needed. |

### Specialty fields

| Field | Type | Description |
| --- | --- | --- |
| `listingStyle` | string | For listing-style pages. `flat` flattens all descendants into a single A–Z index regardless of depth. |
| `reference` | boolean | Default `true`. When `false`, the page is excluded from the "See Also" block on other pages. |
| `statusFilter` | string | For implementation-status listings — filters referenced pages by status (e.g. `deprecated`). |
| `redirect` | string | Page id to redirect this URL to. The build emits a meta-refresh stub at the old URL instead of rendering the full page, and excludes it from nav, search, sitemap, recipe index, See Also, and category listings. The target id must exist or the build fails. See [Redirecting retired pages](#redirecting-retired-pages) below. |

### Redirecting retired pages

To retire a page without breaking inbound links, set `redirect:` to the id of the canonical replacement. The body is ignored — set only `title` (used by the stub) and `redirect`:

```yaml
---
title: Securing Tomcat and Lucee on Windows
redirect: locking-down-lucee-server
---
```

The build emits a minimal HTML file at the old URL containing a `<meta http-equiv="refresh">`, a `<link rel="canonical">`, a `noindex` robots directive, and a body link for crawlers and no-JS clients. The matching `.md` export gets a one-line `> This page has moved to [Title](url).` notice so scripts that consume the markdown form still get a pointer to the canonical page.

Redirect pages are excluded from `sitemap.xml`, the search index, the recipes index, the See Also block on other pages, category landing pages, and the nav. Pointing `redirect:` at an id that doesn't exist in the build fails the build with an `InvalidRedirectTarget` error.

### Cross referencing

Category links render as `[[category-categoryname]]`. `related` links render through the Markdown renderer, so they accept any valid link format including the `[[page-id]]` cross-reference syntax. To include surrounding quotes when using cross-reference syntax inside YAML, double-quote the value:

```yaml
related:
    - "[Problem with Abs()](http://someblog.com/somearticle.html)"
    - function-sgn
```
