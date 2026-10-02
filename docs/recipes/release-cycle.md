<!--
{
  "title": "Lucee Release Cycle and Branching",
  "id": "release-cycle",
  "categories": ["development", "versioning", "server", "devops"],
  "description": "How Lucee versions and branches work: minor-line branches, release cycles, RC branches, which branch a fix belongs on, merging forward and Jira fix versions",
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
    "fix version"
  ],
  "related": ["versions"]
}
-->

# Lucee Release Cycle and Branching

This recipe describes how Lucee versions are numbered, how the branches of [lucee/Lucee](https://github.com/lucee/Lucee) are organised, which branch a fix belongs on, and how fixes move between branches.

## Version Numbers

A Lucee version has four parts, `MAJOR.MINOR.PATCH.BUILD`, plus an optional suffix.

Example: `7.1.1.15-SNAPSHOT`

| Part | Example | Meaning |
|------|---------|---------|
| `MAJOR.MINOR` | `7.1` | The minor line. Also the name of the line's branch. |
| `PATCH` | `1` | The cycle within the line. `7.1.1` is one cycle. |
| `BUILD` | `15` | The build number. Resets to `0` when a new cycle starts. |

| Suffix | Meaning | Example |
|--------|---------|---------|
| `-SNAPSHOT` | Development build | `7.1.1.15-SNAPSHOT` |
| `-RC` | Release candidate | `7.0.6.9-RC` |
| `-BETA` / `-ALPHA` | Beta / alpha build | `7.1.0.202-BETA`, `7.1.0.0-ALPHA` |
| none | Final release | `7.1.0.204` |

The current version of a branch is the `<version>` in its `loader/pom.xml`.

The version is bumped when a fix lands. Changes that only touch tests never bump the version.

When a new cycle starts, `BUILD` resets to `0`. For example, `7.0` moved to `7.0.7.0-SNAPSHOT` and `6.2` to `6.2.10.0-SNAPSHOT`.

## Branches

### Minor Branches

Each minor line has its own branch, named `MAJOR.MINOR`: for example `6.2`, `7.0`, `7.1` and `8.0`. `8.0` is the development line.

Each line works in cycles. A patch version such as `7.1.1` is one cycle. The minor branch holds the line's current cycle as a `-SNAPSHOT` version.

### Release (RC) Branches

When a cycle moves to RC, a release branch named after the patch version is created from the minor branch at that point in history:

- `7.0.6` was created from `7.0`
- `7.1.1` will be created from `7.1`

The minor branch then starts the next cycle with a new `-SNAPSHOT` version. For example, after `7.0.6` was branched off, `7.0` moved on to `7.0.7.0-SNAPSHOT`.

Existing release branches include `7.0.0` to `7.0.6`, `7.1.0` and `6.2.9`.

### Example Layout

The branches and `loader/pom.xml` versions on 2 October 2026:

| Branch | Type | `loader/pom.xml` version |
|--------|------|--------------------------|
| `8.0` | minor branch (development line) | `8.0.0.195-SNAPSHOT` |
| `7.1` | minor branch, cycle `7.1.1` | `7.1.1.15-SNAPSHOT` |
| `7.1.0` | release branch | `7.1.0.204` |
| `7.0` | minor branch, cycle `7.0.7` | `7.0.7.0-SNAPSHOT` |
| `7.0.6` | release branch, in RC | `7.0.6.9-RC` |
| `7.0.5` | release branch | `7.0.5.41` |
| `6.2` | minor branch, cycle `6.2.10` | `6.2.10.0-SNAPSHOT` |
| `6.2.9` | release branch, in RC | `6.2.9.4-RC` |

This changes with every cycle. To see the current state:

```bash
# list all branches
git ls-remote --heads https://github.com/lucee/Lucee

# show the version of a branch (here 7.1)
gh api "repos/lucee/Lucee/contents/loader/pom.xml?ref=7.1" -q .content | base64 -d | grep -m1 "<version>"
```

## Which Branch Does a Fix Go To?

A **regression** is something that worked in the previous final release of a line and broke afterwards.

While an RC/release branch is unreleased, it only takes fixes for regressions introduced since the last final release of its line:

| Release branch | Only takes regressions introduced since |
|----------------|-----------------------------------------|
| `7.1.1` (once created) | `7.1.0` final |
| `7.0.6` | `7.0.5` final |
| `6.2.9` | the last `6.2` final (`6.2.8`) |

Everything else goes into the minor branch (for example `7.1`), for the next cycle:

- new bugs
- older bugs, which already existed in the last final release
- enhancements
- extension updates that are not regression fixes

New bug fixes go only into the minor branch, never into the RC branch.

### Worked Example: Cycles 7.1.1 and 7.1.2

The minor branch always takes every fix for its current cycle. The only exception is a regression introduced since the last final release while that line's RC is still unreleased: that fix goes to the RC branch.

1. **`7.1.1` is in RC, `7.1` has started cycle `7.1.2`.** A regression introduced between `7.1.0` final and `7.1.1` goes to `7.1.1`. Every other fix goes to `7.1`.
2. **`7.1.1` is released, no `7.1.2` RC yet.** Every fix goes to `7.1`, regressions included. `7.1.1` gets no further updates once released.
3. **The first `7.1.2` RC is made.** The branch `7.1.2` is created from `7.1`, and `7.1` starts cycle `7.1.3`. A regression introduced between `7.1.1` final and `7.1.2` goes to `7.1.2`. Every other fix goes to `7.1`.

## After a Release

Once a release is done, its release branch gets no further updates. Fixes go into the next cycle of the line, on the minor branch.

Example: once `7.1.1` is released, branch `7.1.1` gets no further updates. Fixes go into `7.1`, for the next cycle `7.1.2`.

## Merging Forward

Regression fixes are made on the RC/release branch and then merged forward:

1. The release branch is merged into its minor branch, e.g. `7.1.1` into `7.1`, `7.0.6` into `7.0`.
2. Lower lines are merged into higher lines: `7.0` into `7.1`, `7.1` into `8.0`.

```text
7.0.6 --> 7.0 --> 7.1 --> 8.0
                   ^
          7.1.1 ---+
```

The maintainer does these merges.

Lines are merged forward only while a merge link between them is kept. Currently linked: `7.0` into `7.1` into `8.0`, plus each release branch into its minor branch. `6.2` used to be merged into `7.0`, the same way `7.1` is merged into `8.0` now, but that link was dropped. Once a link is dropped, a fix needed on both lines has to be made separately on each branch, with its own pull request per line. For example, a fix for both `6.2` and `7.0` needs one pull request for `6.2` and one for `7.0`.

## Pull Requests

- Within a linked chain (see [Merging Forward](#merging-forward)), open **one** pull request, containing the fix and its test.
- Target the **lowest affected branch** of that chain only. For a regression that an unreleased RC/release branch takes (see above), that is the RC/release branch, for anything else the minor branch.
- Never open duplicate pull requests for the same fix against several branches of a linked chain. The maintainer merges the fix forward.
- Lines that are not linked need their own pull request each, e.g. one for `6.2` and one for `7.0`.

## Jira Fix Versions

The fix versions on a Jira ticket are, for each branch the fix landed on, the version in that branch's `loader/pom.xml` at the point the fix first landed there.

Example: [LDEV-6490](https://luceeserver.atlassian.net/browse/LDEV-6490), a 7.0 regression, was fixed on `7.0.6` and merged forward into `7.1` and `8.0`. Its fix versions are `7.0.6.9`, `7.1.1.13` and `8.0.0.194`.
