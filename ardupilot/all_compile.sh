#/home/osboxes/Desktop/my-working-img/load_image.sh
#source ./source_me_sitl_bc_step_zero.txt

#source ./llvm-link_cmd.txt
opt -f -load /home/osboxes/Desktop/llvm/build/lib/LLVMgold.so -HexboxAnaysis --hexbox-analysis-results=./analysis_result.json ./llvm-link.bc > after_hexbox_info_clct.bc
python /home/osboxes/Desktop/conattest/graph_analysis/analyzer.py -j=/home/osboxes/Desktop/conattest/ardupilot/analysis_result.json -s=/home/osboxes/Desktop/conattest/ardupilot/size_result.json -o=/home/osboxes/Desktop/conattest/ardupilot/compartments_result.json -m=filename-no-opt -b=STM32F479 -T=/home/osboxes/Desktop/conattest/oat-evaluation/syringe-cb/arm_link_script_syringe.txt -L=/home/osboxes/Desktop/conattest/ardupilot/arm_link_script_syringe_intermidea.txt

opt -f -load /home/osboxes/Desktop/llvm/build/lib/LLVMgold.so -HexboxApplication --hexbox-policy=./compartments_result.json ./llvm-link.bc > ./after_compartment_llvm_link.bc 

#change llvm to enable pass

llc -filetype=obj ./after_compartment_llvm_link.bc -o ./llvm-link_cond_br.o

source ./single_bc_final_link.txt && cd ../../

/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-objdump -D ./build/sitl/bin/arducopter  > ./arducopter.S
