---
title: Class Updating
id: lucee-5-class-updating
---

#Class updating#
**Previously an optional feature in Lucee 4, class updating is now an integral part of Lucee 5. Lucee 5 is able to update existing classes and this has a huge impact on memory consumption, especially in environments where a lot of CFML templates are used.**

With Lucee 4 a "java-agent" had to be defined to enable this feature work. Lucee 4 also had to have a fallback to handle the situation if the "java-agent" was not defined.

Lucee 5 can now dynamically load the "java-agent" at runtime and because of this the fallback is no longer necessary. In turn this has had a huge impact on the whole class handling process in the Lucee core. This allows for the overall memory footprint used to handle classes to be reduced significantly.
