# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import os

ALL_DIRECTORIES = [dirpath for dirpath, dirnames, filenames in os.walk("homepage")]

REPOS = [
	"06tron",
	"home.6t.lt",
	"textbook-exercises"
]

def jq_html_source(wildcards):
	input = {}
	for repo in REPOS:
		source_dir = f"../{repo}/jq-html-home/{wildcards.path}"
		source_xml = source_dir + "/_.jq.xml"
		if exists(source_xml):
			input["xml"] = source_xml
		else:
			continue
		source_css = source_dir + "/_.css"
		if exists(source_css):
			input["css"] = source_css
		source_js = source_dir + "/_.js"
		if exists(source_js):
			input["js"] = source_js
		return input
	raise ValueError("Source not found in a jq-html-home directory")

JQ_HTML_PATHS = [
	"692/dark-mode-highlighter",
	"6a7/aside-notes",
	"6a7/nowrap-text",
	"data:text/plain;charset=utf-8,/ \\",
	"data:text/plain;charset=utf-8,/#7f7f7f14",
	"data:text/plain;charset=utf-8,/''\"?",
	"shortcuts/about",
	"shortcuts/granjon-boxes",
	"shortcuts/note",
	"texHTML/exercises"
]

def static_source(wildcards):
	for repo in REPOS:
		source_file = f"../{repo}/static-home/{wildcards.path}"
		if exists(source_file):
			return source_file
	raise ValueError("Source not found in a static-home directory")

STATIC_PATHS = [ path
for pattern in expand(r"../{repo}/static-home/{{path,[^\.]*[^\./]+\.[^/]+}}", repo = REPOS)
for path in glob_wildcards(pattern)[0] ]
# Paths to new files within static-home directories will be found
# automatically, but they should not be hidden files beginning with a
# dot, and should contain a file extension other than '.html', '.xht',
# or '.utf-16.xhtml'.

STATIC_PATHS.append("_headers");

ARTICLE_NUMBERS = glob_wildcards("../06tron/articles/{hex}.xml")[0]

rule homepage_html5:
	input:
		"../06tron/home.6t.lt/index.html"
	output:
		"homepage/index.html"
	script:
		"scripts/copy-files.py"

rule homepage_js:
	input:
		prefix = "homepage/feed.json",
		js = "../06tron/home.6t.lt/mainpage.js"
	output:
		"homepage/mainpage.js"
	script:
		"scripts/copy-files.py"

rule blog_mf2:
	input:
		"../06tron/home.6t.lt/json-feed-to-mf2.jq",
		"homepage/feed.json"
	output:
		"homepage/mf2.html"
	shell:
		"jq --from-file {input} --raw-output > {output}"

rule blog_atom:
	input:
		"../06tron/home.6t.lt/json-feed-to-atom.jq",
		"homepage/feed.json"
	output:
		"homepage/atom.xml"
	shell:
		"jq --from-file {input} --raw-output > {output}"

rule blog_json:
	input:
		"../06tron/home.6t.lt/outline.json",
		expand("blog/{hex}.json", hex = ARTICLE_NUMBERS)
	output:
		"homepage/feed.json"
	script:
		"scripts/blog-json.py"

rule article_json:
	input:
		"../06tron/articles/{hex}.xml",
		outline = "../06tron/home.6t.lt/outline.json"
	output:
		"blog/{hex}.json"
	script:
		"scripts/article-json.py"

rule mirror_html5:
	input:
		"../06tron/home.6t.lt/mirror.html"
	output:
		"homepage/shortcuts/index.html"
	script:
		"scripts/copy-files.py"

rule not_found_html5:
	input:
		"../06tron/home.6t.lt/404.html"
	output:
		"homepage/404.html"
	script:
		"scripts/copy-files.py"

rule sitemap_html5:
	input:
		"../06tron/home.6t.lt/sitemap.html"
	output:
		"homepage/sitemap.html"
	script:
		"scripts/tree.py"

rule tree_index_html5:
	input:
		"../06tron/home.6t.lt/sitemap.html"
	output:
		"homepage/{path}/index.html"
	wildcard_constraints:
		path = r"(?!shortcuts/index.html$).*"
	script:
		"scripts/tree.py"

rule q_encode_xml11_html:
	input:
		xml = "../06tron/jq-html-home/698/query-encoding/_.jq.xml",
		css = "../06tron/jq-html-home/698/query-encoding/_.css",
		prefix = "head-xml11-htm.txt",
		template = "tail-xhtml.jq"
	output:
		"homepage/698/query-encoding.html"
	script:
		"scripts/jq-to-html.py"

rule jq_to_html5:
	input:
		unpack(jq_html_source),
		template = "full-html5.jq"
	output:
		"homepage/{path}.html"
	wildcard_constraints:
		path = r"(?!((.*/)?index|mf2|404|sitemap|698/query-encoding).html$).*"
	script:
		"scripts/jq-to-html.py"

rule jq_to_html_polyglot:
	input:
		unpack(jq_html_source),
		prefix = "head-html-polyglot.txt",
		template = "tail-xhtml.jq"
	output:
		"homepage/{path}.xht"
	script:
		"scripts/jq-to-html.py"

rule jq_to_xhtml_utf16:
	input:
		unpack(jq_html_source),
		prefix = "head-xhtml-utf16.txt",
		template = "tail-xhtml.jq"
	output:
		"homepage/{path}.utf-16.xhtml"
	script:
		"scripts/jq-to-html.py"

rule static_file:
	input:
		static_source
	output:
		"homepage/{path}"
	wildcard_constraints:
		path = r"(?!(.*(\.html|\.xht|\.utf-16\.xhtml)|mainpage\.js|atom\.xml|feed\.json)$).*"
	script:
		"scripts/copy-files.py"

rule all:
	input:
		rules.homepage_html5.output,
		rules.homepage_js.output,
		rules.blog_mf2.output,
		rules.blog_atom.output,
		rules.blog_json.output,
		rules.mirror_html5.output,
		rules.not_found_html5.output,
		rules.q_encode_xml11_html.output,
		expand("homepage/{path}.html", path = JQ_HTML_PATHS),
		expand("homepage/{path}.xht", path = JQ_HTML_PATHS),
		expand("homepage/{path}.utf-16.xhtml", path = JQ_HTML_PATHS)
	default_target: True

rule static_files:
	input:
		expand("homepage/{path}", path = STATIC_PATHS)

rule tree_indices:
	input:
		expand("{path}/index.html", path = ALL_DIRECTORIES),
		rules.sitemap_html5.output
	shell:
		"find homepage -name .DS_Store -delete"
