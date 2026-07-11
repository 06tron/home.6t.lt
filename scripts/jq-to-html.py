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
	stdout = subprocess.PIPE
)

source_path = snakemake.input["xml"][:-7] # removing ".jq.xml"
source_dir = source_path[:source_path.rindex("/")]
source_xml_name = snakemake.input["xml"].split("/")[-1]

invoke_jq = [
	"jq",
	"--from-file",
	snakemake.input["template"],
	"--raw-output",
	"--arg",
	"path",
	source_path,
	"--arg",
	"updated",
	subprocess.run(
		[
			"git",
			"log",
			"homepage",
			"-1",
			"--pretty=format:%%as",
			source_xml_name
		],
		capture_output = True,
		cwd = source_dir
		text = True,
	).stdout
]

if "css" in snakemake.input:
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

if "js" in snakemake.input:
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

output_file = snakemake.output[0]
output_dir = output_file[:output_file.rindex("/")]
os.makedirs(output_dir, exist_ok = True)

if "prefix" in snakemake.input:
	shutil.copy(snakemake.input["prefix"], output_file)

subprocess.run(
	invoke_jq,
	stdin = jq_to_json.stdout
	stdout = open(output_file, "a")
)
