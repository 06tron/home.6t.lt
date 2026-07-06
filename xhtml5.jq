[
"<!DOCTYPE
html><html
xmlns='http://www.w3.org/1999/xhtml'
class='h-entry'
lang='en'><head><meta
charset='utf-8'/>", (
$path | indices("/") | length - 3 | if . > 0 then
"<base
href='\("../" * .)'/>"
else "" end
), "<link
rel='icon'
href='./icons/folder.svg'/><meta
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
header#shared_top { color: green; }
\($css)</style>"
else "" end,
"</head><body><header
id='shared_top'
class='h-card'><a
href='./'><img
alt='Heart-shaped tromino icon.'
src='./icons/♥.svg'
height='40'
width='40'/></a><a
href='", (
$path | [split("/")[] | @uri] |
"https://github.com/06tron/\(.[1])/blob/homepage/\(.[2:] | join("/")).jq.xml"
), "'>", $updated, "</a></header>",
.body,
if $javascript then
"<script>
\($javascript)</script>"
else "" end,
"</body></html>"
] | join("")
