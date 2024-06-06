# Recipes

## [Externalize strings](/docs/recipes/Externalizing_Strings.md)

Externalize strings from generated class files to separate files. This method is used to reduce the memory of the static contents for templates.

## [The good, the bad and the ugly](/docs/recipes/QOQ_Sucks.md)

This document explains why Query of Queries (QoQ) may or may not be the best approach for your use case.

## [Event Handling in Application.cfc](/docs/recipes/application-context-basic.md)

An overview of event handling functions in Application.cfc for Lucee.

## [Event Handling in Application.cfc](/docs/recipes/application-context-set-mapping.md)

An overview of event handling functions in Application.cfc for Lucee.

## [Update Application Context](/docs/recipes/application-context-update.md)

How to update your Application settings, after they have been defined in Application.cfc.

## [Output the current date](/docs/recipes/basic-date.md)

Learn how to output the current date in Lucee.

## [List existing Cache Connections](/docs/recipes/cache-list.md)

List existing Cache Connections available in Lucee.

## [Cache a Query for the current request](/docs/recipes/cached-within-request.md)

Cache a Query for the current request in Lucee.

## [Adding Caches via Application.cfc](/docs/recipes/caches-in-application-cfc.md)

How to add per-application caches via Application.cfc in Lucee.

## [Convert a CFML Function/Component to use in Java](/docs/recipes/cfml-to-java.md)

Learn how to convert user-defined functions or components in Lucee to use them in Java. This guide demonstrates how to define components to implement Java interfaces, pass components to Java methods, explicitly define interfaces, and use the onMissingMethod feature. It also shows how to convert user-defined functions to Java lambdas.

## [Check for changes in your configuration file automatically](/docs/recipes/check-for-changes.md)

Automatically check for changes in your configuration file with Lucee.

## [Checksum](/docs/recipes/checksum.md)

This document explains how to use a checksum in Lucee.

## [Configure Lucee within your application](/docs/recipes/configuration-administrator-cfc.md)

How to configure Lucee within your application using Administrator.cfc and cfadmin tag.

## [How to define a Datasource](/docs/recipes/datasource-define-datasource.md)

How to define a Datasource in Lucee.

## [Creating and deploying Lucee Archives (.lar files)](/docs/recipes/deploy-archives.md)

This document explains how to deploy an Application on a live server without using a single CFML file.

## [Encryption/Decryption ](/docs/recipes/encryption_decryption.md)

This document explains about Encryption/Decryption with public and private keys with simple examples.

## [Custom Event Gateways](/docs/recipes/event-gateway-create.md)

Here you will find a short introduction into writing your own Event Gateway type.

## [How does an Event Gateway work?](/docs/recipes/event-gateways-overview.md)

Overview of how Event Gateways work in Lucee.

## [Lucee Event Gateways](/docs/recipes/event-gateways.md)

EG's are another way how to communicate with your Lucee server and are kind of a service running on Lucee, reacting on certain events.

## [Exception - Cause](/docs/recipes/exception-cause.md)

Lucee 6.1 improves its support for exception causes, providing better debugging and error handling capabilities.

## [Output Exceptions](/docs/recipes/exception-output.md)

How to catch and display exceptions.

## [File Extensions](/docs/recipes/file-extensions.md)

Learn about the different file extensions supported by Lucee, including .cfm, .cfc, .cfml, and .cfs. This guide provides examples for each type of file.

## [How to define a regular Mapping](/docs/recipes/filesystem-mapping-define-mapping.md)

All about the different mappings in Lucee and how to use them.

## [File system - Mappings](/docs/recipes/filesystem-mapping.md)

Overview of different mapping types in the file system.

## [Flying Saucer PDF Engine - CFDOCUMENT](/docs/recipes/flying_saucer.md)

The new CFDOCUMENT PDF engine, Flying Saucer in Lucee 5.3

## [Function Listener](/docs/recipes/function-listeners.md)

This document explains how to use a function listeners in Lucee.

## [Untitled](/docs/recipes/gateways-overview.md)

Overview of how Event Gateways work in Lucee.

## [Global Proxy](/docs/recipes/global-proxy.md)

Learn how to define a global proxy in Lucee. This guide demonstrates how to set up a global proxy in the Application.cfc file, limit the proxy to specific hosts, and exclude specific hosts from using the proxy.

## [Hidden Gems](/docs/recipes/hidden_gems.md)

This document explains how to declare variables, function calls with dot and bracket notation, and passing arguments via URL/form scopes as an array.

## [Inline Component](/docs/recipes/inline-components.md)

Learn how to create and use inline components in Lucee. This guide demonstrates how to define components directly within your CFML code, making it easier to create and use components without needing a separate .cfc file. Examples include creating an inline component and using it similarly to closures.

## [Java in Functions and Closures](/docs/recipes/java-in-functions.md)

Learn how to write CFML code directly in a function or a closure with Java types in Lucee. This guide demonstrates how to define functions and components with Java types, and how to use Java lambda functions within Lucee. You will see examples of how to handle exceptions, define return types, and implement functional Java interfaces (Lambdas) seamlessly.

