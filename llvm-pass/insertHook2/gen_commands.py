import sys
import os
import stat

file1 = open('sitl_bc_files.txt', 'r') 
Lines = file1.readlines() 

# writing to file 
file2 = open('insert_hook_commands.txt', 'w') 

for line in Lines:
	if "GCS_MAVLink" not in line:
		file2.write("echo '" + line[:-1] + "':\n")
		file2.write("opt -load=./rddep.so -rddep "+ line[:-1] + ".declare" + " -rddep-analysis-results test.json -f > " + line)


st = os.stat('sitl_bc_files.txt')
os.chmod('sitl_bc_files.txt', st.st_mode | stat.S_IEXEC)

file2.close() 
file1.close()