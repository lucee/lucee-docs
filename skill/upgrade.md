# Lucee skill: Upgrading

Breaking changes per version, migration guides, compatibility flags, release cycle.

Fetch a recipe with `https://docs.lucee.org/recipes/<id>.md`. "Since" is the first Lucee version with the feature.

| ID | Title | Description | Since | Keywords |
|----|-------|-------------|-------|----------|
| `breaking-changes-6-0` | Breaking Changes between Lucee 5.4 and 6.0 | A guide to breaking changes introduced in Lucee between version 5.4 and 6.0 | - | breaking changes, Lucee 5.4, Lucee 6.0, migration, upgrade |
| `breaking-changes-6-1` | Breaking Changes between Lucee 6.0 and 6.1 | A guide to breaking changes introduced in Lucee between version 6.0 and 6.1 | - | breaking changes, Lucee 6.0, Lucee 6.1, migration, upgrade |
| `breaking-changes-6-2` | Breaking Changes between Lucee 6.1 and 6.2 | A guide to breaking changes introduced in Lucee between version 6.1 and 6.2 | - | breaking changes, Lucee 6.1, Lucee 6.2, migration, upgrade |
| `breaking-changes-7-0` | Breaking Changes between Lucee 6.2 and 7.0 | A guide to breaking changes introduced in Lucee between version 6.2 and 7.0 | - | breaking changes, Lucee 6.2, Lucee 7.0, migration, upgrade |
| `breaking-changes-7-1` | Breaking Changes between Lucee 7.0 and 7.1 | A guide to breaking changes introduced in Lucee between version 7.0 and 7.1 | - | breaking changes, Lucee 7.0, Lucee 7.1, migration, upgrade |
| `breaking-changes-8-0` | Breaking Changes between Lucee 7.1 and 8.0 | A guide to breaking changes introduced in Lucee between version 7.1 and 8.0 | - | breaking changes, Lucee 7.1, Lucee 8.0, migration, upgrade, CFConfig |
| `breaking-changes-9-0` | Breaking Changes between Lucee 8.0 and 9.0 | A guide to breaking changes introduced in Lucee between version 8.0 and 9.0 | - | breaking changes, Lucee 8.0, Lucee 9.0, migration, upgrade, OSGi, Felix, ASM |
| `concurrent-map-legacy-flag` | Diagnosing struct iteration-order regressions on 7.1 with `lucee.concurrent.map.impl=legacy` | The `lucee.concurrent.map.impl=legacy` flag temporarily restores the pre-7.1 struct iteration order, used as a diagnostic to confirm whether a 7.1 regression is an ordering-assumption bug in your code. | 7.1.0.105 | ConcurrentHashMap, struct, lucee.concurrent.map.impl, legacy, struct ordering, LDEV-5098, LDEV-6288 |
| `lucee-5-to-6-migration-guide` | Lucee 5 to 6 Migration Guide | Comprehensive guide for migrating from Lucee 5 to Lucee 6, addressing breaking changes and compatibility issues | 6.0 | Migration, Lucee 5, Lucee 6, Breaking Changes, Compatibility, DeserializeJSON, Query Parameters, Precise Math |
| `release-cycle` | Lucee Release Cycle and Branching | Lucee branching and release strategy: one branch per version line, which branch a pull request targets (fixes, breaking fixes, features, security), merge-ups, versions and qualifiers, RC branches and Jira fix versions | - | release, versioning, branching, development cycle, release candidate, RC, SNAPSHOT, regression |
| `migrate.from.classic-to-modern-local-scope` | Migrating from Classic to Modern Local Scope Mode | Guide for safely migrating your Lucee application from classic to modern local scope mode | - | local scope, variables, migration, scope mode, classic mode, modern mode |
| `regex-migration-lucee-9` | Regex Migration to Lucee 9 | Lucee 9 uses the Java regex engine by default and moves the Perl5 (Apache ORO) engine into the Perl Regex extension. What changes, how to migrate your patterns, and how to stay on perl. | 9.0 | regex, regular expressions, Lucee 9, migration, Apache ORO, perl, java, compat |
| `upgrade-7-1-to-8-0-agent` | Upgrade Lucee 7.1 to 8.0: Checklist for AI Coding Agents | Step-by-step, machine-friendly checklist for AI coding agents upgrading an application or server from Lucee 7.1 to 8.0: what to search for, what to change, how to verify, and what to leave alone. | - | upgrade, migration, Lucee 8.0, Lucee 7.1, AI agent, LLM, checklist, CFConfig |