## [Loop Labels](/docs/recipes/labels.md)

No description available.

## [Untitled](/docs/recipes/lazy_queries.md)

How to use lazy queries

## [Untitled](/docs/recipes/loop_through_files.md)

This document explains how to handle big files in Lucee in a better way.

## [Mail Listeners](/docs/recipes/mail-listener.md)

Learn how to define mail listeners in Lucee. This guide demonstrates how to set up global mail listeners in the Application.cfc file to listen to or manipulate every mail executed. Examples include defining listeners directly in Application.cfc and using a component as a mail listener.

## [Untitled](/docs/recipes/mail-send.md)

How to send an email using Lucee wth help of the tag cfmail.

## [Mathematical Precision](/docs/recipes/mathematical-precision.md)

Learn about the switch from double to BigDecimal in Lucee 6 for more precise mathematical operations. This guide provides information on how to change the default behavior if needed.

## [Monitoring/Debugging](/docs/recipes/monitoring.md)

Learn about the changes in Lucee 6.1 regarding Monitoring and Debugging. Understand the old and new behavior, and how to configure the settings in Lucee Admin and Application.cfc.

## [Untitled](/docs/recipes/null_support.md)

This document explains how to set null support in the Lucee server admin, assigning `null` value for a variable and how to use `null` and `nullvalue`.

## [Untitled](/docs/recipes/precompiled-code.md)

How to pre-compile code for a production server while the source code is deployed to avoid compilation on the production server for security reasons.

## [Query Async](/docs/recipes/query-async.md)

Learn how to execute queries asynchronously in Lucee. This guide demonstrates how to set up asynchronous query execution using a simple flag. Examples include defining async execution for queries and using local listeners to handle exceptions. Additionally, function listeners introduced in Lucee 6.1 can be used for this purpose.

## [Untitled](/docs/recipes/query-handling.md)

How to do SQL Queries with Lucee.

## [Query Indexes](/docs/recipes/query-indexes.md)

Learn how to set and use indexes for query results in Lucee. This guide demonstrates how to define a query with an index and access parts of the query using the index.

## [Query Listeners](/docs/recipes/query-listener.md)

Learn how to define query listeners in Lucee. This guide demonstrates how to set up global query listeners in the Application.cfc file to listen to or manipulate every query executed. Examples include defining listeners directly in Application.cfc and using a component as a query listener.

## [Untitled](/docs/recipes/query-of-queries.md)

Query of queries (QoQ) is a technique for re-querying an existing (in memory) query without another trip to the database.

## [Untitled](/docs/recipes/query_return_type.md)

This document explains the different return types for a query with some examples.

## [Request Timeout](/docs/recipes/request-timeout.md)

Learn how to use request timeout correctly with Lucee.

## [Untitled](/docs/recipes/retry.md)

This document explains how to use retry functionality with some simple examples.

## [Untitled](/docs/recipes/s3.md)

Using S3 directly for source code

## [Untitled](/docs/recipes/sax.md)

Lucee not only allows you to convert an XML file to an object tree (DOM) but also supports an event-driven model (SAX).

## [Script Templates](/docs/recipes/script-templates.md)

Learn about script templates in Lucee. This guide explains how Lucee supports templates with the `.cfs` extension, allowing you to write direct script code without the need for the `<cfscript>` tag.

## [Environment Variables / System Properties for Lucee](/docs/recipes/settings.md)

This document gives you an overview over all Environment Variables an System Properties you can set for Lucee.

## [Untitled](/docs/recipes/startup-listeners-code.md)

Lucee supports two types of Startup Listeners, server.cfc and web.cfc

## [Untitled](/docs/recipes/static_scope.md)

Static scope in components is needed to create an instance of cfc and call its method.

## [Sub Component](/docs/recipes/sub-components.md)

Learn how to create and use sub components in Lucee. This guide demonstrates how to define additional components within a .cfc file, making it easier to organize related components. Examples include creating a main component with sub components, and how to address/load these sub components.

## [Untitled](/docs/recipes/supercharge-your-website.md)

This document explains how you can improve the performance of your website in a very short time with Lucee.

## [Function SystemOutput #](/docs/recipes/systemoutput_function.md)

This document explains the systemoutput function with some simple examples.

## [Untitled](/docs/recipes/thread_task.md)

How to use Thread Tasks

## [Untitled](/docs/recipes/thread_usage.md)

How to use threads in Lucee

## [Timeout](/docs/recipes/timeout.md)

Learn how to use the <cftimeout> tag in Lucee. This guide demonstrates how to define a timeout specific to a code block, handle timeouts with a listener, and handle errors within the timeout block.

## [Types in Lucee](/docs/recipes/types_lucee.md)

This document explains types in Lucee. Lucee is still an untyped language. Types are only a check put on top of the language.

## [Virtual File Systems](/docs/recipes/virtual-file-system.md)

Lucee supports the following virtual file systems: ram, file, s3, http, https, zip, and tar.

## [Untitled](/docs/recipes/xml_fast-easy.md)

This document explains how to use XML parsing in Lucee.

