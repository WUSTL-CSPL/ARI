#include "ARM.h"
#include "llvm/Pass.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
// #include "llvm/CodeGen/Register.h"
#include "ARMTargetMachine.h"
#include <fstream>
#include <iostream>
#include "llvm/IR/DebugLoc.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
// #include "Target/ARM/ARMBaseInstrInfo.h"
#include "llvm/Target/TargetInstrInfo.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "json/json.h"
#include <map>
#include <vector>
#include <sstream>
#include "llvm/IR/DebugInfoMetadata.h"

#define DEBUG_TYPE "sfi"
 
using namespace llvm;

//storing the relationship between functions and section, 
//the first string is function name, the second string is section name
std::map<std::string, std::string> func2sec;

//storing the relationship between starting address and masks for each section
//the first int is the section index, the second vection contains 
//the start address and corresponding mask of each mask
std::map<int, std::vector<int>> sectaddrmask;

namespace {

    // BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
    // int cnt_to_be_pop = 0;
    //des_reg is the count of byte to be poped from stack when inst is pop_ret
    //des_reg is CSPR when instrumenting predictable instructions
    //cond_code is only used when instrumenting predictable instruction (defined in ARMBaseInfo.h)
    //cond_code is 0 CBNZ, 1 CBZ
    int total_instrumentation_cnt = 0;
    int Trampoline_Transfer_Instru(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){

        // total_instrumentation_cnt += 1;
        // printf("%d\n", total_instrumentation_cnt);

        DebugLoc dl = DebugLoc();
        // sub sp, sp, 32
        BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(32)
            .addImm(14) //condition code
            .addReg(0)
            .addReg(0);
        
        // save r0
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::SP)
            .addReg(ARM::R0)
            .addReg(ARM::SP)
            // .addReg(ARM::SP);
            .addImm(0) //offset
            .addImm(14);//condition
        
