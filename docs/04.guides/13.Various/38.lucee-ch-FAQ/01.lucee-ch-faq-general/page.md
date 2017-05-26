---
title: General FAQ
id: lucee-ch-faq-general
---

### General ###

**What is Lucee?**

Lucee is a Java application that executes pages written in CFML on a servlet engine. In order to do that Lucee converts the CFML Pages into Java bytecode and executes the bytecode along with the Lucee runtime engine on a certain servlet engine.

**What content management systems are supported by Lucee?**

Until now a couple of CMS have been successfully tested and launched with Lucee. One of the sophisticated ones is for example [Contens](https://web.archive.org/web/20090129164434/http://www.contens.de/) 3.0 from Contens Germany. [www.railo.ch](https://web.archive.org/web/20090129164434/http://railo.ch:80/en/index.cfm?treeID=274) is implemented JMuffin of [Sinato](https://web.archive.org/web/20090129164434/http://www.sinato.com/) Switzerland.

**Which frameworks can be used with Lucee?**

Lucee supports all well known CFM frameworks like Fusebox 1-5, Mach II, Model Glue, Tartan and ColdSpring. The special thing about the usage of these frameworks is, that they can be defined as Lucee [Archives](https://web.archive.org/web/20090129164434/http://railo.ch:80/de/index.cfm?treeID=104) in the Server Administrator and then are available to all local webs as readonly mappings. The only things that sometimes have to be adjusted in the certain frameworks are the usage of hidden features of CFMX (service factory) or syntax errors in attributes that are ignored by CFMX but not by Lucee.

**How is the performance of Lucee?**

Lucee's performance can absolutely be compared to the one of other CFML engines. Even when you enable debugging, the execution time is only increasing by less than 5%. In several tests Lucee was able to execute the benchmarks in about 60% of the time of the next best competitor.

**Is it true, that Lucee is the name of a dog?**

Yes. Lucee is the name of an alien dog, first appearing in the first season, episode 25 of the TV-series "Enterprise".

**Where is Lucee Technologies located?**

Lucee Technologies is based in Bern, Switzerland. The office lies in the Business Park in Bern Wankdorf.