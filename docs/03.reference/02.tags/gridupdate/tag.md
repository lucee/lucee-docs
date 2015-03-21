---
title: <cfgridupdate>
related:
categories:
---

Used in a cfgrid, cfgridupdate allows you to perform updates to data sources directly from edited
  grid data. The cfgridupdate tag provides a direct interface with your data source.
  The cfgridupdate tag applies delete row actions first, then INSERT row actions, and then UPDATE row
  actions. If an error is encountered, row processing stops.