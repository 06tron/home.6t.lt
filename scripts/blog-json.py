# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import subprocess

update_time = subprocess.run(
	[
		"git",
		"log",
		"homepage",
		"-1",
		"--pretty=format:%aI",
		"articles"
	],
	capture_output = True,
	check = True,
	cwd = "../06tron",
	text = True
).stdout

blog_json = subprocess.run(
	[
		"jq",
		f'.[0] * {{ items: .[1:] | reverse, _atom_elements: {{ updated: "{update_time}" }} }} | del(._named_items)',
		"--slurp",
		*snakemake.input,
		"--compact-output"
	],
	check = True,
	stdout = subprocess.PIPE
)

open(snakemake.output[0], mode = "wb").write(blog_json.stdout)
