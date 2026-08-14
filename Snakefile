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

def find_source_files(wildcards):
	input = {}
	for repository in REPOS:
		source = f"../{repository}/jq-html-home/{wildcards.path}"
		source_xml = source + "/_.jq.xml"
		if exists(source_xml):
			input["xml"] = source_xml
		else:
			continue
		source_css = source + "/_.css"
		if exists(source_css):
			input["css"] = source_css
		source_js = source + "/_.js"
		if exists(source_js):
			input["js"] = source_js
		return input
	raise ValueError("Source not found")

JQ_XML_PATHS = glob_wildcards("static-home/{path}.utf-16.xhtml")[0]

rule all_jq_to_html:
	input:
		expand("static-home/{path}.html", path=JQ_XML_PATHS),
		expand("static-home/{path}.xht", path=JQ_XML_PATHS),
		expand("static-home/{path}.utf-16.xhtml", path=JQ_XML_PATHS)
	default_target: True

rule jq_to_html5:
	input:
		unpack(find_source_files),
		template = "full-html5.jq"
	output:
		"static-home/{path}.html"
	script:
		"scripts/jq-to-html.py"

rule jq_to_html_polyglot:
	input:
		unpack(find_source_files),
		prefix = "head-html-polyglot.txt",
		template = "tail-xhtml.jq"
	output:
		"static-home/{path}.xht"
	script:
		"scripts/jq-to-html.py"

rule jq_to_xhtml_utf16:
	input:
		unpack(find_source_files),
		prefix = "head-xhtml-utf16.txt",
		template = "tail-xhtml.jq"
	output:
		"static-home/{path}.utf-16.xhtml"
	script:
		"scripts/jq-to-html.py"
