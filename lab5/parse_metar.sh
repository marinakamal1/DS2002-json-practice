#!/bin/bash
 
curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json
 
jq -r '.[0:6][].receiptTime' aviation.json 
 
avg_temp=$(jq -r 'map(.temp) | add / length' aviation.json)
echo "Average Temperature: $avg_temp"
 
cloudy=$(jq -r 'map(select(.clouds[0] != "CLR")) | length' aviation.json)
cloudy_total=$(jq -r 'length' aviation.json) 

if ((cloudy > cloudy_total / 2)); then 
	echo "Mostly Cloudy: true" 
else 
	echo "Mostly Cloudy: false"
fi 

