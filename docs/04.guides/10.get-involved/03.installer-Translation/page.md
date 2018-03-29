---
title: Translations
id: installer-translation
---

### Lucee Installer Translations ###

The Lucee Installer Translation Team helps keep the Lucee Installer available in as many native languages as possible. The following is a list of languages that we can support and the names of the volunteers who currently assist with the translations.

Would you like to help support Lucee and provide a translation? It's easy! You simply select the language or languages you can help with, and we send you an English-version of the translation. You translate the English words into your selected language, save the file to a specific name, and send it back to us. That's all there is to it! Your translation will be available in the next Lucee Installer build.

If you would like to help, please contact jordan (at) getlucee [dot] ORG.

	English - Jordan Michaels
	Arabic - [Open!]
	Bulgarian - [Open!]
	Catalan - [Open!]
	Danish - [Open!]
	Dutch - Paul Klinkenberg
	Estonian - [Open!]
	French - Jean Moniatte
	Finnish - [Open!]
	German - Bilal Soylu
	Greek - Evagoras Charalambous
	Spanish - David Sedeño Fernández
	Argentine Spanish - [Open!]
	Hebrew - [Open!]
	Croatian - [Open!]
	Hungarian - [Open!]
	Italian - Salvatore Fusto
	Japanese - 田中 知明(Tomoaki Tanaka)
	Korean - [Open!]
	Polish - Jacek Mejnarowicz
	Brazilian Portuguese - Ronan Lucio
	Portuguese - [Open!]
	Romanian - Eduard Mitrea
	Russian - Azadi Saryev
	Norwegian - [Open!]
	Slovenian - [Open!]
	Slovak - [Open!]
	Albanian - [Open!]
	Swedish - [Open!]
	Turkish - [Open!]
	Traditional Chinese - Li, Da
	Simplified Chinese - Li, Da
	Valencian - [Open!]
	Welsh - Owen Dods
	Czech - [Open!]

### How to Translate ###

The process of creating a translation for the Lucee Installers is quite simple. You will be given access to a file called messages.en.txt. This is the English Translation of every message that's used in the Lucee Installers. The structure of the file is just a bunch of variable name->value pairs. In each translation the variable name will be the same, but the value will need to be translated to your language.

The following is an example of a Variable with a Translation value:

messages.en.txt:
Installer.Welcome.Text=Welcome to the %1$s Setup Wizard.

messages.de.txt:
Installer.Welcome.Text=Wilkommen beim Setup Assistenten für %1$s .

In the example above, notice how "Installer.Welcome.Text" did NOT change in either translation. The variable names need to stay the same in every translation. Also notice the "%1$s". This is an Installer Variable, and will be replaced by the word "Lucee". Currently, it doesn't matter if you change that to read "Lucee" or just leave it set to "%1$s". As a member of the translation team, you are free to make the decision to leave that or replace it.

If you need to add a line-break, you can do that with a "\n". For example:

messages.en.txt:
postInstall.installingBonCodeConnector=Installing IIS Connector\n (this can take some time...)

The above will be displayed in the installer as:
"Installing IIS Connector
(this can take some time...)"

Once you've translated the file, you will need to save it. The file names for each language is outlined below:

	English - messages.en.txt
	Arabic - messages.ar.txt
	Bulgarian - messages.bg.txt
	Catalan - messages.ca.txt
	Danish - messages.da.txt
	Dutch - messages.nl.txt
	Estonian - messages.et.txt
	French - messages.fr.txt
	Finnish - messages.fi.txt
	German - messages.de.txt
	Greek - messages.el.txt
	Spanish - messages.es.txt
	Argentine Spanish - messages.es_AR.txt
	Hebrew - messages.he.txt
	Croatian - messages.hr.txt
	Hungarian - messages.hu.txt
	Italian - messages.it.txt
	Japanese - messages.ja.txt
	Korean - messages.ko.txt
	Polish - messages.pl.txt
	Brazilian Portuguese - messages.pt_BR.txt
	Portuguese - messages.pt.txt
	Romanian - messages.ro.txt
	Russian - messages.ru.txt
	Norwegian - messages.no.txt
	Slovenian - messages.sl.txt
	Slovak - messages.sk.txt
	Albanian - messages.sq.txt
	Swedish - messages.sv.txt
	Turkish - messages.tr.txt
	Traditional Chinese - messages.zh_TW.txt
	Simplified Chinese - messages.zh_CN.txt
	Valencian - messages.va.txt
	Welsh - messages.cy.txt
	Czech - messages.cs.txt

Once you've translated the file, expect to see your translation in the next Lucee Installer release! Thank you for supporting Lucee and open-source!

### Changing Built-In Installer Strings ###

The InstallBuilder Software that is used for creating the Lucee Installers have several built-in strings in all supported languages that it uses for common messages. As a member of the Translation team, you may find that these messages could be better stated, or stated more clearly, if the built-in language were a bit different then it is by default. If you wish to change a string that is used by the installer by default, simply include the built-in variable name along with your customized translation into the translation file you return to the Distribution Coordinator. However, please speak with the Distribution Coordinator and inform them that you are customizing this variable.

A complete list of built-in InstallBuilder strings can be found here:

[http://installbuilder.bitrock.com/docs/en.lng](http://installbuilder.bitrock.com/docs/en.lng)

If you do not include a customized variable value, the InstallBuilder default value will be used.

If you have any questions, please speak with the Distribution Coordinator. Thank you for your help!