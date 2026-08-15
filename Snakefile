# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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

JQ_HTML_PATHS = glob_wildcards("compiled-home/{path}.utf-16.xhtml")[0]
# Paths to newly created _.jq.xml files will not be found automatically.
# Use snakemake to directly construct a UTF-16 XHTML version of the
# webpage, as the presence of this file in compiled-home indicates that
# the _.jq.xml file should be used.

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

ruleorder: jq_to_html5 > jq_to_html_polyglot > jq_to_xhtml_utf16 > static_file

rule all:
	input:
		expand("compiled-home/{path}.html", path = JQ_HTML_PATHS),
		expand("compiled-home/{path}.xht", path = JQ_HTML_PATHS),
		expand("compiled-home/{path}.utf-16.xhtml", path = JQ_HTML_PATHS),
		expand("compiled-home/{path}", path = STATIC_PATHS)
	default_target: True

rule jq_to_html5:
	input:
		unpack(jq_html_source),
		template = "full-html5.jq"
	output:
		"compiled-home/{path}.html"
	script:
		"scripts/jq-to-html.py"

rule jq_to_html_polyglot:
	input:
		unpack(jq_html_source),
		prefix = "head-html-polyglot.txt",
		template = "tail-xhtml.jq"
	output:
		"compiled-home/{path}.xht"
	script:
		"scripts/jq-to-html.py"

rule jq_to_xhtml_utf16:
	input:
		unpack(jq_html_source),
		prefix = "head-xhtml-utf16.txt",
		template = "tail-xhtml.jq"
	output:
		"compiled-home/{path}.utf-16.xhtml"
	script:
		"scripts/jq-to-html.py"

rule static_file:
	input:
		static_source
	output:
		"compiled-home/{path}"
	params:
		dir = subpath(output[0], parent = True)
	script:
		"scripts/copy_static.py"