        // save r1
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R1)
            .addReg(ARM::R1)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);

        // save r2
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R2)
            .addReg(ARM::R2)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);

        // save lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR)
            .addReg(ARM::LR)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);

        BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(24)
            .addImm(14)
            .addReg(0)
            .addReg(0);


        //mov des_add to r0
        if(CFE_type < 3){
            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
                .addReg(ARM::R0)
                .addReg(des_reg)
                .addImm(14)
                .addReg(0)
                .addReg(0);            
        }
        //LDMIA_RET
        else if (CFE_type == 3){
            BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
                .addReg(ARM::R0, RegState::Define)
                .addReg(ARM::R0)
                .addReg(ARM::SP)
                .addImm(32 + 4 * (des_reg - 1))
                .addImm(14);      

            BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(32 + 4 * (des_reg - 1))
            .addImm(14)
            .addReg(0)
            .addReg(0);       
        }
        //conditional branch
        else if(CFE_type == 4){
             BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R0)
                .addImm(14);            
        }
        //compare
        else{
             BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
                .addReg(ARM::R0)
                .addReg(des_reg)
                .addImm(14)
                .addReg(0)
                .addReg(0);               
        }


        if(CFE_type < 4){
            //mov pc to r1
            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr), ARM::R1)
                .addReg(ARM::PC)
                .addImm(14)
                .addReg(0)
                .addReg(0);                
        }
        //conditional branch 
        //compare
        else if (CFE_type == 4 or CFE_type == 5){
             BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R1)
                .addImm(cond_code)          
                .addImm(14)
                .addReg(0)
                .addReg(0);
                // .addReg(0);           
        }


        //mov CFE type to r2
        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
            .addImm(CFE_type)
            .addImm(14)
            .addReg(0)
            .addReg(0);


        const char* symicall = "__cfv_icall";
        // const char* symRet = "__cfv_ret";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(symicall);

        // BuildMI(*MBB,  BBI, dl, TII.get(ARM::BL))
        //     .addGlobalAddress(MF.getMMI().getModule()->getNamedValue("view_switch_to_rd_and_log"));

        // BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(symRet);

        // restore r0
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
            .addReg(ARM::R0)
            .addReg(ARM::R0)
            .addReg(ARM::SP)
            // .addReg(ARM::SP);
            .addImm(0) //offset
            .addImm(14);//condition

        // restore r1
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
            .addReg(ARM::R1, RegState::Define)
            .addReg(ARM::R1)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);


        //restore r2
         BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
            .addReg(ARM::R2, RegState::Define)
            .addReg(ARM::R2)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);                   

        // restore lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
            .addReg(ARM::LR)
            .addReg(ARM::LR)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14);


        BuildMI(*MBB, BBI, dl, TII.get(ARM::ADDri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14)
            .addReg(0)
            .addReg(0);
        
        
        return 0;
    }


    //++++++++++++++++++++++++++++++++++++++Forward Edge Sandbox Instrumentation++++++++++++++++++++++++++++++++++++++
    int Fwd_SFI_Instrumentation(MachineInstr* MI, MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII,\
        int base_addr, int mask){
        DebugLoc dl = DebugLoc();
        // errs() << "&&&&&&&&&&&&&&&&Fwd_SFI_Instrumentation&&&&&&&&&&&&&&&&" << "\n";
        // sub sp, sp, 32
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::ANDri))               
        //     .addReg(ARM::R8)
        //     .addReg(MI->getOperand(0).getReg())
        //     .addImm(0xffff)//this should be modified to compartment specified address space
        //     .addImm(14) //condition code
        //     .addReg(0)
        //     .addReg(0);
        
        //replace blx/bx rx to blx/bx rr 
        // BuildMI(*MBB, BBI, dl, TII.get(MI->getOpcode()))
        //     .addReg(ARM::R8)
        //     .addImm(14) //condition code
        //     .addReg(0)
        //     .addReg(0);


        // if(base_addr = 0x1000000){

            //insert instruciton to move indirect jump target into reserved register
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi32imm))
            //     .addReg(ARM::R8, RegState::Define)
            //     .addImm(base_addr);

            // return 0;
        // }


        //filter blx/bx ip

        // if(MI->getOperand(0).getReg() == ARM::R12){
        // if(mask != 19){
        //     if(MI->getOpcode() == ARM::BLX){
        //         // original code
        //         // insert instruction to jump to blx checking trampoline
        //         // const char* trampoline_blx = "__trampoline_fw_blx"; 
        //         // BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_blx);
        //         BuildMI(*MBB, BBI, dl, TII.get(ARM::BLX))
        //         .addReg(MI->getOperand(0).getReg(), RegState::Define);

        //     }
        //     else if(MI->getOpcode() == ARM::BX){
        //         // original code
        //         // insert inst ruction to jump to bx checking trampoline
        //         // const char* trampoline_bx = "__trampoline_fw_bx";
        //         // BuildMI(*MBB,BBI,dl,TII.get(ARM::B)).addExternalSymbol(trampoline_bx);             
        //         BuildMI(*MBB, BBI, dl, TII.get(ARM::BX))
        //         .addReg(MI->getOperand(0).getReg(), RegState::Define);
        //     }
        //     return 0;

        // }



        // load basic address into r8
        // errs() << "~~~~~MOVi16\n";
        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
            .addReg(ARM::R8)
            .addImm(base_addr & 0xffff)
            .addImm(14)
            .addReg(0);

        // errs() << "~~~~~MOVTi16\n";
         
        MachineInstrBuilder MIB = BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVTi16), ARM::R8);
        MIB.addReg(ARM::R8);
        MIB.addImm((base_addr >> 16) & 0xffff);
        AddDefaultPred(MIB);

        //jinwen commend for test
        // original code
        // insert instruciton to move indirect jump target into reserved register
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
        //     .addReg(ARM::R8)
        //     .addReg(MI->getOperand(0).getReg())
        //     .addImm(14)
        //     .addReg(0)
        //     .addReg(0);  


        //insert bfi instruction
        //bfi r8, rx, #0, #12
        BuildMI(*MBB, BBI, dl, TII.get(ARM::BFI))
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::R8, RegState::Define) //useless            
            // .addReg(MI->getOperand(0).getReg(),RegState::Define)
            .addReg(MI->getOperand(0).getReg())
            // .addReg(ARM::R8, RegState::Define) //useless            
            .addImm(~((1<<mask)-1))
            .addImm(14);


        if(MI->getOpcode() == ARM::BLX){
            // original code
            // insert instruction to jump to blx checking trampoline
            // const char* trampoline_blx = "__trampoline_fw_blx"; 
            // BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_blx);
            BuildMI(*MBB, BBI, dl, TII.get(ARM::BLX))
            .addReg(ARM::R8, RegState::Define);

        }
        else if(MI->getOpcode() == ARM::BX){
            // original code
            // insert inst ruction to jump to bx checking trampoline
            // const char* trampoline_bx = "__trampoline_fw_bx";
            // BuildMI(*MBB,BBI,dl,TII.get(ARM::B)).addExternalSymbol(trampoline_bx);             
            BuildMI(*MBB, BBI, dl, TII.get(ARM::BX))
            .addReg(ARM::R8, RegState::Define);
        }

        return 0;   
    }

    int Bkwd_SFI_Instrumentation(MachineInstr* MI, MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){
        DebugLoc dl = DebugLoc();
        if(MI->getOpcode() == ARM::BX_RET){

            // if(MI->getNumOperands() == 2){
            //     return 0;
            // }
            //TODO fix conditional BX_RET
            for(int i = 0; i < MI->getNumOperands(); i++){
                if(MI->getOperand(i).isImm() && MI->getOperand(i).getImm()!=14){
                    return 0;
                }
            }

            //insert instruciton to move lr into reserved register
            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
                .addReg(ARM::R8)
                .addReg(ARM::LR)
                .addImm(14)
                .addReg(0)
                .addReg(0); 

            // for(int i = 0; i< MI->getNumOperands(); i++){
            //     errs() << MI->getOperand(i).getType() << ":";
            //     if(MI->getOperand(i).isReg()){
            //         errs() << MI->getOperand(i).getReg();
            //     }
            //     else{
            //         errs() << MI->getOperand(i).getImm();
            //     }
            // }
            // errs() << "\n";

            //saving lr
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            //     .addReg(ARM::LR, RegState::Define )
            //     .addReg(ARM::LR )          //useless              
            //     .addReg(ARM::SP )
            //     .addImm(-4)               //pre offset
            //     // .addImm(14) //post offset
            //     .addImm(14);              //conditional codes
            
            //insert instruction to jump to bx lr checking trampoline
            const char* trampoline_bx_lr = "__trampoline_bkwd_bx";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_bx_lr);

        }
        else if(MI->getOpcode() == ARM::LDMIA_RET){

            unsigned num_oprands = MI->getNumOperands();


            // for(int i = 0; i< MI->getNumOperands(); i++){
            //     errs() << MI->getOperand(i).getType() << ": ";
            //     if(MI->getOperand(i).isReg()){
            //         errs() << MI->getOperand(i).getReg();
            //     }
            //     else{
            //         errs() << MI->getOperand(i).getImm();
            //     }
            //     errs() << " ";
            // }
            // errs() << "\n";


            //TODO fix conditional POP_RET
            for(int i = 0; i < MI->getNumOperands(); i++){
                if(MI->getOperand(i).isImm() && MI->getOperand(i).getImm()!=14){
                    return 0;
                }
            }

            for(unsigned i = 0; i < num_oprands; i++){
                if(MI->getOperand(i).isReg() && MI->getOperand(i).getReg() == ARM::PC){
                    // errs() << "!!!!!!!!";
                    // errs() << "meet pc";
                    // errs() << "!!!!!!!!\n"; 
                    //replace pop {..., pc} to pop {..., r8} 
                    // MI->getOperand(i).setReg(ARM::R8);



                    // BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::LDR_PRE_IMM))
                    // BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::LDRi12))
                    // BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::LDR_POST_IMM))
                    //     // .addReg(ARM::R8, RegState::Define)
                    //     .addReg(ARM::R8)
                    //     .addReg(5)          //useless              
                    //     .addReg(ARM::SP)
                    //     .addImm(5) //useless
                    //     .addImm(4) //post offset
                    //     .addImm(14);//conditional codes


                    //start commend here
                    MI->RemoveOperand(i);

                    //saving lr
                    BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::STR_PRE_IMM))
                        .addReg(ARM::LR, RegState::Define )
                        .addReg(ARM::LR )          //useless              
                        .addReg(ARM::SP )
                        .addImm(-4)               //pre offset
                        // .addImm(14) //post offset
                        .addImm(14);              //conditional codes

                    const char* trampoline_pop_ret = "__trampoline_bkwd_pop";
                    // BuildMI(*MBB,BBI,dl,TII.get(ARM::B)).addExternalSymbol(trampoline_pop_ret);
                    BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_pop_ret);
                    break;

                }
            }
        }
    }

    void CPT_Direct_Transfer(MachineBasicBlock::iterator &BBI,SmallVector<MachineInstr *, 500> &DelInstVect, MachineBasicBlock *MBB, const TargetInstrInfo &TII){
        
        // errs() << "!!!!!!!!!!Processing CPT_Transfer Instruction!!!!!!!!!!\n";
        DebugLoc dl = DebugLoc();

        MachineInstr* MI = &*BBI;

        // if(!MI->getOperand(0).isGlobal()){
        //     errs() << "Not Global\n";
        //     errs() << MI->getOperand(0).getType() << "\n";
        // }

        if(MI->getOperand(0).isGlobal()){

            // errs() << "~~~~~MOVi16\n";
            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
                .addReg(ARM::R8)
                .addGlobalAddress(MI->getOperand(0).getGlobal(),0,1)
                .addImm(14)
                .addReg(0);

            // errs() << "~~~~~MOVTi16\n";
             
            MachineInstrBuilder MIB = BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVTi16), ARM::R8);
            MIB.addReg(ARM::R8);
            MIB.addGlobalAddress(MI->getOperand(0).getGlobal(),0,2);
            AddDefaultPred(MIB);

            //sp = sp - 4
            //str lr, [sp]_ZN18AC_AttitudeControl17euler_accel_limitE7Vector3IfES1_
            BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                .addReg(ARM::LR)
                .addReg(ARM::LR)
                .addReg(ARM::SP)
                .addImm(-4)
                .addImm(14);

            //blx recording trampoline
            //TODO: modify the name of trampoline
            // if(MI->getOpcode() == ARM::BL || MI->getOpcode() == ARM::BL_pred){
            if((MI->getOpcode() == ARM::BL) || (MI->getOpcode() == ARM::BL_pred && MI->getOperand(1).getImm() == ARMCC::AL) ){

                // errs() << "pos1\n";

                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_link_recording";
                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
                // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
                // DelInstVect.push_back(MI);     
                // we don't needs to delete this instruciton because it is not a indirect jump

            }
            else if((MI->getOpcode() == ARM::BL_pred) && (MI->getOperand(1).getImm() != ARMCC::AL)){


                //save r1
                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                    .addReg(ARM::R1, RegState::Define)
                    .addReg(ARM::R1)          //useless              
                    .addReg(ARM::SP)
                    .addImm(-4)               //pre offset
                    .addImm(14);              //conditional codes 


                //save r2
                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                    .addReg(ARM::R2, RegState::Define)
                    .addReg(ARM::R2)          //useless              
                    .addReg(ARM::SP)
                    .addImm(-4)               //pre offset
                    .addImm(14);              //conditional codes 

                //move cpsr to r1
                
                BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R1)
                    .addImm(14);

                //move conditional type to r2

                unsigned condCode = MI->getOperand(1).getImm();
                BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
                    .addImm(condCode)
                    .addImm(14)
                    .addReg(0)
                    .addReg(0);

                // errs() << "pos2\n";

                //jump to record
                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_link_cc_recording";
                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);

                //restore r2
                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                    .addReg(ARM::R2, RegState::Define)
                    .addReg(ARM::R2, RegState::Define)//useless              
                    .addReg(ARM::SP, RegState::Define)
                    .addImm(0) //useless
                    .addImm(4) //post offset
                    .addImm(14);//conditional codes

                //restore r1
                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                    .addReg(ARM::R1, RegState::Define)
                    .addReg(ARM::R1, RegState::Define)//useless              
                    .addReg(ARM::SP, RegState::Define)
                    .addImm(0) //useless
                    .addImm(4) //post offset
                    .addImm(14);//conditional codes


            }
            else if((MI->getOpcode() == ARM::B) || ((MI->getOpcode() == ARM::Bcc && MI->getOperand(1).getImm() == ARMCC::AL))){

                // errs() << "pos3\n";

                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_recording";
                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
                // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
                // DelInstVect.push_back(MI); 
                // we don't needs to delate this instruction 

            }
            else if(MI->getOpcode() == ARM::Bcc && MI->getOperand(1).getImm() != ARMCC::AL){
                
                //save r1
                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                    .addReg(ARM::R1, RegState::Define)
                    .addReg(ARM::R1)          //useless              
                    .addReg(ARM::SP)
                    .addImm(-4)               //pre offset
                    .addImm(14);              //conditional codes 



                //save r2
                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                    .addReg(ARM::R2, RegState::Define)
                    .addReg(ARM::R2)          //useless              
                    .addReg(ARM::SP)
                    .addImm(-4)               //pre offset
                    .addImm(14);              //conditional codes 

                //move cpsr to r1
                
                BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R1)
                    .addImm(14);

                //move conditional type to r2

                unsigned condCode = MI->getOperand(1).getImm();
                BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
                    .addImm(condCode)
                    .addImm(14)
                    .addReg(0)
                    .addReg(0);

                // errs() << "pos4\n";
                //jump to record
                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_cc_recording";
                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);


                //restore r2
                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                    .addReg(ARM::R2, RegState::Define)
                    .addReg(ARM::R2, RegState::Define)//useless              
                    .addReg(ARM::SP, RegState::Define)
                    .addImm(0) //useless
                    .addImm(4) //post offset
                    .addImm(14);//conditional codes

                //restore r1
                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                    .addReg(ARM::R1, RegState::Define)
                    .addReg(ARM::R1, RegState::Define)//useless              
                    .addReg(ARM::SP, RegState::Define)
                    .addImm(0) //useless
                    .addImm(4) //post offset
                    .addImm(14);//conditional codes

            }

            //ldr lr, [sp]
            //sp = sp +4
            BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                .addReg(ARM::LR, RegState::Define)
                .addReg(ARM::LR, RegState::Define)//useless              
                .addReg(ARM::SP, RegState::Define)
                .addImm(0) //useless
                .addImm(4) //post offset
                .addImm(14);//conditional codes

            //TODO B and B_pred
        }

        else if(MI->getOperand(0).isMBB()){
            // errs() << "opcode:" << MI->getOpcode() << "\n";
            // const BasicBlock * basicblock = MI->getOperand(0).getBasicBlock();
            // errs() << "start insert\n";
            // errs() << "MOVi16\n";
            
            //iterate machine basic blocks

            MachineBasicBlock *internal_MBB = MI->getOperand(0).getMBB();

            for (MachineBasicBlock::iterator internal_BBI = internal_MBB->begin(), internal_BBE = internal_MBB->end();
                     internal_BBI != internal_BBE; ++internal_BBI) {

                MachineInstr* internal_MI = &*internal_BBI;
               //find the first transfer instruction
                switch(internal_MI->getOpcode()){
                    case ARM::B:
                    case ARM::Bcc:
                    case ARM::BL:
                    case ARM::BL_pred:{

                        if(internal_MI->getOperand(0).isGlobal()){
                            // errs() << "~~~~~MOVi16\n";
                            BuildMI(*internal_MBB, internal_BBI, dl, TII.get(ARM::MOVi16))
                                .addReg(ARM::R8)
                                .addGlobalAddress(internal_MI->getOperand(0).getGlobal(),0,1)
                                .addImm(14)
                                .addReg(0);

                            // errs() << "~~~~~MOVTi16\n";
                            MachineInstrBuilder MIB = BuildMI(*internal_MBB, internal_BBI, dl, TII.get(ARM::MOVTi16), ARM::R8);
                            MIB.addReg(ARM::R8);
                            MIB.addGlobalAddress(internal_MI->getOperand(0).getGlobal(),0,2);
                            AddDefaultPred(MIB);
                            
                            // errs() << "finishing global address setting\n";

                            //sp = sp - 4
                            //str lr, [sp]
                            BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                                .addReg(ARM::LR)
                                .addReg(ARM::LR)
                                .addReg(ARM::SP)
                                .addImm(-4)
                                .addImm(14);

                            //blx recording trampoline

                            if((MI->getOpcode() == ARM::BL) || (MI->getOpcode() == ARM::BL_pred && MI->getOperand(1).getImm() == ARMCC::AL)){
                                
                                // errs() << "pos5\n";
                                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_link_recording";
                                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
                                // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
                                // DelInstVect.push_back(MI);     
                                // we don't needs to delete this instruciton because it is not a indirect jump
                            }
                            else if((MI->getOpcode() == ARM::BL_pred) && (MI->getOperand(1).getImm() != ARMCC::AL)){

                                //save r1
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                                    .addReg(ARM::R1, RegState::Define)
                                    .addReg(ARM::R1)          //useless              
                                    .addReg(ARM::SP)
                                    .addImm(-4)               //pre offset
                                    .addImm(14);              //conditional codes 


                                //save r2
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                                    .addReg(ARM::R2, RegState::Define)
                                    .addReg(ARM::R2)          //useless              
                                    .addReg(ARM::SP)
                                    .addImm(-4)               //pre offset
                                    .addImm(14);              //conditional codes 

                                //move cpsr to r1
                                
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R1)
                                    .addImm(14);


                                //move conditional type to r2

                                unsigned condCode = MI->getOperand(1).getImm();


                                // std::cout << condCode << std::endl;


                                BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
                                    .addImm(condCode)
                                    .addImm(14)
                                    .addReg(0)
                                    .addReg(0);

                                // errs() << "pos6\n";

                                //jump to record
                                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_link_cc_recording";
                                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);

                                //restore r2
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                                    .addReg(ARM::R2, RegState::Define)
                                    .addReg(ARM::R2, RegState::Define)//useless              
                                    .addReg(ARM::SP, RegState::Define)
                                    .addImm(0) //useless
                                    .addImm(4) //post offset
                                    .addImm(14);//conditional codes

                                //restore r1
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                                    .addReg(ARM::R1, RegState::Define)
                                    .addReg(ARM::R1, RegState::Define)//useless              
                                    .addReg(ARM::SP, RegState::Define)
                                    .addImm(0) //useless
                                    .addImm(4) //post offset
                                    .addImm(14);//conditional codes

                            }
                            else if((MI->getOpcode() == ARM::B) || ((MI->getOpcode() == ARM::Bcc && MI->getOperand(1).getImm() == ARMCC::AL))){
                                 // errs() << "pos7\n";

                                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_recording";
                                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
                                // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
                                // DelInstVect.push_back(MI); 
                                // we don't needs to delate this instruction 

                            }
                            else if(MI->getOpcode() == ARM::Bcc && MI->getOperand(1).getImm() != ARMCC::AL){
                                

                                //save r1
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                                    .addReg(ARM::R1, RegState::Define)
                                    .addReg(ARM::R1)          //useless              
                                    .addReg(ARM::SP)
                                    .addImm(-4)               //pre offset
                                    .addImm(14);              //conditional codes 


                                //save r2
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                                    .addReg(ARM::R2, RegState::Define)
                                    .addReg(ARM::R2)          //useless              
                                    .addReg(ARM::SP)
                                    .addImm(-4)               //pre offset
                                    .addImm(14);              //conditional codes 

                                //move cpsr to r1
                                
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R1)
                                    .addImm(14);


                                //move conditional type to r2

                                unsigned condCode = MI->getOperand(1).getImm();
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
                                    .addImm(condCode)
                                    .addImm(14)
                                    .addReg(0)
                                    .addReg(0);


                                // errs() << "pos8\n";

                                //jump to record
                                const char* tpl_tsf_indirect_jmp_checking = "__tsf_direct_jmp_cc_recording";
                                BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);


                                //restore r2
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                                    .addReg(ARM::R2, RegState::Define)
                                    .addReg(ARM::R2, RegState::Define)//useless              
                                    .addReg(ARM::SP, RegState::Define)
                                    .addImm(0) //useless
                                    .addImm(4) //post offset
                                    .addImm(14);//conditional codes

                                //restore r1
                                BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                                    .addReg(ARM::R1, RegState::Define)
                                    .addReg(ARM::R1, RegState::Define)//useless              
                                    .addReg(ARM::SP, RegState::Define)
                                    .addImm(0) //useless
                                    .addImm(4) //post offset
                                    .addImm(14);//conditional codes

                            }

                            //ldr lr, [sp]
                            //sp = sp +4
                            BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                                .addReg(ARM::LR, RegState::Define)
                                .addReg(ARM::LR, RegState::Define)//useless              
                                .addReg(ARM::SP, RegState::Define)
                                .addImm(0) //useless
                                .addImm(4) //post offset
                                .addImm(14);//conditional codes

                        }
                        else{
                            errs() << "!!!!!!!!!!!!MEET BIG PROBLEM!!!!!!!!!!!!!!\n";
                        }

                    }
                }
                break;                      
            }
        }

        //===================================================================
        //move direct jump target into R8 using movw and movt
        // MachineInstrBuilder MIB;
        // MIB = BuildMI(*MBB, BBI, dl,TII.get(ARM::MOVi16), ARM::R8);
        // MIB.addGlobalAddress(MI->getOperand(0).getGlobal(),0,1);
        // AddDefaultPred(MIB);

        // //movt
        // MIB = BuildMI(*MBB, BBI, dl,TII.get(ARM::MOVTi16), ARM::R8);
        // MIB.addReg(ARM::LR);
        // MIB.addGlobalAddress(MI->getOperand(0).getGlobal(),0,2);
        // MIB.addImm(14);

        //delete original direct jump and jump to __tsf_direct_jmp_checking
        //__tsf_direct_jmp_checking will checking validity of compartment transfer and
        //perform jump
        // errs() << "!!!!!!!!!!Finish Transfer through BL!!!!!!!!!!\n";
    }

    void CPT_Indirect_Transfer(MachineBasicBlock::iterator &BBI, SmallVector<MachineInstr *, 500> &DelInstVect, MachineBasicBlock *MBB, const TargetInstrInfo &TII){

        // return;

        DebugLoc dl = DebugLoc();
        // BBI++;
        MachineInstr* MI = &*BBI;

        //we also need to implement a trampoline, in the trampoine, following instruction will be executed
        //blx transfer_recording c funciton, c function will record the value of r8
        //blx r8 or bx r8

        //jinwen comment this for debug ==================new implementataion=====================

        //for each blx/bx rx

        //mov r8 rx
        //move indirect jump target into R8 
        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
            .addReg(ARM::R8)
            .addReg(MI->getOperand(0).getReg())
            .addImm(14)
            .addReg(0)
            .addReg(0);


        //sp = sp - 4
        //str lr, [sp]
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR)
            .addReg(ARM::LR)
            .addReg(ARM::SP)
            .addImm(-4)
            .addImm(14);


        //blx recording trampoline
        //TODO: modify the name of trampoline
        if(MI->getOpcode() == ARM::BLX){
            // errs() << "=========ARM::BLX========\n";
            const char* tpl_tsf_indirect_jmp_checking = "__tsf_indirect_jmp_link_recording";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
            // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
            DelInstVect.push_back(MI);   

        }
        else if(MI->getOpcode() == ARM::BLX_pred){
            // errs() << "=========ARM::BLX_pred========\n";
            //jinweTODO, deliver condition info in trampoline and check it during measuring
        }
        else if(MI->getOpcode() == ARM::BX){
            // errs() << "=========ARM::BX========\n";

            const char* tpl_tsf_indirect_jmp_checking = "__tsf_indirect_jmp_recording";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
            // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
            DelInstVect.push_back(MI);  

        }
        else if(MI->getOpcode() == ARM::BX_pred){
            // errs() << "-----------ARM::BX_pred-----------\n";
        }

        //ldr lr, [sp]
        //sp = sp +4
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        return;




        //jinwen comment this for debug ==================previous implementataion=====================


        // while(MI->getOpcode() != ARM::BLX && MI->getOpcode() != ARM::BX){
        //     BBI ++;
        //     MI = &*BBI;
        // }

        // MI = &*BBI;
        
        // for(int i = 0; i < MI->getNumOperands(); i++){
        //     errs() << i << "oprd:"<<MI->getOperand(i) << "\n";
        // }

        //move indirect jump target into R8 
        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
            .addReg(ARM::R8)
            .addReg(MI->getOperand(0).getReg())
            .addImm(14)
            .addReg(0)
            .addReg(0);


        
        //delete original direct jump and jump to __tsf_indirect_jmp_checking
        //__tsf_indirect_jmp_checking will check validity of compartment transfer and perform jump
        if(MI->getOpcode() == ARM::BLX){
            // test_fwd_indirect_tsf
            // const char* tpl_tsf_indirect_jmp_checking = "test_fwd_indirect_tsf";
            //jinwen comment for debug
            const char* tpl_tsf_indirect_jmp_checking = "__tsf_indirect_jmp_link_checking";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
            // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
            DelInstVect.push_back(MI);            
        }
        //folloing codes are not executed
        else if(MI->getOpcode() == ARM::BX){
            const char* tpl_tsf_indirect_jmp_checking = "__tsf_indirect_jmp_checking";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::B)).addExternalSymbol(tpl_tsf_indirect_jmp_checking);
            // BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_direct_jmp_checking);
            DelInstVect.push_back(MI);  
        }
    }


    void CPT_Bkword_Transfer(MachineBasicBlock::iterator &BBI, SmallVector<MachineInstr *, 500> &DelInstVect, MachineBasicBlock *MBB, const TargetInstrInfo &TII){
    
        // return;
        //find return first
        DebugLoc dl = DebugLoc();
        MachineInstr* MI = &*BBI;

        //BX LR Transfer
        // errs() << MBB->getParent()->getName() << "\n";

        if(MI->getOpcode() == ARM::BX_RET){
            // errs() << "bx_ret transfer\n";
            //insert instruciton to move lr into reserved register
            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
                .addReg(ARM::R8)
                .addReg(ARM::LR)
                .addImm(14)
                .addReg(0)
                .addReg(0); 
            
            //insert instruction to jump to bx lr checking trampoline
            
            //saving lr
            BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
                .addReg(ARM::LR, RegState::Define )
                .addReg(ARM::LR )          //useless              
                .addReg(ARM::SP )
                .addImm(-4)               //pre offset
                // .addImm(14) //post offset
                .addImm(14);              //conditional codes


            // BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            //     .addReg(ARM::SP)
            //     .addReg(ARM::SP)
            //     .addImm(4)
            //     .addImm(14)
            //     .addReg(0)
            //     .addReg(0);

            //B has problem
            // const char* trampoline_bx_lr = "__tsf_bkwd_bx_lr_checking";
            const char* trampoline_bx_lr = "__tsf_bkwd_bx_lr_recording";
            BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_bx_lr);
            DelInstVect.push_back(MI);  


            //restoring lr
            BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
                .addReg(ARM::LR, RegState::Define)
                .addReg(ARM::LR, RegState::Define)//useless              
                .addReg(ARM::SP, RegState::Define)
                .addImm(0) //useless
                .addImm(4) //post offset
                .addImm(14);//conditional codes

        }

        //jinwen wirte this for debug
        // return;

        //POP RET Transfer
        if(MI->getOpcode() == ARM::LDMIA_RET){
            // errs() << "pop_ret transfer\n";
            // return;
            unsigned num_oprands = MI->getNumOperands();
            for(unsigned i = 0; i < num_oprands; i++){

                if(MI->getOperand(i).isReg() && MI->getOperand(i).getReg() == ARM::PC){
                    //remove pc from pop targets
                    //attention this has problem
                    MI->RemoveOperand(i);
                    // break;

                    //saving lr

                    // BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::STR_PRE_IMM))
                    //     .addReg(ARM::LR, RegState::Define)
                    //     .addReg(ARM::LR)          //useless              
                    //     .addReg(ARM::SP)
                    //     .addImm(-4)               //pre offset
                    //     .addImm(14);              //conditional codes

                    BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::LDR_POST_IMM))
                        .addReg(ARM::R8, RegState::Define)
                        .addReg(ARM::R8, RegState::Define)//useless              
                        .addReg(ARM::SP, RegState::Define)
                        .addImm(0) //useless
                        .addImm(4) //post offset
                        .addImm(14);//conditional codes

                    //insert backward compartment transfer return trampoline
                    // const char* trampoline_pop_ret = "__tsf_bkwd_pop_pc_checking";
                    const char* trampoline_pop_ret = "__tsf_bkwd_pop_pc_recording";
                    BuildMI(*MBB,MBB->end(),dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_pop_ret);

                    break;
                    // MachineInstrBuilder MIB = BuildMI(*MBB, MBB->end(), dl, TII.get(ARM::B));
                    // const char* trampoline_pop_ret = "__tsf_bkwd_pop_pc_checking";
                    // MIB.addExternalSymbol(trampoline_pop_ret);

                }
            }
        }

    }


    void Wrt_SFI_Instrumentation(MachineBasicBlock::iterator &BBI, SmallVector<MachineInstr *, 500> &DelInstVect, \
        MachineBasicBlock *MBB, const TargetInstrInfo &TII, int base_addr, int mask, MachineFunction &MF){

        DebugLoc dl = DebugLoc();
        MachineInstr* MI = &*BBI;        

        //decide whether the memory register is fp, ip, sp, lr, pc
        // if(MI->getOperand(1).getReg()>=ARM::R11 && MI->getOperand(1).getReg()<=ARM::PC){
        //     errs() << "pass processing\n";
        // }

        // if(MI->getOperand(1).getReg()==ARM::R11){
        //     errs() << "pass processing fp\n";
        // }



        unsigned mem_wrt_base_reg = MI->getOperand(1).getReg();
        if(mem_wrt_base_reg == ARM::SP || mem_wrt_base_reg == ARM::R11){
            // errs() << "pass processing sp\n";
            return;
        }


        if(MI->getOperand(2).getImm() > 0 && MI->getOperand(2).getImm() < 100){
            // errs() << "pass process none 0 immediate\n";
            return;
        }

        if(MI->getOpcode() != ARM::STRi12){
            return;
        }


        //jinwen added for find opcode
        // std::string debug_funciton = "_ZL18simulation_timevalP7timeval";
        // int opcode = MI->getOpcode();
        // if(MF.getName() == debug_funciton){
        //     errs() <<  TII.getName(opcode) << "\n";
        //     errs() << MI->getOperand(2).getImm() << "\n";

        // }

        //decide whether there is immeidate
        // if(MI->getOperand(2).isImm()){

        //     errs() << MI->getOperand(2) << "\n";

        // }


        // if(MI->getNumOperands() == 3 && MI->getOperand(2).isImm()){
        //     errs() << "memory write with immediate\n";
        // }
        // else if(MI->getNumOperands() == 2){
        //     errs() << "memory write without immediate!!!!!\n";
        // }





        //delete this instruction later
        DelInstVect.push_back(MI);


        // load basic address into r8
        // errs() << "~~~~~MOVi16\n";
        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
            .addReg(ARM::R8)
            .addImm(base_addr & 0xffff)
            .addImm(14)
            .addReg(0);

        // errs() << "~~~~~MOVTi16\n";
         
        MachineInstrBuilder MIB = BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVTi16), ARM::R8);
        MIB.addReg(ARM::R8);
        MIB.addImm((base_addr >> 16) & 0xffff);
        AddDefaultPred(MIB);



        //we can get the instruction through MI->getOpcode()
        //str rx, [r8]
        if( MI->getOpcode() == ARM::STRi12){

            //insert bfi instruction
            //bfi r8, rx, #0, #12
            //bif r8, ry, #0, #mask
            BuildMI(*MBB, BBI, dl, TII.get(ARM::BFI))
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::R8, RegState::Define) //useless            
            // .addReg(MI->getOperand(0).getReg(),RegState::Define)
            .addReg(MI->getOperand(1).getReg())
            // .addReg(ARM::R8, RegState::Define) //useless            
            .addImm(~((1<<mask)-1))
            .addImm(14);

            BuildMI(*MBB, BBI, dl, TII.get(MI->getOpcode()))
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::STRi12))
            .addReg(MI->getOperand(0).getReg())
            .addReg(ARM::R8)
            .addImm(0)
            .addMemOperand(MBB->getParent()->getMachineMemOperand(
             llvm::MachinePointerInfo(), llvm::MachineMemOperand::MOStore,
            4, 4))
            .addImm(14);            
        }
        //TODO each one should be treated differently
        else if(MI->getOpcode() == ARM::STRD){
            BuildMI(*MBB, BBI, dl, TII.get(MI->getOpcode()))
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::STRi12))
            .addReg(MI->getOperand(0).getReg())
            .addReg(ARM::R8)
            .addImm(0)
            .addMemOperand(MBB->getParent()->getMachineMemOperand(
             llvm::MachinePointerInfo(), llvm::MachineMemOperand::MOStore,
            8, 4))
            .addImm(14);  
        }


    }



    void Store_SFI_Instrumentation(MachineBasicBlock::iterator &BBI, SmallVector<MachineInstr *, 500> &DelInstVect, MachineBasicBlock *MBB, const TargetInstrInfo &TII){
        

        DebugLoc dl = DebugLoc();
        MachineInstr* MI = &*BBI;
        
        //push opcode

        // int inst_id = MI->getOpcode();


        //debug here
        errs() << MI->getNumOperands() << " ";
        for(int i = 0; i< MI->getNumOperands(); i++){
            //errs() << MI->getOperand(i).getType() << ": ";
            if(MI->getOperand(i).isReg()){
                errs() << MI->getOperand(i).getReg();
            }
            else{
                errs() << MI->getOperand(i).getImm();
            }
            errs() << " ";
        }
        errs() << "\n";


        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16), ARM::R8)
            .addImm(MI->getOpcode())          
            .addImm(14)
            .addReg(0);


        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::R8)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes


        // //restoring sp value becuase target address may use sp
        BuildMI(*MBB, BBI, dl, TII.get(ARM::ADDri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(4)
            .addImm(14)
            .addReg(0)
            .addReg(0); 


        //add or sub r8, target address register, offset
        if(MI->getOperand(2).getImm() >= 0){


            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
                .addReg(ARM::R8)
                .addImm(MI->getOperand(2).getImm())
                .addImm(14)
                .addReg(0);

            // errs() << "~~~~~MOVTi16\n";
             
            // MachineInstrBuilder MIB = BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVTi16), ARM::R8);
            // MIB.addReg(ARM::R8);
            // MIB.addImm(MI->getOperand(2).getImm());
            // AddDefaultPred(MIB);       

            BuildMI(*MBB, BBI, dl, TII.get(ARM::ADDrr))               
                .addReg(ARM::R8)
                .addReg(ARM::R8)
                .addReg(MI->getOperand(1).getReg())
                .addImm(14)
                .addReg(0)
                .addReg(0); 


            // BuildMI(*MBB, BBI, dl, TII.get(ARM::ADDri))               
            //     .addReg(ARM::R8)
            //     .addReg(MI->getOperand(1).getReg())
            //     .addImm(MI->getOperand(2).getImm())
            //     .addImm(14)
            //     .addReg(0)
            //     .addReg(0); 
        }
        else{


            BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
                .addReg(ARM::R8)
                .addImm(-1 * MI->getOperand(2).getImm())
                .addImm(14)
                .addReg(0);


            BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBrr))               
                .addReg(ARM::R8)
                .addReg(MI->getOperand(1).getReg())
                .addReg(ARM::R8)
                .addImm(14)
                .addReg(0)
                .addReg(0); 



            // BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            //     .addReg(ARM::R8)
            //     .addReg(MI->getOperand(1).getReg())
            //     .addImm(-1 * MI->getOperand(2).getImm())
            //     .addImm(14)
            //     .addReg(0)
            //     .addReg(0); 
        }
 
        //resotring sp value caused by pushing opcode onto stack
        BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(4)
            .addImm(14)
            .addReg(0)
            .addReg(0); 


        //push value to be strored into memory
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            // .addReg(ARM::R8, RegState::Define)
            .addReg(MI->getOperand(0).getReg(), RegState::Define)
            .addReg(MI->getOperand(0).getReg())          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes

        //push lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            // .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes    


        //invoke trampoling to checking storing instruction
        const char* trampoline_str_checking = "__storing_checking";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_str_checking);


        //context stroing
        //pop lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            // .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        BuildMI(*MBB, BBI, dl, TII.get(ARM::ADDri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(8)
            .addImm(14)
            .addReg(0)
            .addReg(0);    

        return;

    }




    //json object manipulation reference
    //  void assignLinkerSections(Module &M, Json::Value &Root){
    //     Json::Value PolicyRegions=Root.get("Regions","");
    //     for(auto RegionName: PolicyRegions.getMemberNames()){
    //         Json::Value Region = PolicyRegions[RegionName];
    //         Json::Value region_type = Region["Type"];
    //         if ( region_type.compare("Code") == 0 ){
    //             for (auto funct : Region.get("Objects","")){
    //                 Function * F = M.getFunction(StringRef(funct.asString()));
    //                 if (F){
    //                     F->setSection(StringRef(RegionName));
    //                 }else{
    //                     std::cout << "No Name Function for: "<< funct <<"\n";
    //                 }
    //             }
    //         }else{
    //             std::string DataSection(RegionName+"_data");
    //             std::string BSSSection(RegionName+"_bss");
    //             for (auto gvName : Region.get("Objects","")){
    //                 GlobalVariable *GV;
    //                 GV = M.getGlobalVariable(StringRef(gvName.asString()),true);
    //                 if (GV){
    //                     if ( GV->hasInitializer() ){
    //                         if (GV->getInitializer()->isZeroValue()){
    //                             GV->setSection(StringRef(BSSSection));
    //                          }else{
    //                             GV->setSection(StringRef(DataSection));
    //                          }
    //                      }else{
    //                          assert(false &&"GV Has no initializer");
    //                      }
    //                  }
    //                  else{
    //                      std::cout << "No Name GV for: "<< gvName <<"\n";
    //                  }
    //              }//for
    //         }
    //     }
    // }


    // std::map<std::string, int> func2sec;

    void build_func2sec(){

        Json::Value CPT_Root;
        std::ifstream CPT_File;
        CPT_File.open("./compartments_result.json");
        CPT_File >> CPT_Root;
        Json::Value PolicyRegions = CPT_Root.get("Regions","");
        for(auto RegionName: PolicyRegions.getMemberNames()){
            Json::Value Region = PolicyRegions[RegionName];
            Json::Value region_type = Region["Type"];
            if( region_type.compare("Code") == 0){
                for (auto funct: Region.get("Objects","")){
                    func2sec[funct.asString()] = RegionName;
                }
            }
        }
        // for(const auto& pair : func2sec){
        //     std::cout << "Key: " << pair.first << ", Value: " << pair.second << std::endl;
        // }
    }


    // std::map<int, std::vector<int>> sectaddrmask;


    void build_sectaddrmask(){

        // Open the file storing the section start address and masks
       std::ifstream file("./sec_mask_result.txt");  // Replace with your filename
        if (!file) {
            std::cerr << "Unable to open file";
            return ;  // exit if file couldn't be opened
        }

        std::string line;
        int curr_cpt_idx = 1;
        while (std::getline(file, line)) {
            std::istringstream iss(line);
            std::string hex_str, dec_str;
            if (!(iss >> hex_str >> dec_str)) {
                break;  // error in reading line or EOF
            }

            // Ignore '0x' at the start of the hex_str
            if (hex_str.size() >= 2 && hex_str.substr(0, 2) == "0x") {
                hex_str = hex_str.substr(2);
            }

            // Convert hex_str from hexadecimal to int
            int hex_val;
            std::stringstream ss;
            ss << std::hex << hex_str;  // set hex flag
            ss >> hex_val;             // convert hexadecimal string to int

            // Convert dec_str from decimal to int
            int dec_val = std::stoi(dec_str);  // convert decimal string to int

            std::vector<int> addrmask = {hex_val, dec_val};

            sectaddrmask[curr_cpt_idx] = addrmask;
            curr_cpt_idx += 1;

            // Print the converted values
            // std::cout << "Hexadecimal value: " << hex_val << ", Decimal value: " << dec_val << std::endl;
        }

        file.close();

    }


    //CFE_type 
    //0:Indirect Call;
    //1:Indirect Jump;
    //2:BX_RET;
    //3:LDMIA_RET;
    //4:Conditional Branch;



    std::map<std::string, int> crit_cpt_map;


    // Function Definition
    std::map<std::string, int> readLinesIntoMap(const std::string& filename) {
        std::map<std::string, int> result;

        std::ifstream file(filename);
        if (!file.is_open()) {
            // throw std::runtime_error("Could not open file " + filename);
            errs() << "Could not open file" << filename << "\n";
        }

        std::string line;
        while (std::getline(file, line)) {
            result[line] = 0;
        }

        return result;
    }


    std::string crit_cpt_filename = "./crit_cpt.txt";


    void CFEvent_Instru_Init(){


        crit_cpt_map = readLinesIntoMap(crit_cpt_filename);

        // for (const auto &pair : crit_cpt_map) {
        //     std::cout << "Key: " << pair.first << ", Value: " << pair.second << '\n';
        // }

        return;
    }

    int init_flag = 0;


    class SandboxPass : public MachineFunctionPass {
    
    public:
        static char ID;
 
        int one_time_flag = 0;
        int main_cnt = 0;

        int istmt_start_id = 722;
        int istmt_end_id = 722;
        int istmt_curr_id = 0;

        int debug_cnt = 0;

        //find return instruction and record source and destination address
        SandboxPass() : MachineFunctionPass(ID) {}
        virtual bool runOnMachineFunction(MachineFunction &MF) {     

            //disabling this pass
            // return false;

            if(!init_flag){
                build_func2sec();
                build_sectaddrmask();
                CFEvent_Instru_Init();
                init_flag = 1;
            }

            int critical_flag = 0;

            const Function *F = MF.getFunction();
            std::string curr_func_name = F->getName();

            //check whether this function is in critical compartment
            //if yes, set the critical_flag to 1
            if (F) {
                if (auto *DISub = F->getSubprogram()) {
                    llvm::StringRef curr_filename = DISub->getFile()->getFilename();
                    // Do something with filename

                    auto it = crit_cpt_map.find(curr_filename);

                    if(it!=crit_cpt_map.end()){
    
                        //jinwen add this filter for debug
                        // if(MF.getName() != "_ZN18AC_AttitudeControl43input_euler_angle_roll_pitch_euler_rate_yawEfff"){
                        //     return false;
                        // }
                        critical_flag = 1;
                    }
                    else{
                        critical_flag = 0;
                    }
                }
            }

            //get the compartment of current function

            std::map<std::string, std::string>::iterator it_func2sec = func2sec.find(curr_func_name);

            int curr_cpt_idx = 0;

            int curr_cpt_base_addr = 0;

            int curr_cpt_mask = 0;

            if(it_func2sec != func2sec.end()){
                // std::cout << func2sec[curr_func_name] << std::endl;
                // _GLOBAL__sub_I_AC_Avoid.cpp section 6
                std::string str_sect = func2sec[curr_func_name];
                if (str_sect.length() >= 2) {
                  char second_last_char = str_sect[str_sect.length() - 2];
                  if (isdigit(second_last_char)) {
                    int second_last_digit = second_last_char - '0';
                    curr_cpt_idx = second_last_char - '0';
                    // if(curr_cpt_idx != 4){
                    //     std::cout << "Second last digit: " << second_last_digit << std::endl;
                    // }
                  } else {
                    std::cout << "The second last character is not a digit." << std::endl;
                  }
                } else {
                  std::cout << "The string is too short." << std::endl;
                }
            }
            else{
                std::cout << "function not found!!!!!" << std::endl;
            }

            std::vector<int>& curr_addrmask = sectaddrmask[curr_cpt_idx];

            //get current compartment base address
            curr_cpt_base_addr = curr_addrmask[0];
            //get current compartment mask
            curr_cpt_mask = curr_addrmask[1];

            //debug
            // errs() << "+++++++++++++"<<MF.getName() << "+++++++++++++++\n";

            // errs() << "++++++++++++++++++++SFIPASS++++++++++++++++++" <<"\n";

            //disabling this pass
            // return false;

            //not instrument trampoline

            if(MF.getName() == "ict_checking"){
                return false;
            }

            istmt_curr_id += 1;

            // if(istmt_curr_id  >= istmt_start_id && istmt_curr_id <= istmt_end_id){
            //     errs() << istmt_curr_id << " " << MF.getName() << "\n";
            // }

            // if(MF.getName() != "_ZN6Copter9fast_loopEv"){
            //     return false;
            // }

            // if(MF.getName() != "_ZN6Copter9fast_loopEv"){
            //     return false;
            // }

            // if(MF.getName() != "delayMicroseconds"){
            //     return false;
            // }

            // debug
            // if(MF.getName() != "readKey"){
            //     return false;
            // }

            // errs() << "~~~~~~~~~~current processing machine function~~~~~~~~~~~~~~~" << MF.getName() << "\n";

            // if(MF.getName() == "view_switch_to_rd_and_log"){
            //     return false;
            // }

            // if(MF.getName() == "__test"){
            //     return false;
            // }

            // if(MF.getName() == "__conditional_branch_recording"){
            //     return false;
            // }

            // return false;

            // std::cout << "---------start----------" << std::endl;
            // std::cout << ARM::BLX <<std::endl;
            // std::cout << ARM::BLX_pred <<std::endl;
            // std::cout << ARM::BX <<std::endl;
            // std::cout << ARM::BX_pred <<std::endl;
            // std::cout << ARM::BX_RET <<std::endl;

            int transfer_flag = 0;
            int num_of_indirect = 0;

            int wrt_flag = 0;

            int curr_ist = 0;

            DebugLoc dl = DebugLoc();
            for (MachineFunction::iterator I = MF.begin(), E = MF.end(); I != E; ++I) {
                MachineBasicBlock *MBB = &*I;

                // MachineInstr *tobe_deleted_inst = NULL;

                //original instructions to be deleted
                SmallVector<MachineInstr *, 500> DelInstVect;

                for (MachineBasicBlock::iterator BBI = MBB->begin(), BBE = MBB->end();
                     BBI != BBE; ++BBI) {

                    MachineInstr* MI = &*BBI;

                    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
                    
                    const ARMSubtarget &STI = MF.getSubtarget<ARMSubtarget>();

                    const ARMBaseInstrInfo &ARMBII = *static_cast<const ARMBaseInstrInfo *>(MF.getSubtarget().getInstrInfo());

                    //conattest SFI begins

                    //debug
                    // if(false){

                    //jinwen added for find opcode
                    // std::string debug_funciton = "_ZL18simulation_timevalP7timeval";
                    // int opcode = MI->getOpcode();
                    // if(curr_func_name == debug_funciton){
                    //     errs() <<  TII.getName(opcode) << "\n";
                    // }

                    if(true){
                        switch(MI->getOpcode()){
                        
                            //instrument compartment transfer first
                            case ARM::B:
                            case ARM::Bcc:
                            case ARM::BL:
                            case ARM::BL_pred:{
                                // errs() << "linkage type:" << MI->getOperand(0).getGlobal()->getLinkage()<< "\n";

                                // errs() << "is global:" << MI->getOperand(0).isGlobal() << "\n";

                                //exclude function call to  
                                // const char* symicall = "__cfv_icall";
                                // BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(symicall);

                                if( MI->getOperand(0).isGlobal() && MI->getOperand(0).getGlobal()->getLinkage()==0 
                                    && MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__cfv_icall"){
                                    break;
                                }

                                if(MI->getOperand(0).isGlobal() &&  MI->getOperand(0).getGlobal()->getLinkage()==0 
                                    && MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "view_switch_to_rd_and_log"){
                                    break;
                                }
                                

                                if(MI->getOperand(0).isGlobal() &&  MI->getOperand(0).getGlobal()->getLinkage()==0 
                                    && MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "test_cpp_trampoline"){
                                    break;
                                }
                                
                                if(transfer_flag == 1){
                                    transfer_flag = 0;

                                    // errs() << "CPT_Ｄirect" << transfer_flag << "\n";
                                    if(critical_flag == 0){

                                        //jinwen writes this for debug
                                        // errs() << "direct tsf\n";
                                        CPT_Direct_Transfer(BBI, DelInstVect, MBB, TII);

                                    }
                                    // num_of_indirect += 1;
                                    // errs() << "number: " << num_of_indirect << "\n";
                                    break;
                                }

                                if(!(MI->getOperand(0).isGlobal() && MI->getOperand(0).getGlobal()->getLinkage()==0)){
                                    break;
                                }

                                if(MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__AMI_fake_direct_transfer"){
                                    // errs() << "~~~~~~~~~~~~meet BL_pred direct~~~~~~~~~~~~\n";

                                    //iterate to find actually b and bl here
                                    transfer_flag = 1;

                                    DelInstVect.push_back(MI);
                                    // CPT_Direct_Transfer(BBI, BBE, DelInstVect, MBB, TII);

                                }
                                else if(MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__AMI_fake_indirect_transfer"){
                                    // errs() << "~~~~~~~~~~~~meet BL_pred indirect~~~~~~~~~~~~\n";
                                    transfer_flag = 2;
 
                                    //jinwen comment for easing debug
                                    DelInstVect.push_back(MI);
                                    //originally commented
                                    // CPT_Indirect_Transfer(BBI, DelInstVect, MBB, TII);
                                }
                                else if(MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__AMI_fake_rt_transfer"){
                                    transfer_flag = 3;

                                    //delete current instruction
                                    // errs() << "~~~~~~~~~~~~meet BL_pred return~~~~~~~~~~~~\n";
                                    DelInstVect.push_back(MI);
                                    //modifying current instruction to jump to trampoline and bx lr
                                    // CPT_Bkword_Transfer(BBI, DelInstVect, MBB, TII);
                                }
                                else if(MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__AMI_fake_local_wrt"){

                                    //set flags
                                    wrt_flag = 1;

                                    DelInstVect.push_back(MI);   
                                }
                                break;                              
                            }

                            // case ARM::BX_RET:{
                            //     if(transfer_flag == 3){
                            //         transfer_flag = 0;
                            //         errs() << "CPT_Bkword" << transfer_flag << "\n";
                            //         //here
                            //         //jinwen comment for debug other functions
                            //         // break;
                            //         CPT_Bkword_Transfer(BBI, DelInstVect, MBB, TII);
                            //         break;
                            //     }
                            //     //jinwen comment for debug other functions
                            //     break;
                            //     Bkwd_SFI_Instrumentation(MI, MBB, BBI, TII);
                            //     // }
                            //     break;
                            // }

                            //debug
                            //__AMI_fake_indirect_transfer
                            //TODO complete conditional indirect branch
                            //debug str
                            //jinwen commen for debug
                            // break;
                            case ARM::BLX:
                            case ARM::BLX_pred:
                            case ARM::BX:
                            case ARM::BX_pred:{
                                if(transfer_flag == 2){
                                    transfer_flag = 0;
                                    // errs() << "CPT_Indirect" << transfer_flag << "\n";
                                    //jinwen comment for debug other functions
                                    // break;

                                    //critical compartment will handle indirect by
                                    //themselves
                                    if(critical_flag == 0){
                                        CPT_Indirect_Transfer(BBI, DelInstVect, MBB, TII);
                                    }

                                    break;
                                }
                                // errs() << "NO_CPT_Indirect\n";
                                // here
                                //jinwen commnet for debug
                                // break;
                                if(critical_flag == 0){
                                    DelInstVect.push_back(MI);
                                    Fwd_SFI_Instrumentation(MI, MBB, BBI, TII, curr_cpt_base_addr, curr_cpt_mask);
                                }
                                // tobe_deleted_inst = MI;
                                break;
                            }
  
                            case ARM::BX_RET:{
                                if(transfer_flag == 3){
                                    transfer_flag = 0;
                                    errs() << "CPT_Bkword" << transfer_flag << "\n";
                                    //here
                                    //jinwen comment for debug other functions
                                    // break;
                                    if(critical_flag == 0){
                                        CPT_Bkword_Transfer(BBI, DelInstVect, MBB, TII);
                                    }
                                    break;
                                }
                                //jinwen comment for debug other functions
                                break;
                                Bkwd_SFI_Instrumentation(MI, MBB, BBI, TII);
                                // }
                                break;
                            }
                            case ARM::LDMIA_RET:{
                                if(transfer_flag == 3){
                                    transfer_flag = 0;         // case ARM::VSTRS:
                            // case ARM::VSTRD:
                            // case ARM::STRBi12:
                                    //jinwen comment for debug other functions
                                    // break;
                                    if(critical_flag == 0){
                                        CPT_Bkword_Transfer(BBI, DelInstVect, MBB, TII);
                                    }

                                    break;
                                }
                                    //jinwen comment for debug other functions
                                    break;
                                    Bkwd_SFI_Instrumentation(MI, MBB, BBI, TII);

                                break;
                            }
                            //debug str
                            //STRi12    = 471,
                            //STRBi12   = 447
                            //TODO complete all the STR instructions
                            // identify store instructions, including vstr, strb, strd, and strh
                            // case ARM::STRBi12:
                            case ARM::VSTRS:
                            case ARM::VSTRD:
                            case ARM::STRBi12:
                            case ARM::STRD:
                            case ARM::STRH:
                            case ARM::STRi12:
                            {

                                // std::string debug_funciton = "_ZL18simulation_timevalP7timeval";
                                // int opcode = MI->getOpcode();
                                // if(curr_func_name == debug_funciton){
                                //     errs() <<  TII.getName(opcode) << "\n";
                                // }

                                // errs() << MF.getName() << "\n";

                                // if(MF.getName() != "_ZN6Copter9fast_loopEv"){
                                //     break;
                                // }

                                //debug here
                                // if(istmt_curr_id  < istmt_start_id || istmt_curr_id > istmt_end_id){
                                //     // errs() << istmt_curr_id << " " << MF.getName() << "\n";
                                //     break;
                                // }

                
                                //TODO implement instrumentation of all conditional str instructions
                                // if(MI->getOperand(3).getImm()!=14){
                                //     break;
                                // }


                                // int flag_cfe = 0;
                                // for(int i = 0; i < 15; i++){


                                //     MachineInstr* MI = NULL;

                                //     for(int j = 0; j < i; j++){
                                //         BBI + 1
                                //     }


                                //     // if(BBI+i == MBB->end()){
                                //     //     break;
                                //     // }

                                //     MachineInstr* MI = &*(BBI+i);


                                //     // MachineInstr* MI = &*BBI;

                                //     if(MI->getOpcode() == ARM::BL || MI->getOpcode() == ARM::BL_pred){
                                //         if(MI->getOperand(0).isGlobal() &&  MI->getOperand(0).getGlobal()->getLinkage()==0 
                                //             && MI->getOperand(0).getGlobal()->getGlobalIdentifier() == "__cfv_icall");
                                //         flag_cfe = 1;
                                //         break;
                                //     }
                                // }
                                // if(flag_cfe){
                                //     break;
                                // }


                                // break;
                                //debug here
                                // curr_ist += 1;
                                // errs() << curr_ist << "\n";
                                // if(curr_ist > 3){
                                //     break;
                                // }

                                // if(MI->getOperand(2).getImm() < 0){
                                //     break;
                                // }


                                //jinwen comment for debugging
                                // DelInstVect.push_back(MI);
                                // Store_SFI_Instrumentation(BBI, DelInstVect, MBB, TII);


                                if(wrt_flag == 1){
                                    wrt_flag = 0;
                                    // DelInstVect.push_back(MI);
                                    //jinwen comment for debug
                                    // break;
                                    if(critical_flag == 0){
                                        Wrt_SFI_Instrumentation(BBI, DelInstVect, MBB, TII, curr_cpt_base_addr, curr_cpt_mask, MF);
                                    }
                                    break;
                                }

                                break;
                            }
                        }
                    }
                }

                // errs() << "before deletion\n";

                //delete instructions to be deleted
                for (auto DI: DelInstVect){
                    MBB->remove_instr(DI);
                }

                // errs() << "after deletion\n";

            }
            // std::cout << "-----------finish-----------" << std::endl;
            // errs() << "before return\n";
            return false;
        }
    };
}
 
namespace llvm {
FunctionPass *SFIPass(){
    return new SandboxPass();
}
}
 
char SandboxPass::ID = 0;
static RegisterPass<SandboxPass> X("sfi", "Software Fault Isolation");