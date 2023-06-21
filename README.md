
# ARI: Attestation of Real-time Mission Execution Integrity

Jinwen Wang, Jinwen Wang, Yujie Wang, Ao Li, Yang Xiao, Ruide Zhang, Wenjing Lou, Y. Thomas Hou, Ning Zhang. "ARI: Attestation of Real-time Mission Execution Integrity." 2023 USENIX Security Symposium.

## Project Structure
The main ARI codes are distributed in directory structure as follows (this graph is only the main roadmap).
```
REPO_ROOT

  |-> ardupilot
    |-> compile_1st_part.txt (front end instrumentation for compartmentalization and runtime measurement)
    |-> compile_2nd_part.txt (back end instrumentation for compartmentalization and runtime measurement)
  |-> graph_analysis
    |-> analyzer.py (compartmentalization policy implementation)
    |-> final_linker_gen.py (generate linker script)
  |-> conattestllvm
    |-> /lib/Transforms/Utils/HexboxAnalysis.cpp (Compartmentalization generation)
    |-> /lib/Transforms/Utils/HexboxApplication.cpp (Front end instrumentation)
    |-> /lib/Target/ARM/SFIPass.cpp (Sandboxing back end instrumentation)
    |-> /lib/Target/ARM/CFEventsPass.cpp (Runtime measurement back end instrumentation)    
  |-> oat-verification-engine
    |-> verify_engine (Mission Integrity Verification)
```
## Dependencies
Installing following dependencies on Ubuntu 16.04. On Cortex-A platform, the code is tested on Raspberry Pi3 with Navio2 as a daughter board.
```
REPO_ROOT
$ sudo apt-get install python-pip  
$ python -m pip install –upgrade "pip < 19.2"  
$ sudo python -m pip install –upgrade "pip < 21.0"  
$ sudo apt-get install clang-3.9 && cd /usr/bin && sudo ln ./clang-3.9 ./clang && sudo ln ./clang++-3.9 ./clang++  
$ sudo apt install git cmake build-essential make texinfo bison flex ninja-build ncurses-dev texlive-full binutils-dev python-networkx  python-matplotlib  python-pygraphviz python-serial  
$ sudo pip2 -q install -U future lxml pymavlink MAVProxy  
$ pip install pydotplus python-louvain bitarray capstone  
enum34 pyelftools pyblake2  
$ wget http://launchpadlibrarian.net/356067403/gcc-5-aarch64-linux-gnu_5.4.0-6ubuntu1~16.04.9cross1_amd64.deb  
$ sudo dpkg -i ./gcc-5-aarch64-linux-gnu_5.4.0-6ubuntu1~16.04.9cross1_amd64.deb
```
## Building ARI
To setup RT-TEE for the first time, clone the repo and follow next steps. REPO_ROOT is the path of RT-TEE root directory (ari_dir  is the root directory of ARI project. ).
1. Build LLVM
```
$ git clone https://github.com/WUSTL-CSPL/ARI.git  
$ git ./conattest/conattestllvm 
$ chmod +x ./compiler_for_1st_part.sh  
$ ./compiler_for_1st_part.sh  
$ mkdir build && cd ./build  
$ cmake -DLLVM_ENABLE_ASSERTIONS=OFF ..  
$ make  
$ echo ’export PATH=$PATH:ari_dir/conattestllvm/build/bin’>> ~/.bashrc  
$ source ~/.bashrc
```

2. Instrument ArduCopter
 
```
$ echo 'export PATH=$PATH:ari_dir/gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf/bin' >> ~/.bashrc
$ source ~/.bashrc
```
Download the Pi3 image in following link. Decompress it into  pi3_img_dir.https://drive.google.com/drive/folders/1WOiFES-zJf6JkdWjziMnFrqsJJlmlBwy?usp=sharing.  
```
$ cd pi3_img_dir/my-working-image && ./load_image.sh
$ cd ./conattestllvm && ./compiler_for_1st_part.sh  
$ cd ./build && make -j  
$ cd ../../ardupilot  
$ source ./compile_1st_part.txt  
$ cd ../conattestllvm && ./compiler_for_2nd_part.sh  
$ cd ./build && make -j  
$ cd ../../ardupilot  
$ source ./compile_2nd_part.txt
```

## Mission Execution
On the Pi3, execute following command to start arducopter.
```
$ cd ~&& sync  
$ sudo ./arducopter -S -I0 –model + –speedup 1 –defaults ./copter.parm
```

On host, execute following instruction to start simulation.
```
$  "mavproxy.py"  "–master"  "tcp:10.228.106.170:5760"  "–sitl" "10.228.106.170:5501" "–out"  "10.228.106.170:14550" "–out"  "10.228.106.170:14551" "–map" "–console"
```

Then you will see a  Console  and a  Map  in the VM. Please  wait for about 1 min, the  Console  will show  AP: EKF2 IMU0  is using GPS  and  AP: EKF2 IMU1 is using GPS.  Typing following commands in the terminal.  

```
STABILIZE> mode guided  
GUIDED> arm throttle  
GUIDED> takeoff 20
```
Then stop the arducopter on Pi3 and simulation on host.

## Mission Verification
Execute following commands to transfer runtime measurement from Pi3 to host.
```
$ cd ardu_path  
$ source ./tsf_measurement.txt
```

Verify the mission integrity.
```
$ cd ../oat-verify-engine  
$ source ../ardupilot/mission_verify.txt
```
