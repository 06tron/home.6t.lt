[
"<?xml
version='1.0'
encoding='utf-16'?><html
xmlns='http://www.w3.org/1999/xhtml'
lang='en'><head>", (
$path | indices("/") | length - 3 | if . > 0 then
"<base
href='\("../" * .)'/>"
else "" end
), "<meta
name='author'
content='https://orcid.org/0009-0001-0977-2029'/><meta
name='color-scheme'
content='dark light'/><meta
name='generator'
content='", $version, "'/><meta
name='viewport'
content='width=device-width'/>",
.head,
if $css then
"<style>
header#shared_top {}
\($css)</style>"
else "" end,
"</head><body><header
id='shared_top'></header>",
.body,
if $javascript then
"<script>
\($javascript)</script>"
else "" end,
"</body></html>"
] | join("")
