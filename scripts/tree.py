# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import os
import subprocess

output_file = snakemake.output[0]
output_dir = output_file[:output_file.rindex("/")]
os.makedirs(output_dir, exist_ok = True)

base = ""
if snakemake.rule != "sitemap_html5":
	base = "<base\nhref="
	base += "../" * output_dir.count("/")
	base += ">"

tree_html = subprocess.run(
	[
		"tree",
		output_dir,
		"-I",
		"*/index.html",
		"-I",
		"*.xht",
		"-I",
		"*.utf-16.xhtml",
		"-I",
		"homepage/data:text/",
		"-H",
		"-." + output_dir[8:], # remove "homepage"
		"--hintro=" + snakemake.input[0]
	],
	check = True,
	capture_output = True,
	text = True
).stdout.replace("<!--BASE-->", base, 1).replace('/"', '/index.html"')

open(snakemake.output[0], mode = "w").write(tree_html)
