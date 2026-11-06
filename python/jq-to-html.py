# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import os
import shutil
import subprocess

jq_to_json = subprocess.run(
	[
		"jq",
		"--from-file",
		snakemake.input["xml"],
		"--null-input"
	],
	check = True,
	stdout = subprocess.PIPE
)

source_dir = snakemake.input["xml"][:-9] # removing "/_.jq.xml"

invoke_jq = [
	"jq",
	"--from-file",
	snakemake.input["template"],
	"--raw-output",
	"--arg",
	"path",
	source_dir,
	"--arg",
	"updated",
	subprocess.run(
		[
			"git",
			"log",
			"homepage",
			"-1",
			"--pretty=format:%as",
			"."
		],
		capture_output = True,
		check = True,
		cwd = source_dir,
		text = True
	).stdout
]

if hasattr(snakemake.input, "css"):
	invoke_jq.extend([
		"--rawfile",
		"css",
		snakemake.input["css"]
	])
else:
	invoke_jq.extend([
		"--argjson",
		"css",
		"false"
	])

if hasattr(snakemake.input, "js"):
	invoke_jq.extend([
		"--rawfile",
		"javascript",
		snakemake.input["js"]
	])
else:
	invoke_jq.extend([
		"--argjson",
		"javascript",
		"false"
	])

print(*invoke_jq, sep = "\n\t")

output_file = snakemake.output[0]
output_dir = output_file[:output_file.rindex("/")]
os.makedirs(output_dir, exist_ok = True)

if hasattr(snakemake.input, "prefix"):
	shutil.copy(snakemake.input["prefix"], output_file)

json_to_html = subprocess.run(
	invoke_jq,
	check = True,
	input = jq_to_json.stdout,
	stdout = subprocess.PIPE
)

if snakemake.rule == "jq_to_xhtml_utf16":
	utf8_to_utf16 = subprocess.run(
		[
			"iconv",
			"-f",
			"UTF-8",
			"-t",
			"UTF-16LE"
		],
		check = True,
		input = json_to_html.stdout,
		stdout = subprocess.PIPE
	)
	final_output = utf8_to_utf16.stdout
else:
	final_output = json_to_html.stdout

with open(output_file, mode = "ab") as f:
	f.write(final_output)
