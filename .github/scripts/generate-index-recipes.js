const fs = require('fs-extra');
const path = require('path');
const crypto = require('crypto');

const REPO_ROOT = path.join(__dirname, '../..');
const BASE_SITE_URL = 'https://docs.lucee.org';
const BASE_RECIPES_URL = `${BASE_SITE_URL}/recipes/`;
const BASE_RAW_URL = 'https://raw.githubusercontent.com/lucee/lucee-docs/master/';

const TECHNICAL_SPECS = [
  { topic: 'AI — `createAISession`, `inquiryAISession`, multipart, RAG, MCP passthrough', file: 'docs/recipes/ai.md' },
  { topic: 'AST/Parser — `astFromPath`, `astFromString`, node types, ESTree', file: 'docs/technical-specs/ast.yaml' },
  { topic: 'Startup Hooks — `.CFConfig.json`, class loading, lifecycle, OSGi/Maven', file: 'docs/technical-specs/startup-hooks.yaml' },
  { topic: 'JSR-223 — `ScriptEngineFactory`, engine names, MIME types, CLI, Ant', file: 'docs/technical-specs/jsr223.yaml' },
  { topic: 'Monitors — action/request/interval, `ActionMonitorCollector`, `getMonitorData()`', file: 'docs/technical-specs/monitors.yaml' },
  { topic: 'LuCLI — CLI tool, `lucee.json`, server lifecycle, modules, secrets, deps', file: 'docs/technical-specs/lucli-spec.md' },
];

const GUIDE_PAGE_FILES = new Set(['page.md', 'chapter.md']);

async function generateIndex() {
  const recipesDir = path.join(REPO_ROOT, 'docs/recipes');
  const guidesDir = path.join(REPO_ROOT, 'docs/04.guides');
  const examplesDir = path.join(REPO_ROOT, 'examples');
  const outputPath = path.join(recipesDir, 'index.json');
  const readmePath = path.join(recipesDir, 'README.md');
  const skillPath = path.join(recipesDir, 'lucee.skill');

  console.log('Generating index, README and skill...');

  const recipes = await collectRecipes(recipesDir);
  const guides = await collectGuides(guidesDir);
  const examples = await collectExamples(examplesDir);

  let readmeContent = '# Recipes\n\n';
  for (const recipe of recipes) {
    readmeContent += `## [${recipe.title}](/docs/recipes/${recipe.file})\n\n${recipe.description}\n\n`;
  }

  console.log(`Writing index to ${outputPath}`);
  await fs.writeJson(outputPath, recipes.map(({ description, ...entry }) => entry), { spaces: 2 });

  console.log(`Writing README to ${readmePath}`);
  await fs.writeFile(readmePath, readmeContent.trim(), 'utf-8');

  console.log(`Writing skill to ${skillPath}`);
  await fs.writeFile(skillPath, generateSkill({ recipes, guides, examples }), 'utf-8');

  console.log(`Indexed ${recipes.length} recipes, ${guides.length} guides, ${examples.length} examples`);
  console.log('Index, README and skill generation complete.');
}

async function collectRecipes(recipesDir) {
  const files = await fs.readdir(recipesDir);
  const index = [];

  for (const file of files) {
    if (!file.endsWith('.md') || file === 'README.md') {
      continue;
    }

    const filePath = path.join(recipesDir, file);
    const content = await fs.readFile(filePath, 'utf-8');
    const titleMatch = content.match(/^#\s+(.+)$/m);
    const title = titleMatch ? titleMatch[1] : 'Untitled';
    const hash = crypto.createHash('md5').update(content).digest('hex');

    const metadataMatch = content.match(/<!--\s*({[^]*?})\s*-->/);
    let description = 'No description available.';
    let keywords = [];
    if (metadataMatch) {
      const metadata = JSON.parse(metadataMatch[1]);
      if (metadata.description) description = metadata.description;
      if (metadata.keywords) keywords = metadata.keywords;
    }

    index.push({
      file,
      title,
      path: `/docs/recipes/${file}`,
      hash,
      keywords,
      description,
    });
  }

  return index.sort((a, b) => a.title.localeCompare(b.title));
}

async function collectGuides(guidesDir) {
  const guides = [];

  await walkFiles(guidesDir, async (filePath) => {
    const fileName = path.basename(filePath);
    if (!GUIDE_PAGE_FILES.has(fileName)) {
      return;
    }

    const content = await fs.readFile(filePath, 'utf-8');
    const metadata = parseYamlFrontmatter(content);
    const sitePath = getSitePathFromDocsFile(filePath);
    const title = metadata.title || extractMarkdownTitle(content) || 'Untitled';
    const id = metadata.id || sitePath.replace(/^\//, '').replace(/\//g, '-');

    guides.push({
      title,
      id,
      sitePath,
      fetchUrl: `${BASE_SITE_URL}${sitePath}.md`,
      keywords: metadata.keywords || [],
    });
  });

  return guides.sort((a, b) => a.title.localeCompare(b.title));
}

async function collectExamples(examplesDir) {
  if (!(await fs.pathExists(examplesDir))) {
    return [];
  }

  const examples = [];

  await walkFiles(examplesDir, async (filePath) => {
    if (path.basename(filePath).toLowerCase() !== 'readme.md') {
      return;
    }

    const content = await fs.readFile(filePath, 'utf-8');
    const relativePath = path.relative(REPO_ROOT, filePath).split(path.sep).join('/');
    const title = extractMarkdownTitle(content) || relativePath;
    const id = relativePath.replace(/^examples\//, '').replace(/\/readme\.md$/i, '');

    examples.push({
      title,
      id,
      relativePath,
      fetchUrl: `${BASE_RAW_URL}${relativePath}`,
    });
  });

  return examples.sort((a, b) => a.title.localeCompare(b.title));
}

async function walkFiles(dir, callback) {
  const entries = await fs.readdir(dir, { withFileTypes: true });

  for (const entry of entries) {
    const entryPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      await walkFiles(entryPath, callback);
    } else if (entry.isFile()) {
      await callback(entryPath);
    }
  }
}

function stripNumericPrefix(segment) {
  return segment.includes('.') ? segment.split('.').slice(1).join('.') : segment;
}

function getSitePathFromDocsFile(filePath) {
  const relativeDir = path.relative(path.join(REPO_ROOT, 'docs'), path.dirname(filePath));
  const parts = relativeDir.split(path.sep).map(stripNumericPrefix);
  return `/${parts.join('/')}`;
}

function parseYamlFrontmatter(content) {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) {
    return {};
  }

  const metadata = {};
  for (const line of match[1].split('\n')) {
    const keyMatch = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!keyMatch) {
      continue;
    }

    const key = keyMatch[1];
    let value = keyMatch[2].trim();
    if ((value.startsWith("'") && value.endsWith("'")) || (value.startsWith('"') && value.endsWith('"'))) {
      value = value.slice(1, -1);
    }

    if (key === 'keywords' || key === 'categories' || key === 'related') {
      metadata[key] = parseYamlList(value, content, key);
    } else {
      metadata[key] = value;
    }
  }

  return metadata;
}

