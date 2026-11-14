<!--
{
  "title": "Lucee Release Cycle and Branching",
  "id": "release-cycle",
  "categories": ["development", "versioning", "server", "devops"],
  "description": "Lucee branching and release strategy: one branch per version line, which branch a pull request targets (fixes, breaking fixes, features, security), merge-ups, versions and qualifiers, RC branches and Jira fix versions",
  "keywords": [
    "release",
    "versioning",
    "branching",
    "development cycle",
    "release candidate",
    "RC",
    "SNAPSHOT",
    "regression",
    "pull request",
    "merge forward",
    "fix version",
    "contributing",
    "which branch",
    "pull request target",
    "breaking change",
    "extensions release"
  ],
  "related": ["versions"]
}
-->

# Lucee Release Cycle and Branching

This recipe describes how Lucee is branched and released: which branch your pull request goes to, how changes move between branches, and how versions are numbered. It covers [lucee/Lucee](https://github.com/lucee/Lucee), with a short section on extensions.

## Version Lines and Branches

Lucee has one long-lived branch per version line, named `MAJOR.MINOR`:

| Branch | Role |
|--------|------|
| `7.1` | The default target. Bug fixes go here. |
| `8.0` | Fixes that are breaking changes. No new features. |
| `9.0` | All new features. Currently built as `-ALPHA`. |
| `7.0`, `6.2` | Older lines. They only get a change when the team asks for one, and security fixes are also backported to `6.2`. |

Next to these, short-lived release branches named after a patch version (for example `7.1.2`) are used for release candidates, see [Release (RC) Branches](#release-rc-branches).

Never send a pull request to `master`. Run `git ls-remote --heads https://github.com/lucee/Lucee` to see the current branches.

## Where Does My Pull Request Go?

| Your change | Target branch |
|-------------|---------------|
| Bug fix | `7.1` |
| Fix that changes existing behaviour in a way that can break applications (a breaking change) | `8.0` |
| New feature or enhancement | `9.0` |
| Security fix | The branch above, and it is also backported to `6.2` |

Notes:

- `8.0` never gets new features.
- Where a bug was introduced is not a reason to target an older line. Changes are not backported to `6.2`, `7.0` or release branches such as `7.1.2` unless the team asks for it.
- The team can decide differently for a single ticket. The Jira ticket or the pull request will say so.
- If you are unsure, target `7.1` and ask in the pull request. The team will tell you.

### Merge-Ups

Changes flow upwards through merge pull requests done by the team:

```text
7.1 --> 8.0 --> 9.0
```

You only open **one** pull request, against the lowest branch that applies. Do not open duplicates for `8.0` or `9.0`, a fix on `7.1` reaches them through the merge-up. `6.2` and `7.0` are not part of this chain.

### Pull Request Checklist

- One pull request per [LDEV ticket](https://luceeserver.atlassian.net/browse/LDEV). Create the ticket first if there is none.
- Put the ticket key in the pull request title and in every commit message, for example `LDEV-1234 Fix NPE in cfquery with empty params`.
- Add or update tests. See [[working-with-source-build-from-source]] for how to build Lucee and run the tests.
- If the change affects documented behaviour, send a pull request to [lucee-docs](https://github.com/lucee/lucee-docs) as well.

See also [CONTRIBUTING.md](https://github.com/lucee/Lucee/blob/7.1/CONTRIBUTING.md) in the repository.

## Version Numbers

A Lucee version has four parts, `MAJOR.MINOR.PATCH.BUILD`, plus an optional qualifier.

Example: `7.1.2.189-SNAPSHOT`

| Part | Example | Meaning |
|------|---------|---------|
| `MAJOR.MINOR` | `7.1` | The version line. Also the name of the line's branch. |
| `PATCH` | `2` | The cycle within the line. `7.1.2` is one cycle. |
| `BUILD` | `189` | The build number. Starts at `0` when a new cycle starts. |

| Qualifier | Meaning | Example |
|-----------|---------|---------|
| `-SNAPSHOT` | Development build | `7.1.2.189-SNAPSHOT` |
| `-ALPHA` / `-BETA` | Early builds of a line, `9.0` is currently `-ALPHA` | `9.0.0.279-ALPHA` |
| `-RC` | Release candidate | `7.0.6.9-RC` |
| none | Final release | `7.1.0.204` |

### How Versions Are Computed

In `loader/pom.xml` of the `7.1`, `8.0` and `9.0` branches the version is `${revision}`, a [CI-friendly version](https://maven.apache.org/guides/mini/guide-maven-ci-friendly.html), built from three properties:

```xml
<lucee.version.base>7.1.3</lucee.version.base>
<lucee.version.build>0</lucee.version.build>
<lucee.version.qualifier>-SNAPSHOT</lucee.version.qualifier>
```

The build number is not edited by hand. When the GitHub Action publishes a build, it takes the highest existing build number for the current `lucee.version.base` (from the git tags, or from the published Maven metadata if there are no tags yet), adds one, and uses `base.build` plus the qualifier as the version of that build.

On `7.1`:

- Every push publishes a `-SNAPSHOT` build.
- A release candidate or a final release is published by running the workflow manually, with `deploy` ticked and the qualifier set to `RC` or `release` (the options are `SNAPSHOT`, `BETA`, `RC` and `release`).
- Pull requests only build and run the tests, they never publish.

Changes that only touch tests do not need a version bump. The `lucee.version.base` of a branch only changes when a new cycle starts, for example from `7.1.2` to `7.1.3` once the `7.1.2` release candidate was branched off.

### From Snapshot to Final

A change goes through these stages:

1. **SNAPSHOT**: every merged pull request produces a new snapshot build.
2. **RC**: when a cycle is ready, a release candidate is built. It is then soaked for about 10 days, so it can be tested before it is final. During that time only regression fixes go into it, see below.
3. **Final**: after the soak period the final version is released, without a qualifier.

Only final versions are meant for production use. Release candidates and snapshots are published for testing.

### Current State

Properties in `loader/pom.xml` on 29 October 2026:

| Branch | `lucee.version.base` | `lucee.version.qualifier` |
|--------|----------------------|---------------------------|
| `9.0` | `9.0.0` | `-ALPHA` |
| `8.0` | `8.0.1` | `-SNAPSHOT` |
| `7.1` | `7.1.3` | `-SNAPSHOT` |

`7.0` and `6.2` still use the version directly in the pom (`7.0.7.3-SNAPSHOT` and `6.2.10.0-SNAPSHOT` on that date).

This changes with every cycle. To see the current state:

```bash
# list all branches
git ls-remote --heads https://github.com/lucee/Lucee

# show the version properties of a branch (here 7.1)
gh api "repos/lucee/Lucee/contents/loader/pom.xml?ref=7.1" -q .content | base64 -d | grep "lucee.version"
```

## Release (RC) Branches

When a cycle moves to RC, a release branch named after the patch version is created from the version line's branch at that point in history, for example `7.1.2` from `7.1`. The version line's branch then starts the next cycle (`7.1.3`).

A release branch only exists to stabilise one release candidate. See the next section for what goes into it.

## Regressions in a Release Candidate

A **regression** is something that worked in the previous final release of a line and broke afterwards.

While an RC/release branch is unreleased, it only takes fixes for regressions introduced since the last final release of its line:

For example, release branch `7.1.1` only takes regressions introduced since `7.1.0` final.

Everything else goes into the version line's branch (for example `7.1`), for the next cycle:

- new bugs
- older bugs, which already existed in the last final release
- enhancements
- extension updates that are not regression fixes

New bug fixes go only into the version line's branch, never into the RC branch. This is the only exception to the [target branch table](#where-does-my-pull-request-go), and the team will tell you if it applies to your change.

### Worked Example: Cycles 7.1.1 and 7.1.2

The minor branch always takes every fix for its current cycle. The only exception is a regression introduced since the last final release while that line's RC is still unreleased: that fix goes to the RC branch.

1. **`7.1.1` is in RC, `7.1` has started cycle `7.1.2`.** A regression introduced between `7.1.0` final and `7.1.1` goes to `7.1.1`. Every other fix goes to `7.1`.
2. **`7.1.1` is released, no `7.1.2` RC yet.** Every fix goes to `7.1`, regressions included. `7.1.1` gets no further updates once released.
3. **The first `7.1.2` RC is made.** The branch `7.1.2` is created from `7.1`, and `7.1` starts cycle `7.1.3`. A regression introduced between `7.1.1` final and `7.1.2` goes to `7.1.2`. Every other fix goes to `7.1`.

## After a Release

Once a release is done, its release branch gets no further updates. Fixes go into the next cycle of the line, on the minor branch.

Example: once `7.1.1` is released, branch `7.1.1` gets no further updates. Fixes go into `7.1`, for the next cycle `7.1.2`.

## Merging Forward

The team merges changes upwards, so they reach every line that needs them:

1. A release branch is merged into its version line, for example `7.1.1` into `7.1`.
2. `7.1` is merged into `8.0`, and `8.0` into `9.0`.

```text
7.1.1 --> 7.1 --> 8.0 --> 9.0
```

Merge-ups are pull requests like any other, so CI has to pass before they are merged. Contributors do not open them.

Changes that only belong in `8.0` or `9.0` (breaking fixes, new features) are made on that branch and merged up from there. `6.2` and `7.0` are not merged forward: a change that is needed on one of them is made there with its own pull request, and only when the team asks for it.

## Jira Fix Versions

The fix versions on a Jira ticket are, for each branch the fix landed on, the version in that branch's `loader/pom.xml` at the point the fix first landed there.

Example: [LDEV-6490](https://luceeserver.atlassian.net/browse/LDEV-6490), a 7.0 regression, was fixed on `7.0.6` and merged forward into `7.1` and `8.0`. Its fix versions are `7.0.6.9`, `7.1.1.13` and `8.0.0.194`.

## Extensions

Extensions follow the same idea. Extensions that use the standard release action, like [extension-redis](https://github.com/lucee/extension-redis), publish a `-SNAPSHOT` build with an automatically incremented build number on every push to the default branch. A manual run of the action with `deploy` ticked publishes the build you pick with the qualifier option (`SNAPSHOT`, `RC` or `release`, among others). See [[maven-based-extensions]] for how to build an extension.
