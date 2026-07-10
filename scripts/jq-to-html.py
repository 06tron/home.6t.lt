# Copyright (c) 2026, Matthew Richardson
# (https://orcid.org/0009-0001-0977-2029).
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

extras = [
	"--arg path " + input.xml[:-7],
	"--arg version " + shell("jq --version"),
	"--arg updated " + shell("cd $(dirname $1) && git log homepage -1 --pretty=format:%as $(basename $1).jq.xml")
]

if "css" in snakemake.input:
    extras.append("--rawfile css " + snakemake.input["css"])
else:
    extras.append("--argjson css false")

if "js" in snakemake.input:
    extras.append("--rawfile javascript " + snakemake.input["js"])
else:
    extras.append("--argjson javascript false")

snakemake.shell("jq --from-file {input.xml} --null-input | jq --from-file $2 --raw-output " + "".join(extras))
