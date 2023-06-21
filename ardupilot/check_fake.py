file1 = open('/tmp/d', 'r')
Lines = file1.readlines()
previous=False

for i,line in enumerate(Lines):
    if "call" in line:
        if "AMI_fake" in line:
            if previous:
                print("wrong at line",i,line)
                previous=True
            else:
                print("right")
                previous=True
        else:
            previous=False
    elif "ret" in line:
        previous=False