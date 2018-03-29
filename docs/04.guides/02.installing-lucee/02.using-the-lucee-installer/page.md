---
title: Using the Lucee Installer
id: using-the-lucee-installer
---

### Consider a Non-Standard Installation Directory ###

The standard installation directory for Lucee is /opt/lucee/. If an attacker knows this they can craft attacks based off that information. For example, attacks which use parent directory traversal mechanisms, such as "../../opt/lucee/" in the URL's. A non-standard installation directory will simply make your server less vulnerable to customized attacks. Maybe something unpredictable like "/lucee-02-21-72/" or "/opt/cfml/server/luceerocks/"

The down side of this is that documentation is often written with the defaults in mind, and many examples are based on the defaults. As a reader, you will be required to interpolate the default documentation for your own specific environment.

### Be Creative With Your Lucee System User ###

It is far more difficult to brute-force a username and password combination if an attacker has no idea where to begin with a username. To that end, be creative when you pick a username for your new Lucee installation. Do not use obvious usernames such as "admin" or "lucee", but still keep it recognizable and memorable. For example, you could call your new Lucee user "theflash", after the speedy superhero character. You know... because he "runs fast".

### Consider Using a Phrase as a Password ###

Using phrases as passwords is not a new idea, but it is possible to do with Lucee and is a proven method for addressing brute-force password break-ins as well as makes it easy to remember a specific "password". For example, consider the following pass-phrase:

	W3_F!ght_4_the_Us3rs

"We fight for the Users" - from the movie, Tron

This phrase makes an excellent password. As far as number of characters goes, it's quite long. It contains a mix of upper and lower-case letters, numbers, and special characters. In the world of passwords, this easy-to-remember phrase is a behemoth, and very unlikely to be brute-forced unless someone knew you were using a phrase and specifically targeted that kind of a pass-phrase. At the time of this writing, most brute-force attacks do not specifically target full phrases.

Even if you don't decide to use a phrase as a password, it's a good idea to use as many characters as you can remember and mix it up with letters (mixed case), numbers, and special characters.