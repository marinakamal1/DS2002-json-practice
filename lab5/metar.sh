#!/bin/bash
curl -s 
"https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" 
> aviation.json

 echo "Timestamps:" 
jq -r '.data[:6] | .[].receiptTime' aviation.json
temps=$(jq -r '.data[].temperature' aviation.json | grep -E '^-?[0-9]+$')
sum=0
count=0
for temp in $temps; do
    sum=$((sum + temp))
    count=$((count + 1))
done

avg_temp=$(echo "scale=2; $sum / $count" | bc)
echo "Average Temperature: $avg_temp"
cloudy_count=$(jq -r '.data[].clouds' aviation.json | grep -vc "CLR")
total_reports=$(jq -r '.data[].clouds' aviation.json | wc -l)
mostly_cloudy=$(( cloudy_count * 2 > total_reports ))
echo "Mostly Cloudy: $mostly_cloudy"
