#!/bin/bash

python3 gen_table.py > cp.txt

/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-objdump -t ./llvm-link_cond_br.o | grep yujieadd\$indirect | awk '{print $5}'  > indirect_symbol.txt
/home/osboxes/devel/optee/toolchains/aarch32/bin/arm-linux-gnueabihf-objdump -t ./llvm-link_cond_br.o | grep yujieadd\$direct | awk '{print $5}'  > direct_symbol.txt
#echo trampoline_fw.S.base $(python3 gen_table_2.py) > trampoline_fw.S
#python3 gen_table_2.py > tmp1.txt
python3 gen_table_3.py > /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S
#cat /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S.base1 tmp1.txt /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S.base2 tmp2.txt > /home/osboxes/Desktop/conattest/trampoline_lib/trampoline_fw.S