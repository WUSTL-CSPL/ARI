import json
import os
import pandas as pd
import numpy as np

# Opening JSON file
f = open('/home/osboxes/Desktop/conattest/ardupilot/compartments_result.json')
 
# returns JSON object as
# a dictionary
data = json.load(f)

compart_id_dict={}
compart_id_list=[]
for i,region in enumerate(data["Compartments"]):
    compart_id_dict[region]=i
    compart_id_list+=[region]

for r in data["Regions"]:
    
    if "main" in data["Regions"][r]["Objects"]:
        print(".curr_cpt_id:")
        print("\t.word",compart_id_dict[r])
	

print(".total_cpt_cnt:")
print("\t.word",len(data["Compartments"]))

os.system('cat /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S.base2')