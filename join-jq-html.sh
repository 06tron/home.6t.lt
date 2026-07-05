#!/bin/bash

extras=( --arg path "$1" --arg version $(jq --version) )

if [ -f "$1.css" ]
then
	extras+=( --rawfile css "$1.css" )
else
	extras+=( --argjson css false )
fi

if [ -f "$1.js" ]
then
	extras+=( --rawfile javascript "$1.js" )
else
	extras+=( --argjson javascript false )
fi

jq --from-file "$1.jq.xml" --null-input | jq --from-file $2 "${extras[@]}" --raw-output
