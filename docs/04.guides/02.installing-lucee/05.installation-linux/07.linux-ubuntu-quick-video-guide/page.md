---
title: 'Installing Lucee on Ubuntu 20.04 LTS Server Apache2 - Video Guide'
id: linux-ubuntu-quick-video-guide
description: A video tutorial about installing Lucee on a clean Ubuntu 20.04 LTS Server and connecting Lucee to Apache2 web server
---

### Installing Lucee on Ubuntu 20.04 LTS Server Apache2 - Video Guide ###

This is a quick video tutorial about installing Lucee on a clean Ubuntu 20.04 LTS Server and connecting Lucee to Apache2 web server with reverse proxy and cfml_mod from a remote Windows 10 machine. It makes heavy use of Ubuntu GUI applications with SSH X11 Forwarding and Ubuntu's lightweight display manager lightdm from desktop interface xfce4. It was created with the goal to keep it as simple, self-explaining and descriptive as possible, thus the GUI step by step approach. The starting position of the video guide is a clean Ubuntu 20.04 LTS Server with OpenSSH pre-installed.

<br>
### Step 1: Adding Required Ubuntu Packages ###
This video explains how to add required packages needed to install/administrate/run Lucee and Ubuntu 20.04 LTS applications from a remote Windows 10 computer.

[![Watch the video](http://i3.ytimg.com/vi/Hk9mbHWFGvQ/0.jpg)](https://youtu.be/Hk9mbHWFGvQ)

#### Commands used ####

```

$ sudo apt update
$ sudo apt install xfce4
$ sudo systemctl disable lightdm.service
$ sudo apt install apache2
$ sudo apt install gufw
$ sudo apt install firefox
$ sudo apt install mousepad

```

<br>
### Step 2 - Setting Up SSH X11 Forwarding ###
This video shows how to connect using Putty SSH and X-Server (VcXsrv) to your Ubuntu 20.04 LTS Server with the goal to administrate your server and Lucee over a secure forwared SSH tunnel. This is done in such a manner that you can remotely launch Linux GUI applications with root privileges on the remote server from your development machine.

[![Watch the video](http://i3.ytimg.com/vi/mUsaqdLmWAc/0.jpg)](https://youtu.be/mUsaqdLmWAc)

#### Snippet used for Putty SSH Command at 1:33 ####

```

sudo xauth add $(xauth -f ~YourSudoUsername/.Xauthority list|tail -1); /bin/bash

```

#### Commands used ####

```

$ sudo thunar
$ sudo mousepad /etc/sshd/sshd_config

```

<br>
### Step 3: Setting Up The Firewall With 'gufw' ###
This video guides how to enable linux "Uncomplicated Firewall" with its GUI gufw and add rules for allowing SSH (port 22) and Apache2 HTTP/HTTPS (port 80/443) service only. This will prevent unwanted public access to Tomcat service ports. Warning: Changing firewall settings could lock you out from your server. As prevention you should create a snapshot/image of your server OS before changing the settings.

[![Watch the video](http://i3.ytimg.com/vi/cLaSyyzeuRY/0.jpg)](https://youtu.be/cLaSyyzeuRY)

#### Commands used ####

```
$ sudo gufw
```

<br>
### Step 4: Installing Lucee With Linux (64b) Installer ###
This video shows how to install Lucee with the Linux (64b) installer that ships AdoptOpenJDK (Java JDK), Tomcat and mod_cfml

[![Watch the video](http://i3.ytimg.com/vi/qTsOd3h0H1M/0.jpg)](https://youtu.be/qTsOd3h0H1M)

#### Commands used ###

```

$ wget <paste download-link to linux lucee installer from http://download.lucee.org here>
$ sudo thunar

```

<br>
### Step 5: Give Lucee Access To Apache2 Webroots ###
This video explains how to add write permissions for Tomcat/Lucee service to access Apache2 webroots. It also shows why and when the *"500 error can't create directory WEB-INF"'* can occur.

[![Watch the video](http://i3.ytimg.com/vi/-Te2d0EWaAY/0.jpg)](https://youtu.be/-Te2d0EWaAY)

#### Commands used ####

```

$ sudo thunar

```

<br>
### Step 6: Blocking Lucee Admin From Public Access ###
This video shows how to block "Lucee Server/Web Administrator" from being accessed from remote/public internet

[![Watch the video](http://i3.ytimg.com/vi/Y4zKiOSqFGw/0.jpg)](https://youtu.be/Y4zKiOSqFGw)

#### Snippet used at 1:30 ####

```

<Location /lucee/admin>
	Order deny,allow
	Deny from all
</Location>
```

#### Commands used ####

```

$ sudo systemctl reload apache2

```

<br>
### Step 7: Administrate Lucee With SSH X11 Forwarding ###
This video guides how to run Firefox tunneled with SSH, accessing your Lucee Administrator Pages directly through Tomcat's port 8888 from your development machine.

[![Watch the video](http://i3.ytimg.com/vi/j4q8UThLo2Y/0.jpg)](https://youtu.be/j4q8UThLo2Y)

#### Commands used ####

```

$ firefox

```

<br>
### Step 8: Enhancing Tomcat's And Apache2's Security ###
This video explains how to increase security by changing Apache2's directives `<Directory>` for index listings, `ServerSignature` and `ServerToken`. It also shows how to disable Tomcat' AJP service that isn't needed when using reverse proxy and how to deactivate the shutdown command for port 8005. In the last section the video shows how to move Tomcat's default `WEB-INF` context folders outside their respective webroots.

[![Watch the video](http://i3.ytimg.com/vi/ryph6IeZRB4/0.jpg)](https://youtu.be/ryph6IeZRB4)

#### Commands used ####

```

$ sudo thunar
$ sudo systemctl reload apache2
$ sudo lsof -i 6
$ sudo /opt/lucee/lucee_ctl restart

```

[See all videos as a playlist](https://www.youtube.com/playlist?list=PLk5a6z4LgytWw41VjPn6MNCVkYY62_yZC)
