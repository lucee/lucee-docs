Optional. "Yes" or "No."

Specifies whether to display the data that was entered into cfform controls in the action page.

"Yes" resets the value of the control to the value submitted when the form is submitted to itself. This works as expected for the cftextinput and cfslider controls.

This attribute can be used only if the form and action are on a single page, or if the action page has a form that contains controls with the same names as the corresponding controls on the form page.  

**This has not yet been implemented** <https://luceeserver.atlassian.net/browse/LDEV-1171>