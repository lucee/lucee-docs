<!--
{
  "title": "Lucee Release Cycle",
  "id": "release-cycle",
  "categories": ["development", "versioning"],
  "description": "Documentation for Lucee's release branching and versioning strategy",
  "keywords": [
    "release",
    "versioning",
    "branching",
    "development cycle",
    "release candidate",
    "RC"
  ],
  "related": []
}
-->

# Lucee Release Cycle

This document describes Lucee's release branching strategy and version numbering conventions.

## Overview

Lucee uses a release branching model that allows active development to continue on the main branch while stabilization and release preparation happen in parallel on dedicated release branches.

## Version Numbering

Lucee uses a four-part version number during development: `MAJOR.MINOR.PATCH.BUILD-SNAPSHOT`

Example: `7.0.1.52-SNAPSHOT`

- **MAJOR.MINOR** (7.0): The active development branch
- **PATCH** (1): The patch version being prepared
- **BUILD** (52): Automatically incremented with each commit
- **SNAPSHOT**: Indicates pre-release development version

The build number has no special meaning—it simply increments with every commit to track the exact state of the branch.

## Active Development Branch

At any given time, there is one **active branch** where ongoing development occurs.

**For example:** Branch `7.0` with version `7.0.1.52-SNAPSHOT`

All new features, improvements, and non-critical fixes are committed to this branch during active development.

## Creating a Release

When the team decides to prepare a release candidate, the following process occurs:

### Step 1: Create Release Branch

A new release branch is created as a clone of the active branch:

```bash
# Clone active branch to new release branch
git checkout 7.0
git checkout -b 7.0.1
```

The release branch is named after the patch version being released (e.g., `7.0.1`).

### Step 2: Bump Active Branch Version

The active branch immediately moves to the next patch cycle:

```bash
# On branch 7.0
# Version changes from 7.0.1.52-SNAPSHOT to 7.0.2.0-SNAPSHOT
```

Development continues uninterrupted on the `7.0` branch with the new version number.

### Step 3: Stabilize Release Branch

The release branch (`7.0.1`) enters stabilization phase:

1. Create release candidates: `7.0.1-rc1`, `7.0.1-rc2`, etc.
2. Perform testing and bug fixes
3. Create final release: `7.0.1`

## Branch Lifecycle

A release branch follows this lifecycle:

### Active Phase

**Duration:** From branch creation until the release is published

**Activities:**

- Regression testing
- Security fixes
- Bug fixes for the upcoming release
- Creating release candidates

**Merge policy:** All changes made to the release branch are merged back into the active branch (`7.0`)

### Maintenance Phase

**Duration:** From release publication until the next patch version is released

**Activities:**

- Urgent security fixes only

**Example:** Branch `7.0.1` enters maintenance phase when version `7.0.1` is released, and remains in maintenance until version `7.0.2` is released.

### End of Life

**Trigger:** When the next patch version is released

**Example:** Branch `7.0.1` reaches end of life when `7.0.2` is released.

## Merge-Back Strategy

**Critical Rule:** Any change committed to a release branch **must** be merged back into the active branch.

This ensures that bug fixes and security patches are not lost in future releases.

```bash
# Example: Merge changes from release branch to active branch
git checkout 7.0
git merge 7.0.1
```

This merge-back happens continuously throughout the release branch's active phase and for any security fixes during maintenance phase.

## Example Timeline

Here's a complete example of the release cycle in action:

1. **Development Phase**
   - Branch: `7.0`
   - Version: `7.0.1.52-SNAPSHOT`
   - Activity: Active feature development

2. **Release Branch Created**
   - New branch: `7.0.1` (cloned from `7.0`)
   - Active branch: `7.0` continues with version `7.0.2.0-SNAPSHOT`

3. **Release Candidate Phase**
   - Branch `7.0.1`: Creates `7.0.1-rc1`, `7.0.1-rc2`
   - Branch `7.0`: Development continues
   - All fixes in `7.0.1` are merged to `7.0`

4. **Release Published**
   - Branch `7.0.1`: Version `7.0.1` released
   - Branch `7.0.1`: Now in maintenance mode (security fixes only)
   - Branch `7.0`: Continues active development

5. **Next Release Cycle Begins**
   - New branch: `7.0.2` (cloned from `7.0`)
   - Active branch: `7.0` continues with version `7.0.3.0-SNAPSHOT`
   - Branch `7.0.1`: Reaches end of life

## Benefits

**Development Continuity:** Feature development never stops—the active branch continues while releases are stabilized in parallel.

**Isolation:** Release stabilization work doesn't interfere with ongoing feature development.

**Clear Merge Path:** Bug fixes always flow from release branches back to the active branch, preventing regressions.

**Parallel Releases:** Multiple release branches can exist simultaneously at different stages.

## Best Practices

### For Committers

- Always merge release branch changes back to the active branch promptly
- Test merged changes on the active branch to ensure compatibility
- Document any conflicts encountered during merge-back

### For Release Managers

- Clearly communicate when a release branch is created
- Monitor that all commits to release branches are merged back
- Archive release branches only after the next patch version is released

### For Users

- Use snapshot versions from the active branch for testing upcoming features
- Use release candidates for pre-production validation
- Use official releases for production deployments