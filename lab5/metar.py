import requests
import json


url = 
"https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85"


response = requests.get(url)
data = response.json()


timestamps = [entry["receiptTime"] for entry in data["data"][:6]]
print("Timestamps:")
for ts in timestamps:
    print(ts)


temps = [entry["temperature"] for entry in data["data"] if 
isinstance(entry["temperature"], (int, float))]
avg_temp = sum(temps) / len(temps) if temps else 0
print(f"Average Temperature: {avg_temp:.2f}")

cloudy_reports = sum(1 for entry in data["data"] if entry["clouds"] != 
"CLR")
mostly_cloudy = cloudy_reports > (len(data["data"]) / 2)

print(f"Mostly Cloudy: {mostly_cloudy}")

