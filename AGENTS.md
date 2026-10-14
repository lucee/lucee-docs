# Lucee Documentation Source and Builder

Generates the static documentation site at [docs.lucee.org](https://docs.lucee.org) from markdown/CFML source files.

## Folder Structure

- `/docs`: Documentation source (markdown with YAML/JSON frontmatter)
- `/api`: CFML API layer — DocTree, Page, PageReader, build orchestration
- `/builders/html`: HTML builder — templates, helpers, assets (CSS/JS)
- `/builders/markdown`: Markdown builder
- `/builders/cfdocs`: CFDOCS JSON builder
- `/server`: Live development server (CommandBox/Lucee)
- `/builds`: Build output (generated, not committed)
- `/profiles`: JFR profiles for performance analysis
- `/test-output`: Build logs and test output

## Building

The build uses [script-runner](https://github.com/lucee/script-runner) to run CFML headless with Lucee 7.

- Full build: `./build.sh` or `./build.bat`
- Profiled build with JFR: `./build-profile.bat [logname]`
- Import reference data: `./import.bat`

Always pipe build output to a file under `/test-output`.

## Recipe Format

Recipes are in `/docs/recipes/`. See the full [Lucee Docs Markdown](https://docs.lucee.org/docs/markdown.html) format guide at `/docs/06.docs/02.markdown/page.md`.

They use JSON frontmatter in HTML comments:

```markdown
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

# Recipe Title

Content here...
```

- `related` links generate "See Also" sections automatically — don't add them manually
- Wiki links use `[[page-id]]` syntax
- New recipes must be added to `/docs/recipes/index.json`

## Reference Docs Format

Reference pages (functions, tags, objects) use YAML frontmatter. See the full guide at `/docs/06.docs/03.docsreference/page.md` ([Cross referencing](https://docs.lucee.org/docs/reference-pages.html)).

```markdown
---
title: FunctionName
id: function-name
related:
categories:
    - string
    - regex
---

Description here.
```

## Code Style

- Use tabs for indentation in CFML
- Spaces around arguments: `doSomething( name="zac", src=files[ 1 ] )`
- Don't delete existing comments
- Markdown: blank lines before lists and after headings

## Key Files

- `/Application.cfc`: Build-time application config (mappings, regex engine)
- `/api/data/DocTree.cfc`: Builds the documentation tree from source files
- `/api/data/PageReader.cfc`: Parses markdown files (YAML frontmatter splitting, description extraction)
- `/api/data/Page.cfc`: Page object model
- `/builders/html/Builder.cfc`: HTML output builder (multi-threaded, Pygments highlighting)
- `/api/rendering/SyntaxHighlighter.cfc`: Code block highlighting via Jython/Pygments
