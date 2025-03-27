curl -s 
"https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" 
> aviation.json
echo "Receipt Times:"
jq -r '.features[].properties.receiptTime' aviation.json | head -6
avg_temp=$(jq '[.features[].properties.temperature] | add / length' 
aviation.json)
echo "Average Temperature: $avg_temp"
cloudy_count=$(jq '[.features[].properties.clouds | select(. != "CLR")] | 
length' aviation.json)
mostly_cloudy=$(( cloudy_count > 6 ? 1 : 0 ))
echo "Mostly Cloudy: $mostly_cloudy"

