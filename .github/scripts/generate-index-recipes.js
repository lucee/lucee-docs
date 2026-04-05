const fs = require('fs-extra');
const path = require('path');
const crypto = require('crypto');

const BASE_DOCS_URL = 'https://docs.lucee.org/recipes/';
const BASE_RAW_URL = 'https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/';

const TECHNICAL_SPECS = [
  { topic: 'AI — `createAISession`, `inquiryAISession`, multipart, RAG, MCP passthrough', file: 'recipes/ai.md' },
  { topic: 'AST/Parser — `astFromPath`, `astFromString`, node types, ESTree', file: 'technical-specs/ast.yaml' },
  { topic: 'Startup Hooks — `.CFConfig.json`, class loading, lifecycle, OSGi/Maven', file: 'technical-specs/startup-hooks.yaml' },
  { topic: 'JSR-223 — `ScriptEngineFactory`, engine names, MIME types, CLI, Ant', file: 'technical-specs/jsr223.yaml' },
  { topic: 'Monitors — action/request/interval, `ActionMonitorCollector`, `getMonitorData()`', file: 'technical-specs/monitors.yaml' },
  { topic: 'LuCLI — CLI tool, `lucee.json`, server lifecycle, modules, secrets, deps', file: 'technical-specs/lucli-spec.md' },
];

async function generateIndex() {
  const recipesDir = path.join(__dirname, '../../docs/recipes');
  const outputPath = path.join(recipesDir, 'index.json');
  const readmePath = path.join(recipesDir, 'README.md');
  const skillPath = path.join(recipesDir, 'lucee.skill');

  const files = await fs.readdir(recipesDir);
  const index = [];
  let readmeContent = '# Recipes\n\n';

  console.log('Generating index, README and skill...');
  console.log(`Reading files from ${recipesDir}`);

  for (const file of files) {
    if (file.endsWith('.md') && file !== 'README.md') {
      console.log(`Processing file: ${file}`);
      const filePath = path.join(recipesDir, file);
      const content = await fs.readFile(filePath, 'utf-8');
      const titleMatch = content.match(/^#\s+(.+)$/m);
      const title = titleMatch ? titleMatch[1] : 'Untitled';
      const hash = crypto.createHash('md5').update(content).digest('hex');

      // Extract metadata from the comment block
      const metadataMatch = content.match(/<!--\s*({[^]*?})\s*-->/);
      let description = 'No description available.';
      let keywords = [];
      if (metadataMatch) {
        const metadata = JSON.parse(metadataMatch[1]);
        if (metadata.description) description = metadata.description;
        if (metadata.keywords) keywords = metadata.keywords;
      }

      index.push({
        file: file,
        title: title,
        path: `/docs/recipes/${file}`,
        hash: hash,
        keywords: keywords
      });

      readmeContent += `## [${title}](/docs/recipes/${file})\n\n${description}\n\n`;
    }
  }

  console.log(`Writing index to ${outputPath}`);
  await fs.writeJson(outputPath, index, { spaces: 2 });

  console.log(`Writing README to ${readmePath}`);
  await fs.writeFile(readmePath, readmeContent.trim(), 'utf-8');

  console.log(`Writing skill to ${skillPath}`);
  await fs.writeFile(skillPath, generateSkill(index), 'utf-8');

  const readmeExists = await fs.pathExists(readmePath);
  console.log(`README exists: ${readmeExists}`);
  console.log('Index, README and skill generation complete.');
}

function generateSkill(recipes) {
  // Build recipe index table — title | id (filename without .md) | keywords
  const recipeRows = recipes
    .map(r => {
      const id = r.file.replace(/\.md$/, '');
      const kw = (r.keywords || []).slice(0, 6).join(', '); // cap keywords for readability
      return `| ${r.title} | \`${id}\` | ${kw} |`;
    })
    .join('\n');

  // Build keyword → id lookup for the quick-load hint
  const keywordMap = {};
  for (const r of recipes) {
    const id = r.file.replace(/\.md$/, '');
    for (const kw of (r.keywords || [])) {
      const k = kw.toLowerCase();
      if (!keywordMap[k]) keywordMap[k] = [];
      keywordMap[k].push(id);
    }
  }

  // Build technical specs table
  const specRows = TECHNICAL_SPECS
    .map(s => `| ${s.topic} | \`${BASE_RAW_URL}${s.file}\` |`)
    .join('\n');

  return `---
name: lucee-docs
description: >
  Complete Lucee CFML documentation covering recipes, guides, configuration, tags, functions,
  extensions, AI integration, Docker, datasources, caching, logging, mappings, startup hooks,
  and all Lucee features. Use this skill whenever the user asks anything about Lucee or CFML —
  how to configure it, how a feature works, what a tag or function does, how to upgrade, or
  any Lucee-specific behavior. Fetch the relevant doc(s) on demand — never guess at
  Lucee-specific behavior; always read the source first.
---

# Lucee Documentation

## How to use this skill

1. Identify the relevant recipe ID(s) from the index below using title and keywords
2. Fetch the doc: \`${BASE_DOCS_URL}<id>.md\`
3. For internals (class names, signatures, constants), use the Technical Specs table instead
4. Answer from fetched content — do not guess at Lucee-specific details

## Recipe Index

| Title | ID | Keywords |
|-------|-----|----------|
${recipeRows}

## Technical Specs

For implementation details, class names, and API signatures fetch directly:

| Topic | URL |
|-------|-----|
${specRows}

## Notes

- Recipe docs are fetched live from \`${BASE_DOCS_URL}\` — always current
- Technical specs are fetched live from the lucee-docs GitHub repo
- If a fetch fails, fall back to answering from training knowledge and note uncertainty
- Multiple docs can be fetched for cross-cutting questions (e.g. configuration + datasources)
`;
}

generateIndex().catch(err => {
  console.error('Error generating index, README and skill:', err);
  process.exit(1);
});
