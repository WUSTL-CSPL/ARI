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
#include <iostream>
#include "llvm/IR/DebugLoc.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
// #include "Target/ARM/ARMBaseInstrInfo.h"
#include "llvm/Target/TargetInstrInfo.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include <fstream>
#include <map>
#include <sstream>
#include <string>
#include "llvm/IR/DebugInfo.h"

 
#define DEBUG_TYPE "machinecount"
 
using namespace llvm;

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

        // errs() << "Trampoline_Transfer_Instru\n" << "\n";

        // total_instrumentation_cnt += 1;
        // printf("%d\n", total_instrumentation_cnt);

        DebugLoc dl = DebugLoc();
        

        // push lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes 


        // push r2
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R2, RegState::Define)
            .addReg(ARM::R2)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes 


        // push r1
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R1, RegState::Define)
            .addReg(ARM::R1)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes 

        // push r0
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::R0, RegState::Define)
            .addReg(ARM::R0)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes 

        // reference
        // //push lr
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //     // .addReg(ARM::R8, RegState::Define)
        //     .addReg(ARM::LR, RegState::Define)
        //     .addReg(ARM::LR)          //useless              
        //     .addReg(ARM::SP)
        //     .addImm(-4)               //pre offset
        //     .addImm(14);              //conditional codes   


        //jinwenTODO: separate blx and blx_pre, bx/bx_pre, bx_ret and bx_ret_pre
        //current CFE_Type
        //0 blx/blx_pre
        //1 bx/bx_pre
        //2 bx_ret
        //3 pop pc
        //4 bc
        

        //blx/blx_pre, bx/bx_pre, bx_ret
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
                .addReg(ARM::R0, RegState::Define)
                .addReg(ARM::SP)
                .addImm(16 + 4 * (des_reg - 1))
                .addImm(14);      

            BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
                .addReg(ARM::SP)
                .addReg(ARM::SP)
                .addImm(16 + 4 * (des_reg - 1))
                .addImm(14)
                .addReg(0)
                .addReg(0);       
        }
        //conditional branch
        else if(CFE_type == 4){
             BuildMI(*MBB, BBI, dl, TII.get(ARM::MRS), ARM::R0)
                .addImm(14);
                // .addReg(ARM::APSR)
                // .addImm(14);            
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

        
        // reference
        // //pop lr
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //     // .addReg(ARM::R8, RegState::Define)
        //     .addReg(ARM::LR, RegState::Define)
        //     .addReg(ARM::LR, RegState::Define)//useless              
        //     .addReg(ARM::SP, RegState::Define)
        //     .addImm(0) //useless
        //     .addImm(4) //post offset
        //     .addImm(14);//conditional codes
        
        //pop r0
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::R0, RegState::Define)
            .addReg(ARM::R0, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes
        
        //pop r1
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::R1, RegState::Define)
            .addReg(ARM::R1, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        //pop r2
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::R2, RegState::Define)
            .addReg(ARM::R2, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        //pop lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        return 0;
    }


//==============================================================================================
//BLX         30 xxx r0: destination, r1: condition, r2: cpsr
//BLX_pred    31 xxx r0: destination, r1: condition, r2: cpsr
//BX          32 xxx r0: destination, r1: condition, r2: cpsr
//BX_pred     33 xxx r0: destination, r1: condition, r2: cpsr
//BX_RET      34 xxx r0: destination, r1: condition, r2: cpsr
//BX_RET_pred 35 xxx r0: destination, r1: condition, r2: cpsr
//LDMIA_RET   36 xxx r0: destination, r1: condition, r2: cpsr

    //BLX recording
    int Trampoline_Transfer_Instru_BLX(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){


        DebugLoc dl = DebugLoc();
        
        MachineInstr* MI = &*BBI;


        BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
            .addReg(ARM::R8)
            .addReg(MI->getOperand(0).getReg())
            .addImm(14)
            .addReg(0)
            .addReg(0);


        // // push lr
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //     .addReg(ARM::LR, RegState::Define)
        //     .addReg(ARM::LR)          //useless              
        //     .addReg(ARM::SP)
        //     .addImm(-4)               //pre offset
        //     .addImm(14);              //conditional codes 


        // //mov des_add to r8
        //     BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
        //         .addReg(ARM::R8)
        //         .addReg(des_reg)
        //         .addImm(14)
        //         .addReg(0)
        //         .addReg(0);            



        const char* symicall = "__cfv_icall_blx";
        // const char* symRet = "__cfv_ret";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(symicall);
        

        //pop lr
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //     .addReg(ARM::LR, RegState::Define)
        //     .addReg(ARM::LR, RegState::Define)//useless              
        //     .addReg(ARM::SP, RegState::Define)
        //     .addImm(0) //useless
        //     .addImm(4) //post offset
        //     .addImm(14);//conditional codes

        return 0;
    }



    //BLX recording
    int Trampoline_Transfer_Instru_BLX_PRE(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){


        DebugLoc dl = DebugLoc();
        // BBI++;
        MachineInstr* MI = &*BBI;

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

        //jump to record
        const char* tpl_cfv_icall_recording = "__cfv_icall_blx_pre";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_cfv_icall_recording);

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

        //restor lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        return 0;
    }


