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
"</title>", (
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
href='https://home.6t.lt/", (
$path | [split("/")[3:][] | @uri] | join("/")
), ".html'
class='u-url'/><meta
name='color-scheme'
content='dark light'/><meta
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
class='dt-updated'>",
$updated,
"</time></a></header><main
class='e-content'>",
.main,
"</main>",
if $javascript then
"<script>
\($javascript)</script>"
else "" end,
"</body></html>"
] | join("")
