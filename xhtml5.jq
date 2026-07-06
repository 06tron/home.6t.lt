[
"<title
class='p-name'>", .name, "</title>", (
$path | indices("/") | length - 3 | if . > 0 then
"<base
href='\("../" * .)'/>"
else "" end
), "<link
rel='author'
href='https://orcid.org/0009-0001-0977-2029'
class='p-author'
title='Matthew Richardson'/><link
rel='canonical'
href='", (
$path | [split("/")[3:][] | @uri] |
"https://home.6t.lt/\(join("/")).html"
), "'
class='u-url'/><link
rel='icon'
href='./icons/folder.svg'/><meta
name='color-scheme'
content='dark light'/><meta
name='generator'
content='", $version, "'/><meta
name='viewport'
content='width=device-width'/>",
.head,
if $css then
"<style>
\($css)</style>"
else "" end,
"</head><body><header
id='shared_top'><a
href='./'><img
alt='Heart-shaped tromino icon.'
src='./icons/♥.svg'
height='40'
width='40'/></a><a
rel='alternate'
type='text/html'
href='", (
$path | [split("/")[1:][] | @uri] |
"https://github.com/06tron/\(.[0])/blob/homepage/\(.[1:] | join("/")).jq.xml"
), "'>Updated <time
class='dt-updated'>", $updated, "</time></a></header><main
class='e-content'>",
.main,
"</main>",
if $javascript then
"<script>
\($javascript)</script>"
else "" end,
"</body></html>"
] | join("")
