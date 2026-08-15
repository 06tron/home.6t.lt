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

if snakemake.rule == "homepage_html5":
	shutil.copy(snakemake.input["html"], main_output)
	js_output = open(snakemake.output["js"], mode = "w")
	js_output.write("const jsonFeed = ")
	shutil.copyfileobj(open(snakemake.input["prefix"]), js_output)
	shutil.copyfileobj(open(snakemake.input["js"]), js_output)
else:
	shutil.copy(snakemake.input[0], main_output)
