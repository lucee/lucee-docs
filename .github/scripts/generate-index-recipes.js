const fs = require('fs-extra');
const path = require('path');
const crypto = require('crypto');

const REPO_ROOT = path.join(__dirname, '../..');
const BASE_SITE_URL = 'https://docs.lucee.org';
const BASE_RECIPES_URL = `${BASE_SITE_URL}/recipes/`;
const BASE_RAW_URL = 'https://raw.githubusercontent.com/lucee/lucee-docs/master/';

// Topic files are written to /skill in the repo and published to https://docs.lucee.org/skill/
const SKILL_NAME = 'lucee';
const SKILL_DIR = path.join(REPO_ROOT, 'skill');
const SKILL_BASE_URL = `${BASE_SITE_URL}/skill/`;
const ROUTER_URL = `${BASE_SITE_URL}/lucee.skill`;
const ROUTER_TOKEN_WARN = 4000;
const KEYWORD_LIMIT = 8;

const TECHNICAL_SPECS = [
  { topic: 'AI — `createAISession`, `inquiryAISession`, multipart, RAG, MCP passthrough', file: 'docs/recipes/ai.md' },
  { topic: 'AST/Parser — `astFromPath`, `astFromString`, node types, ESTree', file: 'docs/technical-specs/ast.yaml' },
  { topic: 'Startup Hooks — `.CFConfig.json`, class loading, lifecycle, OSGi/Maven', file: 'docs/technical-specs/hooks.yaml' },
  { topic: 'JSR-223 — `ScriptEngineFactory`, engine names, MIME types, CLI, Ant', file: 'docs/technical-specs/java-scripting.yaml' },
  { topic: 'Monitors — action/request/interval, `ActionMonitorCollector`, `getMonitorData()`', file: 'docs/technical-specs/monitors.yaml' },
  { topic: 'Maven extensions — migrating an extension from OSGi bundles to Maven', file: 'docs/technical-specs/maven-extension-migration.yaml' },
  { topic: 'LuCLI — CLI tool, `lucee.json`, server lifecycle, modules, secrets, deps', file: 'docs/technical-specs/lucli-spec.md' },
];

// Topics, in the order they appear in the router. Recipe topics are filled from recipe categories,
// "guides" holds the long-form guides and "examples-specs" the runnable examples and technical specs.
const TOPICS = [
  { id: 'ai', title: 'AI', when: 'AI sessions and engines, RAG, MCP, AI serialisation, using Lucee docs with AI assistants' },
  { id: 'upgrade', title: 'Upgrading', when: 'Breaking changes per version, migration guides, compatibility flags, release cycle' },
  { id: 'database', title: 'Database', when: 'Datasources, JDBC drivers, queries, query of queries, query listeners, connection pooling' },
  { id: 'orm', title: 'ORM', when: 'Hibernate ORM: setup, entity mapping, relationships, sessions, transactions, troubleshooting' },
  { id: 'caching', title: 'Caching', when: 'Cache connections, cachedWithin, query cache invalidation, cache extensions' },
  { id: 'debugging', title: 'Debugging & logging', when: 'Debugging, monitoring, logging, exceptions, heap and thread dumps, step debugger, dev tooling' },
  { id: 'java', title: 'Java', when: 'Calling Java, Maven dependencies, Java libraries, casting, proxies, data formats via Java' },
  { id: 'extensions', title: 'Extensions', when: 'Installing, building and configuring extensions, scheduler (Quartz), hooks' },
  { id: 'integrations', title: 'Protocols & integrations', when: 'Mail, HTTP, REST, S3 and virtual file systems, websockets, event gateways, XML, PDF, search' },
  { id: 'server', title: 'Server & configuration', when: 'Configuration (.CFConfig.json), env vars, mappings, Docker, deployment, security hardening, startup' },
  { id: 'language', title: 'CFML language', when: 'Syntax, components, scopes, null handling, dates, threads, regex, Application.cfc' },
  { id: 'guides', title: 'Guides', when: 'Long-form guides: installing, updating, deploying, extensions, Lucee 5 era docs, release notes' },
  { id: 'examples-specs', title: 'Examples & technical specs', when: 'Runnable Docker examples and technical specs (AST, hooks, JSR-223, monitors, LuCLI)' },
];

