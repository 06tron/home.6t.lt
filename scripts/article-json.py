# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import subprocess

source_xml = snakemake.input[0]
source_dir = source_xml[:source_xml.rindex("/")]
number = snakemake.wildcards["hex"]

handle_whitespace = subprocess.run(
	[
		"perl",
		"-0076",
		"-pe",
		r"s/[\t\n]//g; s/&#x9;/\t/g; s/&#xA;/\n/g",
		source_xml
	],
	check = True,
	stdout = subprocess.PIPE
)

update_time = subprocess.run(
	[
		"git",
		"log",
		"homepage",
		"-1",
		"--pretty=format:%aI",
		number + ".xml"
	],
	capture_output = True,
	check = True,
	cwd = source_dir,
	text = True
).stdout

item_json = subprocess.run(
	[
		"jq",
		f'{{ date_modified: "{update_time}", content_html: . }} + $outline[0]."{number}" | .title |= "{number} - " + .',
		"--slurpfile",
		"outline",
		snakemake.input["outline"],
		"--raw-input",
		"--slurp",
		"--tab"
	],
	check = True,
	input = handle_whitespace.stdout,
	stdout = subprocess.PIPE
)

with open(snakemake.output[0], mode = "wb") as f:
	f.write(item_json.stdout)
