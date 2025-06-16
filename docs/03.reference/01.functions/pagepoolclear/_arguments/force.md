When set to `false` (default in Lucee 6.2.1+), this function behaves like inspectTemplates(), which only reloads changed pages. 

When set to `true`, it reverts to the original behavior of forcibly clearing all pages from memory pools, causing unnecessary reloading of unchanged pages.