// Recipe categories mapped to topics. The first category (in this priority order) that has a mapping wins.
const CATEGORY_TOPIC_PRIORITY = [
  ['ai', 'ai'],
  ['orm', 'orm'],
  ['breaking changes', 'upgrade'],
  ['migration', 'upgrade'],
  ['cache', 'caching'],
  ['database', 'database'],
  ['query', 'database'],
  ['debugging', 'debugging'],
  ['monitoring', 'debugging'],
  ['troubleshooting', 'debugging'],
  ['instrumentation', 'debugging'],
  ['logging', 'debugging'],
  ['memory', 'debugging'],
  ['testing', 'debugging'],
  ['tooling', 'debugging'],
  ['analysis', 'debugging'],
  ['event-gateways', 'integrations'],
  ['protocols', 'integrations'],
  ['http', 'integrations'],
  ['rest', 'integrations'],
  ['websocket', 'integrations'],
  ['s3', 'integrations'],
  ['vfs', 'integrations'],
  ['object-storage', 'integrations'],
  ['cloud', 'integrations'],
  ['xml', 'integrations'],
  ['pdf', 'integrations'],
  ['search', 'integrations'],
  ['extensions', 'extensions'],
  ['extension', 'extensions'],
  ['java', 'java'],
  ['maven', 'java'],
  ['jsr223', 'java'],
  ['interop', 'java'],
  ['data-processing', 'java'],
  ['server', 'server'],
  ['devops', 'server'],
  ['configuration', 'server'],
  ['docker', 'server'],
  ['system', 'server'],
  ['startup', 'server'],
  ['security', 'server'],
  ['session', 'server'],
  ['compat', 'upgrade'],
  ['versioning', 'upgrade'],
  ['core', 'language'],
  ['component', 'language'],
  ['components', 'language'],
  ['application', 'language'],
  ['scopes', 'language'],
  ['variables', 'language'],
  ['static', 'language'],
  ['flow-control', 'language'],
  ['decision', 'language'],
  ['iterator', 'language'],
  ['struct', 'language'],
  ['thread', 'language'],
  ['regex', 'language'],
  ['datetime', 'language'],
  ['date', 'language'],
  ['time', 'language'],
  ['formatting', 'language'],
  ['localization', 'language'],
  ['math', 'language'],
  ['number', 'language'],
  ['files', 'language'],
  ['tags', 'language'],
  ['crypto', 'language'],
  ['objects', 'language'],
  ['scripting', 'language'],
  ['parsing', 'language'],
  ['development', 'language'],
];

// Categories that carry no topic signal on their own.
const IGNORED_CATEGORIES = new Set([
  'performance', 'best-practices', 'recipes', 'lucee', 'documentation', 'integration',
  'state-management', 'aws', 'dynamodb', 'mssql',
]);

// Explicit per-recipe topic overrides for recipes whose categories sort them into the wrong topic.
const RECIPE_TOPIC_OVERRIDES = {
  'cfml-keywords': 'language', // "tooling" category, but it is a language reference
  'ast': 'language', // AST functions are part of the language
  'retry': 'language', // retry in catch blocks is a language feature
  'new-operator': 'language', // "java" category, but it is about the CFML new operator
  'component-accessors': 'language',
  'concurrent-map-legacy-flag': 'upgrade', // compatibility flag for upgrades
  'release-cycle': 'upgrade',
  'upgrade-7-1-to-8-0-agent': 'upgrade', // upgrade guide that happens to use an AI agent
  'session-handling': 'server', // session storage configuration, not caching
  'language-server': 'debugging', // IDE tooling
  'logging': 'debugging',
  'log-files': 'debugging',
  'console-logging': 'debugging',
};

