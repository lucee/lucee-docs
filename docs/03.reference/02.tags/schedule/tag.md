---
title: <cfschedule>
id: tag-schedule
categories:
- server
- devops
---

Provides a programmatic interface to the scheduling engine.

You can run a specified page at scheduled intervals with the option to write out static HTML pages.

This lets you offer users access to pages that publish data, such as reports, without forcing users to wait while a database transaction
is performed in order to populate the data on the page.

> **Lucee 7 Note:** The traditional Scheduled Task system has been moved to the [Scheduler Classic](https://download.lucee.org/#97EB5427-F051-4684-91EBA6DBB5C5203F) extension.
> It is installed by default in the full distribution, but not in `-light` images.
> If `<cfschedule>` is not available, install the extension via the Lucee Administrator or by deploying the `.lex` file.
> Alternatively, consider the new [[scheduler-quartz]] extension which provides clustering support and cron expressions.

[[cfschedule-bulk]]
