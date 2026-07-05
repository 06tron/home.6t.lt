#!/bin/bash

extras=" --arg version $(jq --version)"

if [ -f "$1.css" ]
then
	extras="$extras --rawfile css $1.css"
else
	extras="$extras --argjson css false"
fi

if [ -f "$1.js" ]
then
	extras="$extras --rawfile javascript $1.js"
else
	extras="$extras --argjson javascript false"
fi

jq --from-file $1.jq.xml --null-input | jq --from-file $2 $extras --raw-output