const CATEGORY_TOPIC = new Map(CATEGORY_TOPIC_PRIORITY);
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
  await validateSpecs();

  let readmeContent = '# Recipes\n\n';
  for (const recipe of recipes) {
    readmeContent += `## [${recipe.title}](/docs/recipes/${recipe.file})\n\n${recipe.description}\n\n`;
  }

  console.log(`Writing index to ${outputPath}`);
  await fs.writeJson(
    outputPath,
    recipes.map(({ description, since, categories, ...entry }) => entry),
    { spaces: 2 }
  );

  console.log(`Writing README to ${readmePath}`);
  await fs.writeFile(readmePath, readmeContent.trim(), 'utf-8');

  const topicFiles = buildTopicFiles({ recipes, guides, examples });

  await fs.ensureDir(SKILL_DIR);
  for (const file of await fs.readdir(SKILL_DIR)) {
    if (file.endsWith('.md') && !topicFiles.some((t) => `${t.id}.md` === file)) {
      console.log(`Removing stale topic file skill/${file}`);
      await fs.remove(path.join(SKILL_DIR, file));
    }
  }
  for (const topic of topicFiles) {
    await fs.writeFile(path.join(SKILL_DIR, `${topic.id}.md`), topic.content, 'utf-8');
  }

  const router = generateRouter(topicFiles);
  console.log(`Writing skill router to ${skillPath}`);
  await fs.writeFile(skillPath, router, 'utf-8');

  const manifest = generateManifest(router, topicFiles);
  await fs.writeJson(path.join(SKILL_DIR, 'skills.json'), manifest, { spaces: 2 });

  const routerTokens = estimateTokens(router);
  console.log(`Skill router: ${router.split('\n').length} lines, ~${routerTokens} tokens`);
  if (routerTokens > ROUTER_TOKEN_WARN) {
    console.warn(`WARNING: skill router is ~${routerTokens} tokens (limit ~${ROUTER_TOKEN_WARN}); keep it small, move detail into topic files`);
  }
  for (const topic of topicFiles) {
    console.log(`  skill/${topic.id}.md: ${topic.entries} entries, ~${estimateTokens(topic.content)} tokens`);
  }

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
    let categories = [];
    let since = '';
    if (metadataMatch) {
      const metadata = JSON.parse(metadataMatch[1]);
      if (metadata.description) description = metadata.description;
      if (metadata.keywords) keywords = metadata.keywords;
      if (metadata.categories) categories = metadata.categories;
      if (metadata.since) since = String(metadata.since);
    }

    index.push({
      file,
      title,
      path: `/docs/recipes/${file}`,
      hash,
      keywords,
      description,
      since,
      categories,
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
    const sectionDir = path.relative(guidesDir, filePath).split(path.sep)[0];

    guides.push({
      title,
      id,
      sitePath,
      section: sectionDir,
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

async function validateSpecs() {
  const missing = [];
  for (const spec of TECHNICAL_SPECS) {
    if (!(await fs.pathExists(path.join(REPO_ROOT, spec.file)))) {
      missing.push(spec.file);
    }
  }
  if (missing.length) {
    throw new Error(`Technical spec files listed in TECHNICAL_SPECS do not exist: ${missing.join(', ')}`);
  }
}

function recipeId(recipe) {
  return recipe.file.replace(/\.md$/, '');
}

function topicForRecipe(recipe) {
  const id = recipeId(recipe);
  if (RECIPE_TOPIC_OVERRIDES[id]) {
    return RECIPE_TOPIC_OVERRIDES[id];
  }
  const categories = recipe.categories.map((c) => String(c).toLowerCase());
  for (const [category, topic] of CATEGORY_TOPIC_PRIORITY) {
    if (categories.includes(category)) {
      return topic;
    }
  }
  return null;
}

function buildTopicFiles({ recipes, guides, examples }) {
  const topicIds = new Set(TOPICS.map((t) => t.id));
  for (const topic of Object.values(RECIPE_TOPIC_OVERRIDES)) {
    if (!topicIds.has(topic)) {
      throw new Error(`RECIPE_TOPIC_OVERRIDES uses unknown topic "${topic}"`);
    }
  }
  for (const topic of CATEGORY_TOPIC.values()) {
    if (!topicIds.has(topic)) {
      throw new Error(`CATEGORY_TOPIC_PRIORITY uses unknown topic "${topic}"`);
    }
  }

  const unknownCategories = new Set();
  const unmapped = [];
  const byTopic = {};
  for (const recipe of recipes) {
    for (const category of recipe.categories) {
      const key = String(category).toLowerCase();
      if (!CATEGORY_TOPIC.has(key) && !IGNORED_CATEGORIES.has(key)) {
        unknownCategories.add(key);
      }
    }
    const topic = topicForRecipe(recipe);
    if (!topic) {
      unmapped.push(`${recipeId(recipe)} (categories: ${JSON.stringify(recipe.categories)})`);
      continue;
    }
    (byTopic[topic] = byTopic[topic] || []).push(recipe);
  }

  if (unknownCategories.size) {
    console.warn(`WARNING: recipe categories with no topic mapping: ${[...unknownCategories].sort().join(', ')}`);
  }
  if (unmapped.length) {
    throw new Error(
      'These recipes map to no skill topic. Add a known category to the recipe metadata, '
      + `or extend CATEGORY_TOPIC_PRIORITY / RECIPE_TOPIC_OVERRIDES in ${path.basename(__filename)}:\n  `
      + unmapped.join('\n  ')
    );
  }

  return TOPICS.map((topic) => {
    let body;
    let entries;
    if (topic.id === 'guides') {
      body = generateGuidesBody(guides);
      entries = guides.length;
    } else if (topic.id === 'examples-specs') {
      body = generateExamplesSpecsBody(examples);
      entries = examples.length + TECHNICAL_SPECS.length;
    } else {
      const list = byTopic[topic.id] || [];
      if (!list.length) {
        throw new Error(`Skill topic "${topic.id}" has no recipes`);
      }
      body = generateRecipeTopicBody(list);
      entries = list.length;
    }
    const content = `# Lucee skill: ${topic.title}\n\n${topic.when}.\n\n${body}`;
    return { ...topic, entries, content, url: `${SKILL_BASE_URL}${topic.id}.md` };
  });
}

function cell(value) {
  return String(value || '').replace(/\r?\n/g, ' ').replace(/\|/g, '\\|').trim();
}

function formatKeywords(keywords, limit = KEYWORD_LIMIT) {
  return cell((keywords || []).slice(0, limit).join(', '));
}

function generateRecipeTopicBody(recipes) {
  const rows = recipes
    .map((r) => `| \`${recipeId(r)}\` | ${cell(r.title)} | ${cell(r.description)} | ${cell(r.since) || '-'} | ${formatKeywords(r.keywords)} |`)
    .join('\n');
  return `Fetch a recipe with \`${BASE_RECIPES_URL}<id>.md\`. "Since" is the first Lucee version with the feature.

| ID | Title | Description | Since | Keywords |
|----|-------|-------------|-------|----------|
${rows}
`;
}

function generateGuidesBody(guides) {
  const sections = {};
  for (const guide of guides) {
    // pages directly in docs/04.guides belong to the overview section
    const section = guide.section.endsWith('.md') ? '' : guide.section;
    (sections[section] = sections[section] || []).push(guide);
  }
  const withKeywords = guides.some((g) => g.keywords && g.keywords.length);
  const parts = Object.keys(sections)
    .sort()
    .map((section) => {
      const list = sections[section].sort((a, b) => a.sitePath.localeCompare(b.sitePath));
      // the shortest path in a section is its chapter page, use its title as the heading
      const heading = section ? list[0].title : 'Overview';
      const rows = list
        .map((g) => withKeywords
          ? `| ${cell(g.title)} | \`${g.sitePath}\` | ${formatKeywords(g.keywords)} |`
          : `| ${cell(g.title)} | \`${g.sitePath}\` |`)
        .join('\n');
      const header = withKeywords
        ? '| Title | Path | Keywords |\n|-------|------|----------|'
        : '| Title | Path |\n|-------|------|';
      return `## ${cell(heading)}

${header}
${rows}
`;
    });
  return `Fetch a guide with \`${BASE_SITE_URL}<path>.md\`, e.g. \`${BASE_SITE_URL}/guides/getting-started/first-steps.md\`. Prefer a recipe when one covers the same subject, as some guides (notably the Lucee 5 section) are older.

${parts.join('\n')}`;
}

function generateExamplesSpecsBody(examples) {
  const exampleRows = examples
    .map((e) => `| ${cell(e.title)} | \`${e.id}\` | \`${e.fetchUrl}\` |`)
    .join('\n');
  const specRows = TECHNICAL_SPECS
    .map((spec) => `| ${spec.topic} | \`${BASE_RAW_URL}${spec.file}\` |`)
    .join('\n');
  return `## Examples

Runnable examples, fetched from the lucee-docs GitHub repository.

| Title | ID | URL |
|-------|----|-----|
${exampleRows}

## Technical specs

Implementation details, class names and API signatures.

| Topic | URL |
|-------|-----|
${specRows}
`;
}

function generateRouter(topicFiles) {
  const topicRows = topicFiles
    .map((t) => `| \`${t.id}\` | ${t.when} | ${t.entries} | \`${t.url}\` |`)
    .join('\n');

  return `---
name: ${SKILL_NAME}
description: >
  Lucee CFML documentation router: recipes, guides, examples and technical specs for configuration,
  datasources, ORM, caching, extensions, AI, Java integration, upgrading and the CFML language.
  Use this skill whenever the user asks anything about Lucee or CFML. Load the matching topic
  index, then fetch the doc before answering — never guess at Lucee-specific behaviour.
  For tags and functions use the Lucee MCP server.
---

# Lucee

## Rules

1. Never guess at Lucee-specific behaviour, settings or signatures. Fetch the doc first, then answer from it.
2. Tags, functions and full-text doc search: use the Lucee MCP server (\`https://mcp.lucee-services.com/\`) when it is available. Without it, fetch \`${BASE_SITE_URL}/reference/functions/<name>.md\` or \`${BASE_SITE_URL}/reference/tags/<name>.md\` (lower case, tags without the \`cf\` prefix).
3. Everything else: pick one or more topics below, fetch the topic index, choose the matching entries by ID, title, description and keywords, then fetch those docs.
4. Check the "Since" column against the Lucee version the user runs.
5. Cross-cutting questions often need two topics (e.g. \`server\` + \`examples-specs\` for a Docker setup).
6. If a fetch fails, say so and mark the answer as unverified.

## Fetch URLs

- Topic index: \`${SKILL_BASE_URL}<topic>.md\`
- Recipe: \`${BASE_RECIPES_URL}<id>.md\`
- Guide: \`${BASE_SITE_URL}<path>.md\` (path has a leading slash, e.g. \`/guides/getting-started/first-steps\`)
- Examples and technical specs: the URL listed in the \`examples-specs\` index

## Topics

| Topic | Use for | Entries | Index |
|-------|---------|---------|-------|
${topicRows}
`;
}

function generateManifest(router, topicFiles) {
  return {
    name: SKILL_NAME,
    router: {
      url: ROUTER_URL,
      sha256: sha256(router),
      approxTokens: estimateTokens(router),
    },
    topics: topicFiles.map((t) => ({
      id: t.id,
      title: t.title,
      description: t.when,
      url: t.url,
      path: `skill/${t.id}.md`,
      entries: t.entries,
      sha256: sha256(t.content),
      approxTokens: estimateTokens(t.content),
    })),
  };
}

function sha256(content) {
  return crypto.createHash('sha256').update(content).digest('hex');
}

// Rough token estimate (about 4 characters per token for English markdown).
function estimateTokens(content) {
  return Math.ceil(content.length / 4);
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

generateIndex().catch((err) => {
  console.error('Error generating index, README and skill:', err.message || err);
  process.exit(1);
});
