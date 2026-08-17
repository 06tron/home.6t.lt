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

JQ_HTML_PATHS = glob_wildcards("homepage/{path}.utf-16.xhtml")[0]
# Paths to newly created _.jq.xml files will not be found automatically.
# Use snakemake to directly construct a UTF-16 XHTML version of the
# webpage, as the presence of this file in 'homepage' indicates that the
# _.jq.xml file should be used.

def static_source(wildcards):
	for repo in REPOS:
		source_file = f"../{repo}/static-home/{wildcards.path}"
		if exists(source_file):
			return source_file
	raise ValueError("Source not found in a static-home directory")

STATIC_PATHS = [ path
for pattern in expand("../{repo}/static-home/{{path,[^\\.].+\\..+}}", repo = REPOS)
for path in glob_wildcards(pattern)[0] ]
# Paths to new files within static-home directories will be found
# automatically, but they should not be hidden files beginning with a
# dot, and should contain a file extension other than '.html', '.xht',
# or '.utf-16.xhtml'.

ARTICLE_NUMBERS = glob_wildcards("../06tron/articles/{hex}.xml")[0]

ruleorder: homepage_html5 > blog_mf2 > blog_atom > blog_json > article_json > mirror_html5 > sitemap_html5 > tree_index_html5 > jq_to_html5 > jq_to_html_polyglot > jq_to_xhtml_utf16 > static_file

rule homepage_html5:
	input:
		prefix = "homepage/feed.json",
		html = "../06tron/home.6t.lt/index.html",
		js = "../06tron/home.6t.lt/mainpage.js"
	output:
		"homepage/index.html",
		js = "homepage/mainpage.js"
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

rule sitemap_html5:
	input:
		"homepage",
		prefix = "../06tron/home.6t.lt/sitemap.html"
	output:
		"homepage/sitemap.html"
	script:
		"scripts/tree.py"

rule tree_index_html5:
	input:
		"homepage/{path}",
		prefix = "../06tron/home.6t.lt/sitemap.html"
	output:
		"homepage/{path}/index.html"
	script:
		"scripts/tree.py"

rule jq_to_html5:
	input:
		unpack(jq_html_source),
		template = "full-html5.jq"
	output:
		"homepage/{path}.html"
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
	script:
		"scripts/copy-files.py"

rule all:
	input:
		expand("{path}/index.html", path = ALL_DIRECTORIES),
		rules.blog_mf2.output,
		rules.blog_atom.output,
		rules.blog_json.output,
		rules.sitemap_html5.output,
		expand("homepage/{path}.html", path = JQ_HTML_PATHS),
		expand("homepage/{path}.xht", path = JQ_HTML_PATHS),
		expand("homepage/{path}.utf-16.xhtml", path = JQ_HTML_PATHS),
		expand("homepage/{path}", path = STATIC_PATHS)
	default_target: True