function parseYamlList(inlineValue, content, key) {
  if (inlineValue.startsWith('[') && inlineValue.endsWith(']')) {
    return inlineValue
      .slice(1, -1)
      .split(',')
      .map((item) => item.trim().replace(/^['"]|['"]$/g, ''))
      .filter(Boolean);
  }

  const items = [];
  const blockMatch = content.match(new RegExp(`^${key}:\\s*\\n((?:\\s+-\\s+.+\n?)*)`, 'm'));
  if (!blockMatch) {
    return items;
  }

  for (const line of blockMatch[1].split('\n')) {
    const itemMatch = line.match(/^\s+-\s+(.+)$/);
    if (itemMatch) {
      items.push(itemMatch[1].trim().replace(/^['"]|['"]$/g, ''));
    }
  }

  return items;
}

function extractMarkdownTitle(content) {
  const match = content.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : '';
}

function formatKeywords(keywords, limit = 6) {
  return (keywords || []).slice(0, limit).join(', ');
}

function buildTableRows(items, rowBuilder) {
  return items.map(rowBuilder).join('\n');
}

function generateSkill({ recipes, guides, examples }) {
  const recipeRows = buildTableRows(recipes, (recipe) => {
    const id = recipe.file.replace(/\.md$/, '');
    return `| ${recipe.title} | \`${id}\` | ${formatKeywords(recipe.keywords)} |`;
  });

  const guideRows = buildTableRows(guides, (guide) => {
    return `| ${guide.title} | \`${guide.id}\` | \`${guide.sitePath}\` | ${formatKeywords(guide.keywords)} |`;
  });

  const exampleRows = buildTableRows(examples, (example) => {
    return `| ${example.title} | \`${example.id}\` | \`${example.fetchUrl}\` |`;
  });

  const specRows = TECHNICAL_SPECS
    .map((spec) => `| ${spec.topic} | \`${BASE_RAW_URL}${spec.file}\` |`)
    .join('\n');

  return `---
name: lucee-docs
description: >
  Lucee CFML documentation covering recipes, guides, and runnable examples — configuration,
  extensions, AI integration, Docker, datasources, caching, logging, mappings, startup hooks,
  and all Lucee features. Use this skill whenever the user asks anything about Lucee or CFML.
  For tags and functions, use the Lucee MCP server instead. Fetch the relevant doc(s) on demand
  — never guess at Lucee-specific behavior; always read the source first.
---

# Lucee Documentation

## How to use this skill

1. Identify the relevant entry from the indexes below using title, path, or keywords
2. Fetch content on demand:
   - Recipes: \`${BASE_RECIPES_URL}<id>.md\`
   - Guides: \`${BASE_SITE_URL}<path>.md\` (path includes leading slash, e.g. \`/guides/getting-started/first-steps\`)
   - Examples: raw GitHub URL from the Examples Index
   - Tags and functions: use the Lucee MCP server, not this skill
3. For internals (class names, signatures, constants), use the Technical Specs table
4. Answer from fetched content — do not guess at Lucee-specific details

## Recipe Index

| Title | ID | Keywords |
|-------|-----|----------|
${recipeRows}

## Guide Index

| Title | ID | Path | Keywords |
|-------|-----|------|----------|
${guideRows}

## Examples Index

| Title | ID | URL |
|-------|-----|-----|
${exampleRows}

## Technical Specs

For implementation details, class names, and API signatures fetch directly:

| Topic | URL |
|-------|-----|
${specRows}

## Notes

- Recipe and guide docs are fetched live from \`${BASE_SITE_URL}\` — always current
- Examples and technical specs are fetched live from the lucee-docs GitHub repo
- Tags and functions are covered by the Lucee MCP server
- If a fetch fails, fall back to answering from training knowledge and note uncertainty
- Multiple docs can be fetched for cross-cutting questions (e.g. configuration + Docker examples)
`;
}

generateIndex().catch((err) => {
  console.error('Error generating index, README and skill:', err);
  process.exit(1);
});
