# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

[
"<title
class='p-name'>",
.name,
"</title>",
if .separate then "" else [
($path | indices("/") | length - 3 | if . > 0 then [
"<base
href='",
("../" * .),
"'/>"
] else "" end),
"<link
rel='stylesheet'
href='./shared-style.css'/>"
] end,
"<link
rel='author'
href='https://orcid.org/0009-0001-0977-2029'
class='p-author'
title='Matthew Richardson'/><link
rel='canonical'
href='https://home.6t.lt/",
($path | [split("/")[3:][] | @uri] | join("/")),
".html'
class='u-url'/><meta
name='color-scheme'
content='dark light'/><meta
name='viewport'
content='width=device-width'/>",
.head,
if $css then [
"<style>
",
$css,
"</style>"
] else "" end,
"</head><body>",
if .separate then [
"<time
datetime='",
$updated,
"'
class='dt-updated'></time>"
] else [
"<header
id='shared_top'><a
href='./index.html'><img
alt='Heart-shaped tromino icon.'
src='./icons/♥.svg'
height='40'
width='40'/></a><a
href='./mf2.html'>blog</a><a
href='",
($path | [split("/")[1:][] | @uri] | [
"https://tangled.org/mrichardson.tngl.sh/",
.[0],
"/tree/homepage/",
(.[1:] | join("/"))
]),
"'>updated <time
class='dt-updated'>",
$updated,
"</time></a><a
href='./sitemap.html'>sitemap</a></header>"
] end,
"<main
class='e-content'>",
.main,
"</main>",
if $javascript then [
"<script>
",
$javascript,
"</script>"
] else "" end,
"</body></html>"
] | flatten | join("")
