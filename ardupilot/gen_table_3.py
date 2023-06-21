import json
import pandas as pd
import numpy as np
import os
import sys
# Opening JSON file
def entry(f,index,item):
    return f[f[:,index]==item].reshape([-1,f.shape[1]])
def numberOfEntity(f,index,item):
    n=(f[:,index]==item).sum()
    #print(f[f[:,index]==item])
    return n
def merge(f):
    #return f
    t=f.copy()
    for i,u in enumerate(f):
        t[i,0]=u[0]+"$"+u[1]+"$"+u[2]+"$"+u[3]+"$"+str(u[4])+"$"+u[5]
    return t[:,0]
def unique(fn):
    #u=np.delete(f.copy(),4,1)
    f=pd.read_csv(fn,delimiter="$",header=None).values
    
    t=f.copy()
    for i,u in enumerate(t):
        t[i,0]=u[0]+"$"+u[1]+"$"+u[2]+"$"+u[3]+"$"+u[5]
    u=t[:,0]
    #print(u[0])
    u,indics=np.unique(u,return_index=True)
    #c=pd.read_csv(fn,delimiter=None,header=None).values
    return f.copy()[indics]

f = open('/home/osboxes/Desktop/conattest/ardupilot/compartments_result.json')
 
os.system('cat /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S.base1')
sys.stdout.flush()
data = json.load(f)
compart_id_dict={}
compart_id_list=[]
for i,region in enumerate(data["Compartments"]):
    compart_id_dict[region]=i
    compart_id_list+=[region]

for r in data["Regions"]:
    #print(data["Regions"][r]["Objects"])
    if "_GLOBAL__sub_I_AP_ICEngine.cpp" in data["Regions"][r]["Objects"]:
        print(".curr_cpt_id:")
        print("\t.word",compart_id_dict[r])
	

print(".total_cpt_cnt:")
print("\t.word",len(data["Compartments"]))
sys.stdout.flush()
os.system('cat /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S.base2')
sys.stdout.flush()
#just for now wt checking
print(".cpt_dt_wt_access_tb:")
for i,region in enumerate(compart_id_list):
    print("\t.word", hex(0))
    print("\t.word", hex(1))
print("\t.word", hex(0))
print("\t.word", hex(0xffffffff))
#just for now wt checking
def draw_table(direct_fn,header):
    direct_f_unique=unique(direct_fn)
   
    cpt_n=[]
    for region in compart_id_list:
        n=numberOfEntity(direct_f_unique,2,region)
        cpt_n+=[n]
    offset=[]
    accum=0
    for i,n in enumerate(cpt_n):
        offset+=[accum]
        accum=accum+8*n

    a=0
    print(header)
    for i,region in enumerate(compart_id_list):
        
        print("\t.word", offset[i],"@~source region id= ",hex(i))
        print("\t.word", cpt_n[i])
        a=a+2
        #print("\t.word", "yujieadd$indirect$.CODE_REGION_918_$.CODE_REGION_779_$31165$_ZN18AC_AttitudeControl28input_rate_bf_roll_pitch_yawEfff")#to delete
    for i,region in enumerate(compart_id_list):
        #break
        print("@~~~~cpt: ", region)
        
        entries=entry(direct_f_unique,2,region)
        for pout,e in zip(merge(entries),entries):
            
            print("\t.word", pout)
            a+=1
            print("\t.word", compart_id_dict[e[3]],"@~~source region id= ",hex(i)," offset=",hex(a))
            a+=1

direct_fn="/home/osboxes/Desktop/conattest/ardupilot/direct_symbol.txt"
draw_table(direct_fn,".cpt_direct_transfer_tb:")
indirect_fn="/home/osboxes/Desktop/conattest/ardupilot/indirect_symbol.txt"
draw_table(indirect_fn,".cpt_indirect_transfer_tb:")
print(".cpt_tb:")
for i,region in enumerate(compart_id_list):

    print("\t.word", region+"_start","@!!source region id= ",hex(i))
    print("\t.word", region+"_end")

#print(len(compart_id_list))
#print(len(compart_id_list))
