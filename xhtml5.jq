[
"<!DOCTYPE
html><html
xmlns='http://www.w3.org/1999/xhtml'
lang='en'><head><meta
charset='utf-8'/><meta
name='author'
content='https://orcid.org/0009-0001-0977-2029'/><meta
name='color-scheme'
content='dark light'/><meta
name='generator'
content='", $version, "'/><meta
name='viewport'
content='width=device-width'/>",
.head,
if $css then "<style>\n\($css)</style>" else "" end,
"</head><body>",
.body,
if $javascript then "<script>\n\($javascript)</script>" else "" end,
"</body></html>"
] | join("")