void Trampoline_Transfer_Instru_Cond_B(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){


        DebugLoc dl = DebugLoc();
        // BBI++;
        MachineInstr* MI = &*BBI;

        // str lr, [sp]
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR)
            .addReg(ARM::LR)
            .addReg(ARM::SP)
            .addImm(-4)
            .addImm(14);

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

        //jump to record
        const char* tpl_tsf_conditional_branch_recording = "__cfv_icall_cond_dirbranch";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_conditional_branch_recording);

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

        // ldr lr, [sp]
        // sp = sp +4
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

}

void Trampoline_Transfer_Instru_Cond_BL(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){


        DebugLoc dl = DebugLoc();
        // BBI++;
        MachineInstr* MI = &*BBI;

        //str lr, [sp]
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR)
            .addReg(ARM::LR)
            .addReg(ARM::SP)
            .addImm(-4)
            .addImm(14);

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

        //jump to record
        const char* tpl_tsf_conditional_branch_recording = "__cfv_icall_cond_dirbranch";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(tpl_tsf_conditional_branch_recording);

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


void Trampoline_Transfer_Instru_LDMIA_RET_Org(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){

        DebugLoc dl = DebugLoc();
        // BBI++;
        MachineInstr* MI = &*BBI;

        // push lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR)          //useless              
            .addReg(ARM::SP)
            .addImm(-4)               //pre offset
            .addImm(14);              //conditional codes 


        // // push r2
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //     .addReg(ARM::R2, RegState::Define)
        //     .addReg(ARM::R2)          //useless              
        //     .addReg(ARM::SP)
        //     .addImm(-4)               //pre offset
        //     .addImm(14);              //conditional codes 


        // // push r1
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //     .addReg(ARM::R1, RegState::Define)
        //     .addReg(ARM::R1)          //useless              
        //     .addReg(ARM::SP)
        //     .addImm(-4)               //pre offset
        //     .addImm(14);              //conditional codes 

        // push r0
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //     .addReg(ARM::R0, RegState::Define)
        //     .addReg(ARM::R0)          //useless              
        //     .addReg(ARM::SP)
        //     .addImm(-4)               //pre offset
        //     .addImm(14);              //conditional codes 


        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_PRE_IMM))
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::SP)
            .addImm(4 + 4 * (des_reg - 1))
            .addImm(14);      

        BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
            .addReg(ARM::SP)
            .addReg(ARM::SP)
            .addImm(4 + 4 * (des_reg - 1))
            .addImm(14)
            .addReg(0)
            .addReg(0); 

        // //mov pc to r1
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr), ARM::R1)
        //     .addReg(ARM::PC)
        //     .addImm(14)
        //     .addReg(0)
        //     .addReg(0);  

        // //mov CFE type to r2
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R2)
        //     .addImm(CFE_type)
        //     .addImm(14)
        //     .addReg(0)
        //     .addReg(0);


        const char* symicall = "__cfv_icall_ldmia_ret";
        BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(symicall);

        //pop r0
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //     .addReg(ARM::R0, RegState::Define)
        //     .addReg(ARM::R0, RegState::Define)//useless              
        //     .addReg(ARM::SP, RegState::Define)
        //     .addImm(0) //useless
        //     .addImm(4) //post offset
        //     .addImm(14);//conditional codes
        
        // //pop r1
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //     .addReg(ARM::R1, RegState::Define)
        //     .addReg(ARM::R1, RegState::Define)//useless              
        //     .addReg(ARM::SP, RegState::Define)
        //     .addImm(0) //useless
        //     .addImm(4) //post offset
        //     .addImm(14);//conditional codes

        // //pop r2
        // BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //     .addReg(ARM::R2, RegState::Define)
        //     .addReg(ARM::R2, RegState::Define)//useless              
        //     .addReg(ARM::SP, RegState::Define)
        //     .addImm(0) //useless
        //     .addImm(4) //post offset
        //     .addImm(14);//conditional codes

        //pop lr
        BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
            .addReg(ARM::LR, RegState::Define)
            .addReg(ARM::LR, RegState::Define)//useless              
            .addReg(ARM::SP, RegState::Define)
            .addImm(0) //useless
            .addImm(4) //post offset
            .addImm(14);//conditional codes

        return;


}


 // void CPT_Bkword_Transfer(MachineBasicBlock::iterator &BBI, MachineBasicBlock *MBB, const TargetInstrInfo &TII){
    void Trampoline_Transfer_Instru_LDMIA_RET(int CFE_type, unsigned des_reg, unsigned cond_code,\
                MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){

        // return;
        //find return first
        DebugLoc dl = DebugLoc();
        MachineInstr* MI = &*BBI;

        //BX LR Transfer
        // errs() << MBB->getParent()->getName() << "\n";

        // if(MI->getOpcode() == ARM::BX_RET){
        //     // errs() << "bx_ret transfer\n";
        //     //insert instruciton to move lr into reserved register
        //     BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVr))
        //         .addReg(ARM::R8)
        //         .addReg(ARM::LR)
        //         .addImm(14)
        //         .addReg(0)
        //         .addReg(0); 
            
        //     //insert instruction to jump to bx lr checking trampoline
            
        //     //saving lr
        //     BuildMI(*MBB, BBI, dl, TII.get(ARM::STR_PRE_IMM))
        //         .addReg(ARM::LR, RegState::Define )
        //         .addReg(ARM::LR )          //useless              
        //         .addReg(ARM::SP )
        //         .addImm(-4)               //pre offset
        //         // .addImm(14) //post offset
        //         .addImm(14);              //conditional codes


        //     // BuildMI(*MBB, BBI, dl, TII.get(ARM::SUBri))               
        //     //     .addReg(ARM::SP)
        //     //     .addReg(ARM::SP)
        //     //     .addImm(4)
        //     //     .addImm(14)
        //     //     .addReg(0)
        //     //     .addReg(0);

        //     //B has problem
        //     // const char* trampoline_bx_lr = "__tsf_bkwd_bx_lr_checking";
        //     const char* trampoline_bx_lr = "__tsf_bkwd_bx_lr_recording";
        //     BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_bx_lr);
        //     DelInstVect.push_back(MI);  


        //     //restoring lr
        //     BuildMI(*MBB, BBI, dl, TII.get(ARM::LDR_POST_IMM))
        //         .addReg(ARM::LR, RegState::Define)
        //         .addReg(ARM::LR, RegState::Define)//useless              
        //         .addReg(ARM::SP, RegState::Define)
        //         .addImm(0) //useless
        //         .addImm(4) //post offset
        //         .addImm(14);//conditional codes

        // }

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



// void CPT_Direct_Transfer(MachineBasicBlock::iterator &BBI,SmallVector<MachineInstr *, 500> &DelInstVect, MachineBasicBlock *MBB, const TargetInstrInfo &TII){

void Trampoline_Transfer_Instru_Cond(int CFE_type, unsigned des_reg, unsigned cond_code,\
        MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){

        // errs() << "!!!!!!!!!!Processing CPT_Transfer Instruction!!!!!!!!!!\n";
        DebugLoc dl = DebugLoc();

        MachineInstr* MI = &*BBI;

        // if(!MI->getOperand(0).isGlobal()){
        //     errs() << "Not Global\n";
        //     errs() << MI->getOperand(0).getType() << "\n";
        // }

        if(MI->getOperand(0).isGlobal()){
            errs() << "global\n";
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

        //jinwen write the folling for debug
        }
        else if(MI->getOperand(0).isMBB()){
            // errs()<<"MBB\n";

            // MachineBasicBlock *targetMBB = MI->getOperand(0).getMBB();


                BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi), ARM::R8)
                    .addImm(100)
                    .addImm(14)
                    .addReg(0)
                    .addReg(0);


            // // Load the lower 16 bits of the address
            // // movw r8, #:lower16:<label>
            // BuildMI(*MBB, MI, dl, TII.get(ARM::MOVi16), ARM::R8)
            //   .addMBB(targetMBB)
            //   .addImm(ARMII::MO_OPTION_MASK)
            //   .addReg(0);

            // // Then, load the higher 16 bits of the address
            // // movt r8, #:upper16:<label>
            // BuildMI(*MBB, MI, dl, TII.get(ARM::MOVTi16), ARM::R8)
            //   .addMBB(targetMBB)
            //   .addReg(ARM::R8)
            //   .addImm(ARMII::MO_OPTION_MASK)
            //   .addReg(0);



            // movw r8, #:lower16:<label>
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVi16))
            //   .addReg(ARM::R8)
            //   .addMBB(targetMBB)
            //   // .addImm(14)
            //   .addImm(ARMII::MO_OPTION_MASK)
            //   .addReg(0);

            // // Then, load the higher 16 bits of the address
            // // movt r8, #:upper16:<label>
            // BuildMI(*MBB, BBI, dl, TII.get(ARM::MOVTi16), ARM::R8)
            //   // .addMBB(targetMBB)
            //   // .addReg(ARM::R8)
            //   // .addImm(ARMII::MO_OPTION_MASK)
            //   // .addReg(0);
            //   .addReg(ARM::R8)
            //   .addMBB(targetMBB)
            //   .addImm(14)
            //   .addReg(0);

        }

        //jinwen end debug

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


                //jump to record
                // errs() << "pos4\n";
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
        
        //jinwen comment this for debug
        // }

        //jinwen write this for debug
        return;

        // else if(MI->getOperand(0).isMBB()){
        if(MI->getOperand(0).isMBB()){

            // errs() << "opcode:" << MI->getOpcode() << "\n";
            // const BasicBlock * basicblock = MI->getOperand(0).getBasicBlock();
            // errs() << "start insert\n";
            // errs() << "MOVi16\n";
            errs() << "MBB\n";

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

                        errs() << "b/bl\n";

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
                                errs() << "pos5\n";
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

                                errs() << "pos6\n";
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

                                errs() << "pos7\n";
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


                                errs() << "pos8\n";
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



//test sandbox
int test_sanxbox_blx(MachineBasicBlock *MBB, MachineBasicBlock::iterator &BBI, const TargetInstrInfo &TII){

  // const MachineInstrBuilder &addRegMask(const uint32_t *Mask) const {

        errs() << "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n";

        MachineInstr* MI = &*BBI;
        DebugLoc dl = DebugLoc();

        // uint32_t mask = 0b00110001000;
        uint32_t mask = 0b111111111111;


        //bfi r8, rx, #0, #12
        BuildMI(*MBB, BBI, dl, TII.get(ARM::BFI))
            .addReg(ARM::R8, RegState::Define)
            .addReg(ARM::R8, RegState::Define) //useless            
            .addReg(MI->getOperand(0).getReg(),RegState::Define)
            .addImm(~mask)
            .addImm(14);
            // .addImm(10)
            // .addImm(-10); 
            // .addImm(0);
            // .addReg(0);

 }


    //CFE_type 
    //0:Indirect Call;
    //1:Indirect Jump;
    //2:BX_RET;
    //3:LDMIA_RET;
    //4:Conditional Branch;



    bool is_instrument_function(MachineFunction &MF){
        //return false;
        //errs()<<MF.getName()<<" yesyujie  \n";
        std::ifstream infile("./critical_list.txt"); //copter/rover attitude control
        // std::ifstream infile("/home/osboxes/Desktop/conattest/ardupilot/critical_list_ard_fn.txt"); //copter/rover fail-safe
        // std::ifstream infile("/home/osboxes/Desktop/conattest/ardupilot/critical_syringe_operation.txt"); //syringe operation
        // std::ifstream infile("/home/osboxes/Desktop/conattest/ardupilot/critical_syringe_serial.txt"); //syringe serial

        std::string line;
        while (std::getline(infile, line))
        {
            if(std::string(MF.getName())==line){
                errs()<<"ynnnnnnesssss  \n";
                return true;
            }
        }
       
        return false;
        

    }



    int cnt_return = 0;
    int cnt_indjmp = 0;
    int cnt_cond_branch = 0;
    int init_flag = 0;

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



    class MachineCountPass : public MachineFunctionPass {
    
    public:
        static char ID;
 
        int one_time_flag = 0;

        int debug_cnt = 0;

        //find return instruction and record source and destination address
        MachineCountPass() : MachineFunctionPass(ID) {}
        virtual bool runOnMachineFunction(MachineFunction &MF) {
            
            // disable this pass
            return false;

            if(!init_flag){
                init_flag = 1;
                CFEvent_Instru_Init();
            }

            // Assuming you have a MachineFunction* MF:
            const llvm::Function* F = MF.getFunction();

            // if(F->getName().str().find("veneer") != std::string::npos){
            //     errs() << "!!!!!!!!!!!" << F->getName() << "\n";
            // }

            if (F) {
                if (auto *DISub = F->getSubprogram()) {
                    llvm::StringRef curr_filename = DISub->getFile()->getFilename();
                    // Do something with filename

                    auto it = crit_cpt_map.find(curr_filename);

                    if(it!=crit_cpt_map.end()){
                        // errs() << curr_filename << "\n";
    
                        //jinwen add this filter for debug
                        // if(MF.getName() != "_ZN18AC_AttitudeControl43input_euler_angle_roll_pitch_euler_rate_yawEfff"){
                        //     return false;
                        // }

                        // if(MF.getName() == "_ZN18AC_AttitudeControl43input_euler_angle_roll_pitch_euler_rate_yawEfff"){
                        //     return false;
                        // }

                        // if(MF.getName() != "_ZNK18AC_AttitudeControl13ang_vel_limitER7Vector3IfEfff"){
                        //     return false;
                        // }

                        errs() << F->getName() << "\n";

                        //jinwen write this for debug
                        debug_cnt += 1;
                        // if(debug_cnt < 2){
                        //     return false;
                        // }
    
                    }
                    else{
                        return false;
                    }

                   // if(curr_filename.equals(crit_cpt_filename)){
                   //      errs() << crit_cpt_filename << "\n";
                   // }
                    // errs() << curr_filename << "\n";
                }
            }

            // return false;

            //  if(!is_instrument_function(MF)){
                
            //     // if(MF.getName() != "_ZN6Copter9fast_loopEv"){
            //     // if(MF.getName() != "_ZN11GCS_MAVLINK9send_textE12MAV_SEVERITYPKcz"){
            //     // if(MF.getName() != "_ZN11GCS_MAVLINK12send_messageE10ap_message"){
            //     // if(MF.getName() != "_ZL32mavlink_msg_mission_ack_send_bufP17__mavlink_message17mavlink_channel_thhhh"){
            //     // if(MF.getName() != "deregister_tm_clones"){
            //     return false;
            // }

            // if(MF.getName() != "_ZN7HALSITL10SITL_State10wait_clockEy"){
                
            // // if(MF.getName() != "_ZN6Copter9fast_loopEv"){
            // // if(MF.getName() != "_ZN11GCS_MAVLINK9send_textE12MAV_SEVERITYPKcz"){
            // // if(MF.getName() != "_ZN11GCS_MAVLINK12send_messageE10ap_message"){
            // // if(MF.getName() != "_ZL32mavlink_msg_mission_ack_send_bufP17__mavlink_message17mavlink_channel_thhhh"){
            // // if(MF.getName() != "deregister_tm_clones"){
            //     return false;
            // }
            
            //disable this pass
            // return false;

            //not instrument trampoline
            if(MF.getName() == "view_switch_to_rd_and_log"){
                return false;
            }

            if(MF.getName() == "__test"){
                return false;
            }

            if(MF.getName() == "__conditional_branch_recording"){
                return false;
            }

            if(MF.getName() == "recored_exet"){
                return false;
            }

            if(MF.getName() == "read_measurement" || MF.getName() == "pop" || MF.getName() == "push" \
                || MF.getName() == "run_thread" || MF.getName() == "write_number_to_file" || MF.getName() == "write_array_to_file" \
                || MF.getName() == "write_two_numbers_to_file" || MF.getName() == "print_hash" || MF.getName() == "create_files" \
                || MF.getName() == "start_new_thread" || MF.getName() == "view_switch_to_text_and_log"){
                return false;
            }

            // return false;

            std::cout << "---------start----------" << std::endl;
            // std::cout << ARM::BLX <<std::endl;
            // std::cout << ARM::BLX_pred <<std::endl;
            // std::cout << ARM::BX <<std::endl;
            // std::cout << ARM::BX_pred <<std::endl;
            // std::cout << ARM::BX_RET <<std::endl;
            DebugLoc dl = DebugLoc();
            for (MachineFunction::iterator I = MF.begin(), E = MF.end(); I != E; ++I) {
                MachineBasicBlock *MBB = &*I;

                for (MachineBasicBlock::iterator BBI = MBB->begin(), BBE = MBB->end();
                     BBI != BBE; ++BBI) {

                    MachineInstr* MI = &*BBI;

                    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
                    
                    const ARMSubtarget &STI = MF.getSubtarget<ARMSubtarget>();

                    const ARMBaseInstrInfo &ARMBII = *static_cast<const ARMBaseInstrInfo *>(MF.getSubtarget().getInstrInfo());

                    // if(!MF.getMMI().getModule()->getNamedValue("view_switch_to_rd_and_log")){
                    //         std::cout << "--------NULL-------\n" << std::endl;      
                    // }

                    int CFE_type = 0;
                    unsigned CFE_source_add = 0;
                    unsigned CFE_destination_add_reg = 0;


                    //jinwen write this for debug
                    // unsigned opcode = MI->getOpcode();
                    // llvm::dbgs() << "The opcode name is: " << TII.getName(opcode) << "\n";


                    // std::cout << MI->getOpcode() << std::endl;

                    //conditional branch test comment starts
                    // if(MI->getDesc().isCall() || 
                    //     MI->getDesc().isIndirectBranch() ||
                    //     MI->getDesc().isReturn() ||
                    //     MI->getDesc().isCompare()){
                    if(true){

                        //jinwen write this for debug
                        // break;

                        switch(MI->getOpcode()){

                            //indirect call
                            case ARM::BLX:{

                                errs() << "ARM::BLX\n";

                                // break;

                                cnt_indjmp += 1;
                                // printf("BLX or BLX_pred\n");
                                if(!MI->getOperand(0).isReg()){
                                    break;
                                }
                                CFE_destination_add_reg = MI->getOperand(0).getReg();
                                Trampoline_Transfer_Instru_BLX(0, CFE_destination_add_reg, -1, MBB, BBI, TII);

                                break;  

                            }
                            //jinweTODO: this code seems not to be triggered
                            case ARM::BLX_pred:{
                                //jinwen write this for debug
                                // break;
                                errs() << "ARM::BLX_pred\n";
                                
                                // break;

                                cnt_indjmp += 1;
                                // printf("BLX or BLX_pred\n");
                                if(!MI->getOperand(0).isReg()){
                                    break;
                                }
                                CFE_destination_add_reg = MI->getOperand(0).getReg();
                                Trampoline_Transfer_Instru_BLX_PRE(0, CFE_destination_add_reg, -1, MBB, BBI, TII);

                                break;                               
                            } 
                            //indirect jump/branch
                            case ARM::BX:{
                                //jinwen write this for debug
                                errs() << "ARM::BX\n";
                                break;                                

                            }
                            case ARM::BX_pred:{
                                //jinwen write this for debug
                                printf("BX or BX_pred\n");

                                // break;

                                cnt_indjmp += 1;
                                if(!MI->getOperand(0).isReg()){
                                    break;
                                }
                                CFE_destination_add_reg = MI->getOperand(0).getReg();
                                Trampoline_Transfer_Instru(1, CFE_destination_add_reg, -1, MBB, BBI, TII);
                                
                                errs() << "ARM::BX_pred\n";

                                break;  
                            }
                            //return bx lr
                            case ARM::BX_RET:{
                                //jinwen write this for debug
                                errs() << "ARM::BX_RET\n";
                                break;

                                cnt_return += 1;
                                // printf("BX_RET\n");
                                Trampoline_Transfer_Instru(2, ARM::LR, -1, MBB, BBI, TII);
                                break;  
                            }
                            //return pop pc
                            case ARM::LDMIA_RET:{
                                //jinwen write this for debug
                                errs() << "ARM::LDMIA_RET\n";
                                // break;

                                cnt_return += 1;
                                // printf("LDMIA_RET\n");
                                int non_regs = 0;
                                // int operand_cnt = MI->getNumOperands();

                                // if(MI->getOperand(MI->getNumOperands()-1).getReg() != 11){
                                //     for(int i = 0; i < operand_cnt; i++){
                                //         if(!MI->getOperand(i).isReg()){
                                //             non_regs+=1;
                                //         }
                                //         else{
                                //             printf("%d ", MI->getOperand(i).getReg());
                                //         }
                                //     }
                                //     printf("\n");
                                //     printf("non_regs:%d tt_cnt %d\n", non_regs, operand_cnt);                                    
                                // }

                                int non_pop_regs_cnt = 0;
                                if(MI->getOperand(MI->getNumOperands()-1).getReg() != 11){
                                    non_pop_regs_cnt = 5;
                                }
                                else{
                                    non_pop_regs_cnt = 4;
                                }
                                unsigned cnt_to_be_pop = MI->getNumOperands() - non_pop_regs_cnt;

                                Trampoline_Transfer_Instru_LDMIA_RET(3, cnt_to_be_pop, -1, MBB, BBI, TII);

                                break;

                            }
                            case ARM::BL_pred: {
                                unsigned PredReg = 0;
                                ARMCC::CondCodes PredCode = getInstrPredicate(*MI, PredReg);
                                if(PredCode == 14){
                                    break;
                                }
                                errs() << "ARM::BL_pred Branch\n";
                                Trampoline_Transfer_Instru_Cond(4, PredReg, PredCode, MBB, BBI, TII);
                                break;
                            }
                            case ARM::Bcc:{
                                errs() << "ARM::Bcc Branch\n";
                                unsigned PredReg = 0;
                                ARMCC::CondCodes PredCode = getInstrPredicate(*MI, PredReg);
                                Trampoline_Transfer_Instru_Cond(4, PredReg, PredCode, MBB, BBI, TII);
                                break;
                            }
                        }
                    }
                    //conditional branch test comment ends

                    //conditional branch
                    //comment start
                    // if(MI->getDesc().isConditionalBranch()){

                    //     if(MI->getOpcode() == ARM::Bcc){
                    //         //jinwen write this for debug
                    //         errs() << "ARM::Bcc\n";

                    //         // break;

                    //         cnt_cond_branch += 1;
                    //         // printf("ConditionalBranch\n");
                    //         unsigned PredReg = 0;
                    //         ARMCC::CondCodes PredCode = getInstrPredicate(*MI, PredReg);

                    //         // const char* trampoline_bx_lr = "__cfv_icall";
                    //         // BuildMI(*MBB,BBI,dl,TII.get(ARM::BL)).addExternalSymbol(trampoline_bx_lr);

                    //         Trampoline_Transfer_Instru_Cond_B(4, PredReg, PredCode, MBB, BBI, TII);

                    //         // one_time_flag = 1;
                    //     }


                    //     if(MI->getOpcode() == ARM::BL_pred){
                    //         errs() << "ARM::BL_pred\n";
                    //         unsigned PredReg = 0;
                    //         ARMCC::CondCodes PredCode = getInstrPredicate(*MI, PredReg);
                    //         Trampoline_Transfer_Instru_Cond_BL(4, PredReg, PredCode, MBB, BBI, TII);
                    //     }

                    // }   
                    //comment end


                }
                
            }
            std::cout << "-----------finish-----------" << std::endl;

        
            // errs() << "indirect jump:" << cnt_indjmp;
            // errs() << "return: " << cnt_return;
            // errs() << "conditional jump:" << cnt_cond_branch;

            // outs() << ">>>" << MF.getName() << " has " << num_instr << " instructions.\n";
            // std::cout << "---------------\n" << std::endl;
            return false;
        
        }

    };
}
 
namespace llvm {
FunctionPass *CFEventsMachinePass(){
    return new MachineCountPass();
}
}
 
char MachineCountPass::ID = 0;
static RegisterPass<MachineCountPass> X("machinecount", "Machine Count Pass");