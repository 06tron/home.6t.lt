# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

import os
import shutil

main_output = snakemake.output[0]
output_dir = main_output[:main_output.rindex("/")]
os.makedirs(output_dir, exist_ok = True)

if snakemake.rule == "homepage_js":
	with open(main_output, mode = "w") as js_output:
		js_output.write("const jsonFeed = ")
		with open(snakemake.input["prefix"]) as json_feed:
			shutil.copyfileobj(json_feed, js_output)
		with open(snakemake.input["js"]) as page_js:
			shutil.copyfileobj(page_js, js_output)
else:
	shutil.copy(snakemake.input[0], main_output)
