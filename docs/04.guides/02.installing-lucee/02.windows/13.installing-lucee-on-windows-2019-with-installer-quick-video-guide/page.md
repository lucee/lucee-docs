---
title: Installing Lucee on a clean Windows 2019 Datacenter with installer
id: running-lucee-installing-lucee-on-windows-2019-with-installer-quick-video-guide
---

## Installing Lucee on a clean Windows 2019 Datacenter with installer (Video Guide)

This is a quick video tutorial about installing Lucee on a clean Windows 2019 Server Datacenter and connecting it to IIS 10 with boncode connector and cfml_mod. It also guides through resolving a common **500 status code error** *"can't create directory WEB-INF"*, caused by the tomcat service not having the corresponding file permissions (security by default).

[Step 1 - Adding the IIS Role and Features](https://youtu.be/kTilVJgN1_o) - This video explains how to add IIS Roles and Features, a prerequisite for installing Lucee in such a manner that it can connect with IIS Webserver

[Step 2 - Installing Lucee](https://youtu.be/PyTEMywl2fk) - This video shows how to install Lucee with the installer that ships AdoptOpenJDK (Java JDK), Tomcat 9, Boncode Connector and mod_cfml

[Step 3: Removing unwanted Handler Mappings](https://youtu.be/Y4zSlRMbqnk) - This video guides how to remove Handler Mappings that have been added automatically during "IIS Feature" installation by Windows Server 2019, enhancing security

[Step 4: Grant Lucee access to IIS webroots](https://youtu.be/08mf_g6ci5A) - This video explains how to add write permissions for Tomcat/Lucee service to access IIS webroots. It also shows why and when the "500 error can't create directory WEB-INF" can occur

[Step 5: Block Public Access To Lucee's Server/Web Admins](https://youtu.be/wt4Y6uAPbc0) - This video shows how to block your "Lucee's Server/Web Administration" from being accessed from the public internet with "BonCode Connector" (at 1:13) and "IIS Request Filtering" (at 2:49).

[See the Video Guide series as a playlist](https://www.youtube.com/playlist?list=PLk5a6z4LgytUZw9gJX0n7QGt8__GLBAnf)
