---
title: Lucee Documentation
reference: 'false'
description: 'Lucee Server Documentation #cfml #coldfusion #lucee'
---

Welcome to the Official [Lucee Server](https://lucee.org) Documentation

---

Lucee is a [high performance](https://community.ortussolutions.com/t/how-does-cfml-really-perform-compared-to-other-languages/9325), [open source](https://github.com/lucee/Lucee), ColdFusion / CFML server engine, written in Java.

The documentation here aims to provide a thorough reference and guide to all things to do with the Lucee Server. This includes reference material on both [[functions]] and [[tags]] as well as more in-depth articles in the [[guides]] section.

Our documentation is an open source and community driven effort. It is also a constant work in progress and we always welcome feedback, improvements and suggestions. You can find out more about contributing to the Documentation in the [[about]] section.

To find out more about getting involved as a developer with Lucee, checkout our [Git Repo](https://github.com/lucee/Lucee/blob/6.0/CONTRIBUTING.md)

## Recipes 

We have added a whole series of detailed [[Recipes]] showing you how to take advantage of the wide range of features in Lucee.

## Deploying Lucee

[[deploying-lucee-server-apps]] - How to configure and deploy Lucee 

[[locking-down-lucee-server]] - Security best practices for Lucee

[[config]] - All about Lucee's configuration file

## Lucee 6.2

**New!** Lucee 6.2 is our latest stable release, with enhanced Java and Maven integration, Jakarta Servlet support and better runtime performance.

Lucee 6.2 up to 50% faster than Lucee 5.4, while using less memory.

Our Official Docker images and Installers for 6.2 all bundle Tomcat 10.1 and Java 21. This may cause issues with the switch to the Jakarta namespace, Lucee 6.2 supports both, but anything which integrates with Tomcat (i.e. urlrewrite) will need updating, see the [Jakarta](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20%22jakarta%22) issues in our bug tracker.

[Lucee 6.2 ChangeLog](https://download.lucee.org/changelog/?version=6.2)

[[breaking-changes-6-1-to-6-2]]

## Lucee 6.1

Targeting better performance and reduced memory usage, Lucee 6.1 introduces full support for Java 17 and 21, as well as Java 11.
Java 8 is no longer officially supported.

[[breaking-changes-6-0-to-6-1]]

## Lucee 6.0

[Lucee 6](https://dev.lucee.org/tag/lucee-6) .

Highlights include, reduced size, faster startup, single context mode, JSON based configuration and much more.

As a Major Release, Lucee 6 does include some potential **BREAKING CHANGES**, for a range of security reasons and better compatibility with Adobe ColdFusion, they are all documented in Jira under an Epic, [All Breaking changes in Lucee 6](https://luceeserver.atlassian.net/browse/LDEV-4534)

## Lucee 5.4 (LTS)

Lucee 5.4 is our [LTS stable release](https://lucee.org/downloads.html) and is recommended for production systems. More details are available in the [Lucee 5](/guides/lucee-5.html) section of these docs.

Only Java 8 and 11 are supported, there are various changes in Java 21 including date time handling which are not addressed in 5.4, time to upgrade!

As a LTS release, Lucee 5.4 will receive security updates and critical regression fixes until 2026, **but is no longer actively maintained.**

## Getting help

- Our mailing list / forum is over at [https://dev.lucee.org/](https://dev.lucee.org/)
- [[tutorial-reporting-bugs]]

## Lucee 5.3

Lucee 5.3 (and older) now is no longer actively developed. It's time to upgrade to 5.4 LTS or 6 (recommended)

## Lucee 4.5

Lucee 4.5 is the [legacy stable release](https://lucee.org/downloads.html) of the Lucee platform. It is End of Life (EOL) and no longer supported.

## Java API Docs

The Java API documentation of Lucee Server's loader interfaces, are published at [https://www.javadoc.io/doc/org.lucee/lucee/latest/index.html](https://www.javadoc.io/doc/org.lucee/lucee/latest/index.html).

## Lucee on YouTube

We also have a channel on YouTube where you can find further tutorials and tips: [Lucee YouTube Channel](https://www.youtube.com/channel/UCdsCTvG8-gKUu4zA309EZYA)
