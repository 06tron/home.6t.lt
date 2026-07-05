[
# "<head>" omitted: head's first child node is an element
"<!DOCTYPE
html><html
lang=en><meta
charset=utf-8><meta
name=author
content=https://orcid.org/0009-0001-0977-2029><meta
name=color-scheme
content='dark light'><meta
name=generator
content=", $version, "><meta
name=viewport
content='width=device-width'>",
.head,
if $css then "<style>\n\($css)</style>" else "" end,
# "</head>" and "<body>" omitted: head immediately followed by body, and body's first child node would be invalid as head's last child node
.body,
if $javascript then "<script>\n\($javascript)</script>" else "" end
# "</body>" and "</html>" omitted: no comments after body
] | join("")
