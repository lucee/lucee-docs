Specifies how the Flash form appears relative to
other displayable content that occupies the same space on an HTML page.

- window: The Flash form is the topmost layer on the page and obscures anything that would share the
space, such as drop-down dynamic HTML lists.
- transparent: The Flash form honors the z-index of dhtml so you can float items above it. If the Flash
form is above any item, transparent regions in the form show the content that is below it.
- opaque: The Flash form honors the z-index of dhtml so you can float items above it. If the Flash form
is above any item, it blocks any content that is below it.

Default is: window.