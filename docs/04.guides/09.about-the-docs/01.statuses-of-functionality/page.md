---
title: Statuses of functionality
id: about-the-docs-statuses-of-functionality
---

In Lucee functionality (tags, functions and objects) are considered to have one of the following statuses. It is important to understand the difference between the statuses and the terminology that Lucee use to describe these states so that you can understand when best to and not to use particular functionality.

## Regular ##
The “regular” status is not actually flagged against the functionality, so this is any tag, function or object that doesn't have a flag against it. “Regular” functionality is considered to  be a core part of the language and is acceptable to use in all situations.

It is possible that at some point “regular” functionality becomes “deprecated” functionality and this change would be communicated to the community with prior notice and explanation before hand.

It is not possible for “regular” functionality to become “hidden” functionality without first being “deprecated” functionality for sometime, see below.

## Deprecated ##
The “deprecated” status can be flagged against functionality that is considered by Lucee to be no longer suitable to use and Lucee would discouraged you from using it, typically because it is dangerous or because a better alternative exists.

Tags, functions and objects flagged with the “deprecated” flag can be seen in the built in documentation (/lucee/doc.cfm) with a message reading “This [type] is deprecated”, for example see the “cfgraph” on your copy of Lucee.

It is possible that “deprecated” functionality becomes "hidden" functionality, in a future version, if **ALL** of the following criteria are met:

1. The functionality is no longer supported by other CFML engines.
1. The functionality is no longer widely adopted by the community.
1. There are alternatives to achieve the same functionality with other methods.

Any change from “deprecated” to "hidden" would be communicated to the community with prior notice and explanation before hand.

## Hidden ##
"Hidden" functionality are features not visible in any documentation of Lucee. There is some “hidden” functionality in Lucee that is used for internal processes but “deprecated” functionality (see above) can also be given this status if it meets the criteria.

“Hidden” functionality can be removed or change at anytime without any communication to the community. Lucee high recommends **not** using any “hidden” functionality.
