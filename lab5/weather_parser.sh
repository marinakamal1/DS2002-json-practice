#!/bin/bash


if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed."
    exit 1
fi


curl -s 
"https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" 
-o aviation.json


if ! jq empty aviation.json &> /dev/null; then
    echo "Error: Invalid JSON response."
    exit 1
fi

jq -r '.features[].properties.receiptTime' aviation.json | head -n 6

