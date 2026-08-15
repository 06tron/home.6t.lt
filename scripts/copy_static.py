# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import subprocess

subprocess.run(
	[
		"mkdir",
		"-p",
		snakemake.params["dir"]
	],
	check = True
)

copy_static = subprocess.run(
	[
		"cp",
		snakemake.input[0],
		snakemake.output[0]
	],
	check = True,
	stdout = subprocess.PIPE
)

open(snakemake.output[0], "ab").write(copy_static.stdout)
