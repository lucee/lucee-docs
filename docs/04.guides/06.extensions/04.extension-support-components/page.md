---
title: Extensions Support Components
id: extensions-support-components
---

### Support components ###

Lucee offers a couple of components that can be extended in the install.cfc. They help to make some usual things like creating a mapping or unpack a zip file very easy. There are some CFCs that practically do the complete installation process for you, which means that you only have to configure some things. More information and downloads of the CFC‘s can be found here (under construction). At the moment there exist only two of these support components. The number of these components will grow over time and therefore we will not describe these components here. Instead of this documentation please check this documentation for details.

### Tips and tricks ###

### Installed applications ###

The loaded extensions (the installed ones) can be found in the directory /yourwebroot/WEB-INF/lucee/extension. The directory structure under this folder reflects the extension provider, the application and the version of the extension you have installed. You can use any ZIP-program in order to inspect the installed extensions.

### Application list, update and caching ###

The available applications listed in the extension manager are not downloaded every time. The list is cached by Lucee depending on the mode of the extension provider. Two modes are possible: develop or production. In case the mode of the extension provider is set to "develop" the list of the application is downloaded every time the "extensions" menu in the Lucee Administrator is clicked. The list is only cached in the request scope. If on the other hand the mode is set to "production" the list is only loaded once per session. So the list is cached in the session scope of the user.