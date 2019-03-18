---
title: Using database for session data storage
id: database-for-session
---

Why you want to use database for session data storage:

* Session availability after server / Lucee restarts
* Session availability between different servers
* Free server memory from data stored in session scope
* Use bigger session timeout values (be careful and test)

## MySQL ##

* Create empty database on your MySQL server. e.g. CREATE DATABASE rsessions;

* Open Lucee Web Administrator (your hostname/lucee/admin/web.cfm) -> Services -> Datasource

Create new MySQL datasource.

* Fill name (e.g. sstorage), connection details, database name (e.g. rsessions).
* Tick "Clob" enable long text retrieval.
* Tick "Storage" allow to use this datasource as client/session storage.
* "Auto reconnect": choose false
* "Throw error upon data truncation": choose true.
* Tick "Verify connection"

Other options leave at their defaults or tune according your environment.

After creation locate newly added datasource (e.g. sstorage) and make sure there is "Yes" in storage column.

* Go to Scope section, find Session storage and specify name of added datasource (e.g. sstorage).

* Run your application to create a new session. Lucee will create a cf_session_data table in your database. Then you will see session data stored in database.

Thats it!

### TIP: manually check cf_session_data table for: ###

* Primary key existance (DESCRIBE cf_session_data). If primary key doesn't exist add composite primary key (cfid, name). You can run ALTER TABLE cf_session_data ADD PRIMARY KEY(cfid,name) for that. This helps you avoid performance problems as your cf_session_data table will grow.

* Type of "data" column should be longtext, not text. Run ALTER TABLE cf_session_data MODIFY data longtext to change. (Fixed in versions 4.2.0, 4.1.2.006). This is a must have if you store big data (arrays, structs) in session. Otherwise you'll get the data truncation error

**Note** All manipulations with session data are always performed in memory. Only after session become inactive for about 10 sec Lucee will dump session data to database and free up memory. Every 1 hour Lucee automatically cleans database from expired sessions (session timeout value).
