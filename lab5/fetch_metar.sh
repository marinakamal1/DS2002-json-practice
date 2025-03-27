#!/bin/bash


curl -s 
"https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" 
-o aviation.json


echo "Receipt Times:"
jq -r '.metar[] | .receiptTime' aviation.json | head -n 6

temp_sum=0
temp_count=0
jq -r '.metar[].tempC' aviation.json | while read temp; do
    temp_sum=$(echo "$temp_sum + $temp" | bc)
    temp_count=$((temp_count + 1))
done

if [ $temp_count -ne 0 ]; then
    avg_temp=$(echo "scale=2; $temp_sum / $temp_count" | bc)
else
    avg_temp=0
fi
echo "Average Temperature: $avg_temp"

cloudy_count=0
total_count=0
jq -r '.metar[].clouds' aviation.json | while read cloud; do
    total_count=$((total_count + 1))
    if [ "$cloud" != "CLR" ]; then
        cloudy_count=$((cloudy_count + 1))
    fi
done


if [ $total_count -ne 0 ] && [ $cloudy_count -gt $((total_count / 2)) ]; 
then
    mostly_cloudy=true
else
    mostly_cloudy=false
fi
echo "Mostly Cloudy: $mostly_cloudy"

