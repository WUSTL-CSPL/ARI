import json
 
# Opening JSON file
f = open('/home/osboxes/Desktop/conattest/ardupilot/compartments_result.json')
 
# returns JSON object as
# a dictionary
data = json.load(f)

for i,region in enumerate(data["Compartments"]):
    #if(region.startswith(".CODE")):
    print(region)

