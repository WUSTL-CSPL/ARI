import json
#import pandas as pd
import numpy as np 

# Opening JSON file
f = open('/home/osboxes/Desktop/conattest/ardupilot/compartments_result.json')
 
# returns JSON object as
# a dictionary
data = json.load(f)


cp_size=np.genfromtxt('/home/osboxes/Desktop/conattest/ardupilot/cp_size.txt',dtype=str)

print(cp_size)

'''
for i,region in enumerate(data["Compartments"]):
    #if(region.startswith(".CODE")):
    print(region)
'''