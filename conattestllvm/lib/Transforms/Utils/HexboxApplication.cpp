//===- HexboxApplication.cpp - Example code from "Writing an LLVM Pass" ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements application of the HexBox policy
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include <fstream>
#include <iostream>
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"
#include "json/json.h" //From https://github.com/open-source-parsers/jsoncpp
#include <map>
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "hexbox"

//STATISTIC(Stat_NumFunctions, "Num Functions");

static cl::opt<std::string> HexboxPolicy("hexbox-policy",
                                  cl::desc("JSON Defining the policy"),
                                  cl::init("-"),cl::value_desc("filename"));



Json::Value CFGRoot;

//the map that records the sections a variable should locate in
std::map<std::string, std::string> var2sec;

#define SHARED_DATA_REGION ".DATA_REGION_0__d"


//#define NUM_MPU_REGIONS 8
#define ACCESS_ARRAY_SIZE 200

namespace {
  // Hello - The first implementation, without getAnalysisUsage.
  struct HexboxApplication : public ModulePass {
    static char ID; // Pass identification, replacement for typeid
    HexboxApplication () : ModulePass(ID) {}

    StringMap<GlobalVariable *> CompName2GVMap;
    DenseMap<Function *, Function *> Function2Wrapper;
    GlobalVariable * DefaultCompartment;

    bool doInitialization(Module &M) override{
        return true;
    }

  
    Constant * get_MPU_region_data(Module & M, StructType * RegionTy, unsigned int Addr, unsigned int Attr){
        SmallVector<Constant *,8> RegionsVec;
        APInt addr = APInt(32,Addr);
        APInt attr = APInt(32,Attr);
        RegionsVec.push_back(Constant::getIntegerValue(Type::getInt32Ty(M.getContext()), addr));
        RegionsVec.push_back(Constant::getIntegerValue(Type::getInt32Ty(M.getContext()), attr));
        Constant * Region = ConstantStruct::get(RegionTy,RegionsVec);
        return Region;
    }


    void buildGlobalVariablesForCompartments(Module &M, Json::Value & root){

        Json::Value comps =  root.get("MPU_CONFIG","");
        Json::Value num_mpu_regions =  root.get("NUM_MPU_REGIONS",8);
        unsigned comp_count =0;

        SmallVector<Type *,8> TypeVec;
        TypeVec.push_back(Type::getInt32Ty(M.getContext()));
        TypeVec.push_back(Type::getInt32Ty(M.getContext()));
        StructType * RegionTy = StructType::create(TypeVec,"__hexbox_md_regions");
        ArrayType * MPURegionTy = ArrayType::get(RegionTy,num_mpu_regions.asUInt());


        SmallVector<Type *,9> CompTyVec;

        CompTyVec.push_back(Type::getInt16Ty(M.getContext()));
        CompTyVec.push_back(Type::getInt8Ty(M.getContext()));
        CompTyVec.push_back(Type::getInt8Ty(M.getContext()));
        //CompTyVec.push_back(StatsArrayPtrTy);
        CompTyVec.push_back(MPURegionTy);
        StructType * CompTy = StructType::create(CompTyVec,"__hexbox_comparment");

        DEBUG(errs() << "Building Compartment Global Variables---------------------\n");


        for(auto CompName: comps.getMemberNames()){
            DEBUG(std::cout << "Compartment: "<< CompName);
            Json::Value Attrs = comps[CompName]["Attrs"];
            Json::Value Addrs = comps[CompName]["Addrs"];
            Json::Value Priv = root["Compartments"][CompName]["Priv"];
            DEBUG(std::cout << Attrs <<"\n");
            DEBUG(std::cout << Addrs <<"\n");

            /* Build MPU Regions */
            SmallVector<Constant *,16> MPURegionsVec;
            for(unsigned int i = 0; i<num_mpu_regions.asUInt();i++){
                Constant * Region;
                if (i < Attrs.size()){
                    Region = get_MPU_region_data(M, RegionTy, Addrs[i].asUInt(), Attrs[i].asUInt());
                }else{
                    Region = get_MPU_region_data(M, RegionTy, 0, 0);
                }
               MPURegionsVec.push_back(Region);
              }

            Constant * MPRegions = ConstantArray::get(MPURegionTy,MPURegionsVec);

            //Build Compartent
            SmallVector<Constant *,2> CompVec;
            APInt count = APInt(16,0);
            CompVec.push_back(Constant::getIntegerValue(Type::getInt16Ty(M.getContext()),count));

            APInt comp_id = APInt(8,comp_count);
            CompVec.push_back(Constant::getIntegerValue(Type::getInt8Ty(M.getContext()),comp_id));

            APInt priv = APInt(8,Priv.asInt());
            CompVec.push_back(Constant::getIntegerValue(Type::getInt8Ty(M.getContext()),priv));

            ++comp_count;
            CompVec.push_back(MPRegions);

            Constant * CompInit = ConstantStruct::get(CompTy,CompVec);
            GlobalVariable * Compartment = new GlobalVariable(M,CompTy,true, GlobalVariable::ExternalLinkage,CompInit,"_hexbox_comp_" + CompName);
            Compartment->setSection(".rodata");

            DEBUG(errs() << "Adding: "<<CompName<< "CompName: "<<Compartment->getName() << "\n");

            CompName2GVMap.insert(std::make_pair(CompName,Compartment));

        }

    }


    GlobalVariable * getCompartmentForFunction(Function *F){

        auto itr = CompName2GVMap.find(F->getSection());
        if (itr != CompName2GVMap.end()){
            return itr->second;
        }else{
            itr = CompName2GVMap.find("__hexbox_default");
            if (itr != CompName2GVMap.end()){
                DEBUG(errs() << "Looking up: "<< F->getName() << "\n");
                DEBUG(errs() << "Section: " <<F->getSection() << "\n");
                DEBUG(errs() << "Returning Default Comp\n");
                return itr->second;

            }else{
                assert(false && "No Default Hexbox Compartment found");
                return nullptr;
            }
        }

    }



    /*************************************************************************
    * interceptMain
    * This initializes hexbox.  It does it by renaming main to
    * __original_main and then creates a new main.  Taking the name main is
    * required because assembly is used to initialize the device and then calls
    * main. LLVM can analyze the assembly, so we hijack the symbol name.
    *
    * The main built initializes each compartment bss and data section, then
    *  
    */
    void interceptMain(Module & M,Json::Value PolicyRoot){

        Function * OrgMain = M.getFunction("main");
        Function * InitMain;
        IRBuilder<> *IRB;
        assert(OrgMain && "Main not found");
        OrgMain->setName("__original_main");
        DEBUG(OrgMain->getFunctionType()->dump());

        InitMain = Function::Create(OrgMain->getFunctionType(),OrgMain->getLinkage(),"main",&M);
        InitMain->addFnAttr(Attribute::NoUnwind);
        BasicBlock * BB = BasicBlock::Create(M.getContext(),"entry",InitMain);
        IRB = new IRBuilder<>(M.getContext());
        IRB->SetInsertPoint(BB);

        initBssAndDataSections(M,IRB,PolicyRoot);

        Function *HexboxStartFn = M.getFunction("__hexbox_start");

        assert(HexboxStartFn && "Function hexbox_start not found");
        SmallVector<Value *,1> Args;
        Constant * DefaultPolicy;
        DefaultPolicy = M.getGlobalVariable("_hexbox_comp___hexbox_default");

        assert(DefaultPolicy && "Default Compartment not found");

        DefaultPolicy = ConstantExpr::getInBoundsGetElementPtr(nullptr,DefaultPolicy,Constant::getNullValue(Type::getInt32Ty(M.getContext())));
        Value * V;

        V = IRB->CreateBitCast(DefaultPolicy,HexboxStartFn->getFunctionType()->getParamType(0));
        Args.push_back(V);

        IRB->CreateCall(HexboxStartFn,Args);

        Args.clear();
        for (auto & arg : InitMain->args()){
            Args.push_back(&arg);

        }

        V = IRB->CreateCall(OrgMain,Args);
        SmallVector<Function *,12> Callees;
        Callees.push_back(OrgMain);
        CallSite cs = CallSite(V);
        addTransition(M,cs,Callees);
        IRB->CreateUnreachable();

        delete IRB;

    }


    void insertHexboxInit(Module & M, Json::Value PolicyRoot){
        interceptMain(M,PolicyRoot);
    }


    /**************************************************************************
     * addDataInitToMain
     * adds initialization of a Hexbox Data section to start of main
     *
     *************************************************************************/
    void addDataInit(Module & M, IRBuilder<> *IRB, StringRef &startName, \
                           StringRef &stopName, StringRef &vmaName){
        Function * SectionInit;
        SectionInit=M.getFunction("__hexbox_init_data_section");
        assert(SectionInit && "Can't find initialization routine check RT Lib");
        Type * arg0Type = Type::getInt32Ty(M.getContext());;
        Type * arg1Type = Type::getInt32Ty(M.getContext());;
        Type * arg2Type = Type::getInt32Ty(M.getContext());;

        Value *StartAddr =M.getOrInsertGlobal(startName,arg1Type);
        Value *StopAddr = M.getOrInsertGlobal(stopName,arg2Type);
        Value *VMAAddr = M.getOrInsertGlobal(vmaName,arg0Type);
        assert(StartAddr && StopAddr && VMAAddr && \
               "Data Section Addresses Need but not found");
        std::vector<Value *> CallParams;

        StartAddr = IRB->CreateIntToPtr(StartAddr,\
                                        Type::getInt32PtrTy(M.getContext()));
        StopAddr = IRB->CreateIntToPtr(StopAddr,\
                                       Type::getInt32PtrTy(M.getContext()));
        VMAAddr = IRB->CreateIntToPtr(VMAAddr,\
                                      Type::getInt32PtrTy(M.getContext()));

        CallParams.push_back(VMAAddr);
        CallParams.push_back(StartAddr);
        CallParams.push_back(StopAddr);
        IRB->CreateCall(SectionInit,CallParams);
    }


    /**************************************************************************
     * addBssInit
     * adds initialization of a Hexbox bss section to start of main
     *
     *************************************************************************/
    void addBssInit(Module & M, IRBuilder<> * IRB,StringRef & startName, \
                          StringRef & stopName){
        Function * SectionInit;

        SectionInit=M.getFunction("__hexbox_init_bss_section");
        assert(SectionInit && "Can't find initialization routine check RT Lib");


        Type * arg0Type = Type::getInt32Ty(M.getContext());
        Type * arg1Type = Type::getInt32Ty(M.getContext());

        Value *StartAddr = M.getOrInsertGlobal(startName,arg0Type);
        Value *StopAddr = M.getOrInsertGlobal(stopName,arg1Type);

        assert(StartAddr && StopAddr && \
               "BSS Section Addresses Need but not found");
        std::vector<Value *> CallParams;

        StartAddr = IRB->CreateIntToPtr(StartAddr,\
                                        Type::getInt32PtrTy(M.getContext()));
        StopAddr = IRB->CreateIntToPtr(StopAddr,\
                                       Type::getInt32PtrTy(M.getContext()));
        CallParams.push_back(StartAddr);
        CallParams.push_back(StopAddr);
        IRB->CreateCall(SectionInit,CallParams);
    }

     void initBssAndDataSections(Module &M, IRBuilder<> * IRB, Json::Value &Root){
        Json::Value PolicyRegions=Root.get("Regions","");
        for(auto RegionName: PolicyRegions.getMemberNames()){
            Json::Value Region = PolicyRegions[RegionName];
            Json::Value region_type = Region["Type"];
            if ( region_type.compare("Data") == 0 ){
                DEBUG(std::cout << "Initializing Data Region\n");
                //std::string DataSection(RegionName+"_data");
                //std::string BSSSection(RegionName+"_bss");
                bool DataUsed = false;
                bool BSSUsed = false;

                for (auto gvName : Region.get("Objects","")){
                     DEBUG(std::cout << gvName.asString() <<"\n");
                     GlobalVariable *GV;
                     GV = M.getGlobalVariable(StringRef(gvName.asString()),true);
                     if (GV){
                         DEBUG(errs() << "Adding "<<GV->getName() << " to ");
                         if ( GV->hasInitializer() ){
                             if (GV->getInitializer()->isZeroValue()){
                                BSSUsed=true;
                             }else{
                                DataUsed=true;
                             }
                         }else{
                             assert(false &&"GV Has no initializer");
                         }
                     }
                     else{
                         DEBUG(std::cout << "No Name GV for: "<< gvName <<"\n");
                     }
                 }//for
                if(BSSUsed){
                    std::string startVar = RegionName + "_bss_start";
                    std::string stopVar = RegionName + "_bss_end";
                    StringRef BSSStartVar = StringRef(startVar);
                    StringRef BSSEndVar = StringRef(stopVar);
                    addBssInit(M,IRB,BSSStartVar,BSSEndVar);
                }
                if(DataUsed){
                    std::string startVar = RegionName + "_data_start";
                    std::string stopVar =  RegionName + "_data_end";
                    std::string vmaStart = RegionName+"_vma_start";
                    StringRef LMAVar = StringRef(vmaStart);
                    StringRef DataStartVar = StringRef(startVar);
                    StringRef DataEndVar = StringRef(stopVar);
                    addDataInit(M,IRB, DataStartVar, DataEndVar, LMAVar);
                }
            }
        }
    }

    /**
     assignLinkerSections
     Reads the sections from the policy file and assigns functions and globals
     to specific sections.  These sections define tell the linker where to place
     the functions and globals. They compose regions of a compartment

    */
    void assignLinkerSections(Module &M, Json::Value &Root){
        Json::Value PolicyRegions=Root.get("Regions","");
        for(auto RegionName: PolicyRegions.getMemberNames()){
            Json::Value Region = PolicyRegions[RegionName];
            Json::Value region_type = Region["Type"];
            if ( region_type.compare("Code") == 0 ){
                for (auto funct : Region.get("Objects","")){
                    Function * F = M.getFunction(StringRef(funct.asString()));
                    if (F){
                        F->setSection(StringRef(RegionName));
                    }else{
                        std::cout << "No Name Function for: "<< funct <<"\n";
                    }
                }
            }else{
                std::string DataSection(RegionName+"_data");
                std::string BSSSection(RegionName+"_bss");
                for (auto gvName : Region.get("Objects","")){
                    GlobalVariable *GV;
                    GV = M.getGlobalVariable(StringRef(gvName.asString()),true);
                    if (GV){
                        if ( GV->hasInitializer() ){
                            if (GV->getInitializer()->isZeroValue()){
                                GV->setSection(StringRef(BSSSection));
                             }else{
                                GV->setSection(StringRef(DataSection));
                             }
                         }else{
                             assert(false &&"GV Has no initializer");
                         }
                     }
                     else{
                         std::cout << "No Name GV for: "<< gvName <<"\n";
                     }
                 }//for
            }
        }
    }

    /**
     * @brief buildCompartments
     * @param M : The Module
     * @param policy : The policy
     *
     * Reads the Compartment info from the policy file.  This defines what
     * section should be put together to form a compartment. It builds the
     * global data for each compartment, and the identifies and instruments
     * compartment entries and exits
     */
    void buildCompartments(Module & M, Json::Value & policy){

        buildGlobalVariablesForCompartments(M,policy);
        identifyTransitions(M,policy);

    }


    GlobalVariable * getMetadata(Module &M,SmallVector<Function *,12> &callees, Instruction * callInst){
        // Builds the metadata {return_policy, dest_count, [{dest_ptr,compartment},...]
        SmallVector<Type *,4> MDTypeVec;
        SmallVector<Constant *,6> MDValues;
        GlobalVariable * CompartmentGV = getCompartmentForFunction(callInst->getFunction());
        Constant * C;

        C = ConstantExpr::getInBoundsGetElementPtr(nullptr,CompartmentGV,Constant::getNullValue(Type::getInt32Ty(M.getContext())));
        MDValues.push_back(C);
        MDTypeVec.push_back(C->getType()); //return compartment

        C = Constant::getIntegerValue(Type::getInt32Ty(M.getContext()),APInt(32,callees.size()));
        MDValues.push_back(C);
        MDTypeVec.push_back(C->getType());

        errs() << "----------- Building Meta Data --------------------\n";
        errs() << "Function: " <<callInst->getFunction()->getName()<<"\n";
        for (Function * callee: callees){
            errs() << "Callee: " <<callee->getName() <<"\n";
            MDValues.push_back(callee);
            MDTypeVec.push_back(callee->getType());  //destinations

            CompartmentGV = getCompartmentForFunction(callee);
            C = ConstantExpr::getInBoundsGetElementPtr(nullptr,CompartmentGV,Constant::getNullValue(Type::getInt32Ty(M.getContext())));
            MDTypeVec.push_back(C->getType());
            MDValues.push_back(C);

        }
        errs() << "----------- End metadata --------------------\n";

        StructType * MDTy = StructType::create(MDTypeVec);
        Constant * MDInit = ConstantStruct::get(MDTy,MDValues);
        GlobalVariable * GV_MD = new GlobalVariable(M,MDInit->getType(),true,
                                                 GlobalVariable::ExternalLinkage,MDInit,"__hexbox_md");
        GV_MD->setSection(".rodata");


        return GV_MD;
    }


    void addTransition(Module & M, CallSite & cs,SmallVector<Function *,12> &callees){
        GlobalVariable * md;

        if (CallInst * ci = dyn_cast<CallInst>(cs.getInstruction())){ 
            md = getMetadata(M,callees,ci);
            ci->setHexboxMetadata(md);
            for (Function * callee : callees){
                //callee->setIsHexboxEntry(true);
                DEBUG(errs() << "\t" <<callee->getName() << ";");
                callee->addFnAttr("HexboxEntry","true");

            }

        }else{
            assert(true && "HexBoxApplication:CallSite not a CallInst");
        }
    }


    bool isTransition(Module &M, Function *CurFunct, CallSite &cs){
        SmallVector<Function *,12> callees;
        Function * callee = cs.getCalledFunction();
        if ( callee ){
            callees.push_back(callee);
        }else if (ConstantExpr * ConstEx = dyn_cast_or_null<ConstantExpr>(cs.getCalledValue())){
            Instruction * Inst = ConstEx->getAsInstruction();
            if( CastInst * CI = dyn_cast_or_null<CastInst>(Inst) ){
                if ( Function * c = dyn_cast<Function>(Inst->getOperand(0)) ){ 
                        callees.push_back(c);


                }else{
                    assert(false && "Unhandled Cast");
                }
            }else{
                assert(false && "Unhandled Constant");
            }
            delete Inst;
        }else{

            getIndirectTargets(M, cs, callees); //type-based matching and address taken enforcement
        }

        SmallVector<Function *,12>InstrumentCallees;

        for (Function * F :callees){
            if (F->getSection() == CurFunct->getSection()){
               F->addFnAttr("HexboxInternalCall");
            }
            if (F->getName().startswith("__hexbox")){
                ;
            }
            else if (F->getName().startswith("llvm.")){
                ;
            }
            else if (F->isIntrinsic() || F->isDeclaration()){
                errs() << "Found Declaration in call: "<<F->getName() <<"\n";
                errs() << "Function: " << cs->getFunction()->getName() << "\n";
                cs->dump();
            }
            else{
                InstrumentCallees.push_back(F);
            }
        }

        for (Function * F :InstrumentCallees){
            DEBUG(errs() << "sections: " << CurFunct->getSection() << " ; " );
            DEBUG(errs() << F->getName() << ":" << F->getSection() << "\n");
            if (F->getSection() != CurFunct->getSection()){
                addTransition(M,cs, callees);
                DEBUG(errs() << "Adding Transition\n");
                return true;
            }
        }
        return false;
    }


    bool TypesEqual(Type *T1,Type *T2,unsigned depth = 0){

        if ( T1 == T2 ){
            return true;
        }
        if (depth > 10){
            // If we haven't found  a difference this deep just assume they are
            // the same type. We need to overapproximate (i.e. say more things
            // are equal than really are) so return true
            return true;
        }
        if (PointerType *Pty1 = dyn_cast<PointerType>(T1) ){
            if (PointerType *Pty2 = dyn_cast<PointerType>(T2)){
            return TypesEqual(Pty1->getPointerElementType(),
                              Pty2->getPointerElementType(),depth+1);
            }else{
                return false;
            }
        }
        if (FunctionType * FTy1 = dyn_cast<FunctionType>(T1)){
            if (FunctionType * FTy2 = dyn_cast<FunctionType>(T2)){

                if (FTy1->getNumParams() != FTy2->getNumParams()){
                    return false;
                }
                if (! TypesEqual(FTy1->getReturnType(),
                                 FTy2->getReturnType(), depth+1)){
                    return false;
                }

                for (unsigned i=0; i<FTy1->getNumParams(); i++){
                    if (FTy1->getParamType(i) == FTy1 &&
                          FTy2->getParamType(i) == FTy2  ){
                        continue;
                    }else if (FTy1->getParamType(i) != FTy1 &&
                              FTy2->getParamType(i) != FTy2  ){
                        //jinwen comment
                        // FTy1->getParamType(i)->dump();
                        // FTy2->getParamType(i)->dump();
                        if( !TypesEqual(FTy1->getParamType(i),
                                        FTy2->getParamType(i), depth+1)){
                         return false;
                        }
                    }else{
                        return false;
                    }
                }
                return true;

            }else{
                return false;
            }
        }
        if (StructType *STy1 = dyn_cast<StructType>(T1)){
            if (StructType *STy2 = dyn_cast<StructType>(T2)){
                if(STy2->getNumElements() != STy1->getNumElements()){
                    return false;
                }
                if(STy1->hasName() && STy2->hasName()){
                    if(STy1->getName().startswith(STy2->getName()) ||
                        STy2->getName().startswith(STy1->getName())){
                        return true;
                    }
                }
                return false;
              }else{
                return false;
            }
        }
        return false;
    }

 
    void getIndirectTargets(Module & M, CallSite & cs,
                            SmallVector<Function *,12> &callees ){
        std::string str;
        raw_string_ostream callee_name(str);
        FunctionType * IndirectType;

        IndirectType = cs.getFunctionType();
        for (Function & F : M.getFunctionList()){
            if (F.getName().startswith("__hexbox") || F.isIntrinsic()|| \
                    F.hasFnAttribute("HexboxWrapper")){
                continue;
            }
            if ( TypesEqual(IndirectType,F.getFunctionType()) && F.hasAddressTaken() ){
                callees.push_back(&F);
            }
        }
    }


    /**
     * @brief identifyTransitions
     * @param policyFile
     * @param M
     *
     * For each function identify all call sites and their possible destinations.
     *
     */
    //USED
    void identifyTransitions(Module &M, Json::Value & policyFile){
        SmallSet<Function*,10> ISRs;
        for (Function & F : M.getFunctionList()){
            if (F.isIntrinsic() || F.isDeclaration()||F.getName().startswith("__hexbox")){
                continue;
            }
            DEBUG(errs() << "___________________________________________\n");
            DEBUG(errs().write_escaped(F.getName())<<"\n");
            for ( BasicBlock &BB : F ){
                for ( Instruction & I : BB ){
                    if ( CallSite cs = CallSite(&I) ){
                        if (!isa<InlineAsm>(cs.getCalledValue())){
                            DEBUG(errs() << "Checking Callsite: ");
                            DEBUG(cs->dump());
                            isTransition(M,&F,cs);
                            if(F.getSection().equals(StringRef(".IRQ_CODE_REGION"))&& \
                                    (! F.getName().equals("SVC_Handler"))){
                                ISRs.insert(&F);
                            }
                        }
                    }
                }
            }
            DEBUG(errs() << "-------------------------------------------\n");
        }
    }



    //AMI getIndirectTarget
    void AMI_getIndirectTargets(Module & M, CallSite & cs,
                            SmallVector<Function *,12> &callees ){

        //jinwen debug   ----------------------------------     

        // BasicBlock* ParentBB = cs.getInstruction()->getParent();
        // Function* ParentFunc = ParentBB->getParent();
        // std::string FunctionName = ParentFunc->getName().str();

        // int tgt_flag = 0;

        // std::string type_str;
        // llvm::raw_string_ostream rso(type_str);

        // // _ZN18AC_AttitudeControl22control_monitor_updateEv
        // std::string debug_str = "_ZN18AC_AttitudeControl22control_monitor_updateEv";
        // if(FunctionName == debug_str){
        //     tgt_flag = 1;
        //     errs() << "jinwen meets target function\n";
        //     errs() << "input size " << cs.arg_size() << "\n";
        //     for(int i = 0, e = cs.arg_size(); i != e; ++i){
        //         // errs() << cs.getArgument(i)->getType() << "\n";
        //           // Print the type
        //           // cs.getArgument(i)->getType()->print(llvm::errs());
        //           // llvm::errs() << "\n";

        //           cs.getArgument(i)->getType()->print(rso);
        //           rso.flush();
        //           errs() << type_str << "\n";

        //     }
        // }

        //--------------------------------------

        std::string str;
        raw_string_ostream callee_name(str);
        FunctionType * IndirectType;

        IndirectType = cs.getFunctionType();

        //jinwen debug
        // if(FunctionName == debug_str){
        //     errs() << IndirectType;
        // }

        for (Function & F : M.getFunctionList()){
            if (F.isIntrinsic() || F.getName().startswith("__AMI")){
                continue;
            }
            // jinwen debug remove commend
            // if ( TypesEqual(IndirectType,F.getFunctionType()) && F.hasAddressTaken() ){
            //     callees.push_back(&F);
            // }

            //jinwen debug check three functions. ----------------------------

            // std::string tgt_type_str;
            // llvm::raw_string_ostream tgt_rso(tgt_type_str);

            // if(tgt_flag == 1){
                
            //     if(F.getName() == "_ZN24AC_AttitudeControl_Multi17get_rate_roll_pidEv" || \
            //         F.getName() == "_ZN24AC_AttitudeControl_Multi18get_rate_pitch_pidEv" || \
            //         F.getName() == "_ZN24AC_AttitudeControl_Multi16get_rate_yaw_pidEv"){


            //         for (llvm::Function::arg_iterator AI = F.arg_begin(), AE = F.arg_end(); AI != AE; ++AI) {
            //           llvm::Type* ArgType = AI->getType();
            //           // Print the type
            //           // ArgType->print(llvm::errs());
            //           // llvm::errs() << "\n";

            //           ArgType->print(tgt_rso);
            //           tgt_rso.flush();
            //           errs() << tgt_type_str << "\n";
            //         }

            //         if(tgt_type_str.compare(0, type_str.size() - 1, type_str, 0, type_str.size() - 1) == 0){
            //             errs() << "they are the same\n";
            //         }


            //         // if(TypesEqual(IndirectType,F.getFunctionType()))

            //         // if(TypesEqual(IndirectType,F.getFunctionType())){
            //         //     errs() << "types the same\n";
            //         // }

            //         // if(F.hasAddressTaken()){
            //         //     errs() << "address are taken\n";
            //         // }

            //         // errs() << "jinwen meets problem functions\n";
                
            //     }                
            // }

            //---------------------------------------------------------------


            if ( TypesEqual(IndirectType,F.getFunctionType()) && F.hasAddressTaken() ){
                callees.push_back(&F);
                // jinwen debug
                // if(tgt_flag == 1){
                //     errs() << "transfer\n";
                // }
            }
            //some functions params have inherent problem
            //compare the type name, if the first substring is the same, then they are in 
            //inheret relationship
            else if(F.hasAddressTaken() && cs.arg_size() == F.arg_size()){
                // errs() << "arg_size are the same";
                int inherit_flag = 0;
                int com_arg_size = cs.arg_size();
                for(int i = 0; i < com_arg_size; i++){
                    //get 
                    std::string type_str;
                    llvm::raw_string_ostream rso(type_str);
                    cs.getArgument(i)->getType()->print(rso);
                    rso.flush();

                    std::string tgt_type_str;
                    llvm::raw_string_ostream tgt_rso(tgt_type_str);
                    llvm::Type* ArgType = F.getFunctionType()->getParamType(i);
                    ArgType->print(tgt_rso);
                    tgt_rso.flush();

                    if(tgt_type_str.compare(0, type_str.size() - 1, type_str, 0, type_str.size() - 1) != 0){
                        inherit_flag = 1;
                        break;
                    }
                }

                if(inherit_flag == 0){
                    callees.push_back(&F);
                    // if(tgt_flag == 1){
                    //     errs() << "inherit found!!!!!!\n";
                    // }
                }
            }
        }
    }


    // std::vector<std::map<llvm::Function*, std::vector<llvm::Function*>>> vectorOfMaps;
    // std::map<llvm::Function*, std::vector<llvm::Function*>> functionToCallees;

        // reference start
         // void assignLinkerSections(Module &M, Json::Value &Root){
         //        Json::Value PolicyRegions=Root.get("Regions","");
         //        for(auto RegionName: PolicyRegions.getMemberNames()){
         //            Json::Value Region = PolicyRegions[RegionName];
         //            Json::Value region_type = Region["Type"];
         //            if ( region_type.compare("Code") == 0 ){
         //                for (auto funct : Region.get("Objects","")){
         //                    Function * F = M.getFunction(StringRef(funct.asString()));
         //                    if (F){
         //                        F->setSection(StringRef(RegionName));
         //                    }else{
         //                        std::cout << "No Name Function for: "<< funct <<"\n";
         //                    }
         //                }
         //            }else{
         //                std::string DataSection(RegionName+"_data");
         //                std::string BSSSection(RegionName+"_bss");
         //                for (auto gvName : Region.get("Objects","")){
         //                    GlobalVariable *GV;
         //                    GV = M.getGlobalVariable(StringRef(gvName.asString()),true);
         //                    if (GV){
         //                        if ( GV->hasInitializer() ){
         //                            if (GV->getInitializer()->isZeroValue()){
         //                                GV->setSection(StringRef(BSSSection));
         //                             }else{
         //                                GV->setSection(StringRef(DataSection));
         //                             }
         //                         }else{
         //                             assert(false &&"GV Has no initializer");
         //                         }
         //                     }
         //                     else{
         //                         std::cout << "No Name GV for: "<< gvName <<"\n";
         //                     }
         //                 }
         //            }
         //        }
         //    }
         // reference ends

    //check whether a function is invoked by other functions in the same compartment
    int has_intra_cpt_ivk(Module &M, Function * callee){

        int cnt_invoke = 0;

        //locate to the callee block
        Json::Value Func_Regions = CFGRoot.get(callee->getName().str(),"");
        //locate to the connection block
        Json::Value Connec_Regions = Func_Regions.get("Connections","");
        //iterate connected functions
        for(auto func_name_region: Connec_Regions.getMemberNames()){
            // errs() << func_name_region << "\n";
            Json::Value Func = Connec_Regions.get(func_name_region, "");
            Json::Value Func_type = Func.get("Type", "");
            //find the callers
            if(Func_type.compare("Caller") == 0){
                // errs() << func_name_region << "\n";
                if(callee->getSection() == M.getFunction(func_name_region)->getSection()){
                    // errs() << func_name_region << "\n";
                    cnt_invoke += 1;
                }
                else{
                    // errs() << "Not invoked by other functions in the same cpt" << "\n";
                }
            }
        }

        return cnt_invoke;
    }


    //AMI isTransition
    bool AMI_isTransition(Module &M, Function *CurFunct, CallSite &cs,  SmallVector<Function *,50> &functions_with_cross_rt){
        
        //debug b cpt tsf
        // _ZN8AC_Avoid17adjust_velocity_zEffRff

        //debug for alias

        // GlobalAlias *globalalias = M.getNamedAlias("_ZN9SocketAPMC1Eb");
        // if(globalalias){
        //     errs() << "alias found!!!!!!\n";
        //     Constant *aliasee = globalalias->getAliasee();
        //     errs() << *aliasee << "\n";
        //     errs() << cs.getCalledValue()->getName() << "\n";
        // }
        // GlobalAlias *getNamedAlias(StringRef Name) const;


        //generate function invocation relationships

        // for (llvm::Module::iterator F = M.begin(), FE = M.end(); F != FE; ++F) {
        //     std::vector<llvm::Function*> callees;

        //     for (llvm::Function::iterator BB = F->begin(), BBE = F->end(); BB != BBE; ++BB) {
        //         for (llvm::BasicBlock::iterator I = BB->begin(), IE = BB->end(); I != IE; ++I) {
        //             if (llvm::CallInst* callInst = llvm::dyn_cast<llvm::CallInst>(&*I)) {
        //             llvm::Function* calledFunction = callInst->getCalledFunction();
        //                 // direct call
        //                 if (calledFunction) {
        //                     callees.push_back(calledFunction);
        //                 }
        //                 // indirect call
        //             }
        //         }
        //     }
        //     functionToCallees[&*F] = callees;
        //     // vectorOfMaps.push_back(functionToCallees);
        // }


        SmallVector<Function *,12> callees;
        Function * callee = cs.getCalledFunction();
        //get direct jump target
        if( callee ){

            //jinwen comment for debug
            // return true;

            // if(callee->isIntrinsic() || callee->isDeclaration() || 
            //     callee->getName().startswith("__AMI") || 
            //     callee->getName().startswith("llvm.")){
            //     return false;
            // }

            if(callee->isIntrinsic() || callee->isDeclaration() ||
                callee->getName().startswith("__AMI")){
                return false;
            }

            callees.push_back(callee);
            //check whether jump/indirect jump transfers between compartments

            for(Function * F : callees){
                if (F->getSection() != CurFunct->getSection()){
                    // errs()<<"compartment transfer using direct jump\n";
                    // DEBUG(errs() << "Adding Transition\n");
                    //refer addDataInit
                    IRBuilder<> *IRB;
                    IRB = new IRBuilder<>(cs.getInstruction());
                    Type *VoidTy = IRB->getVoidTy();
                    Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_direct_transfer", VoidTy, nullptr);
                    Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                    IRB->CreateCall(CheckUseEvtFunc);

                    //check whether callee has been added to functions_with_cross_rt
                    //if not, add it into functions_with_cross_rt
                    int exsiting_flag = 0;
                    for(Function * F : functions_with_cross_rt){
                        if(F == callee){
                            exsiting_flag = 1;
                            break;
                        }
                    }
                    if(!exsiting_flag){
                        //decide whether the callee is invoked intra-compartment
                        if(has_intra_cpt_ivk(M, callee) == 0){
                            functions_with_cross_rt.push_back(callee);
                        }
                        else{
                            //TODO:duplicate functions
                            functions_with_cross_rt.push_back(callee);
                        }
                        //original codes
                        // functions_with_cross_rt.push_back(callee);

                    }

                    return true;
                }        
            }

        }


        //debug refering ACES starts
        // else if (ConstantExpr * ConstEx = dyn_cast_or_null<ConstantExpr>(cs.getCalledValue())){
        //     errs() << "newly added branch\n";
        //     Instruction * Inst = ConstEx->getAsInstruction();
        //     if( CastInst * CI = dyn_cast_or_null<CastInst>(Inst) ){
        //         if ( Function * c = dyn_cast<Function>(Inst->getOperand(0)) ){ 
        //                 // callees.push_back(c);
        //             errs() << "newly added branch\n";
        //         }else{
        //             assert(false && "Unhandled Cast");
        //         }
        //     }else{
        //         assert(false && "Unhandled Constant");
        //     }
        //     delete Inst;
        // }
        //debug refering ACES ends
        //get indirect jump target

        
        else{
            // errs() << "indirect jump\n";
            AMI_getIndirectTargets(M, cs, callees); //type-based matching and address taken enforcement
            //check whether jump/indirect jump transfers between compartments

            //jinwen debug remove
            SmallVector<Function *,12> cross_cpt_callees;

            for(Function * F : callees){
                if(F->getSection() != CurFunct->getSection()){
                    cross_cpt_callees.push_back(F);

                    //check whether callee has been added to functions_with_cross_rt
                    //if not, add it into functions_with_cross_rt
                    int exsiting_flag = 0;
                    for(Function * existing_F : functions_with_cross_rt){
                        if(existing_F == F){
                            exsiting_flag = 1;
                            break;
                        }
                    }
                    if(!exsiting_flag){

                        //decide whether the callee is invoked intra-compartment
                        if(has_intra_cpt_ivk(M, F) == 0){
                            functions_with_cross_rt.push_back(F);
                        }
                        else{
                            //TODO:duplicate functions
                            functions_with_cross_rt.push_back(F);
                        }

                        // original codes
                        // functions_with_cross_rt.push_back(F);
                    }
                }
            }

            if(!cross_cpt_callees.empty()){
                // errs() << "~~~~~~~~~~~~~~~~indirect call transfer~~~~~~~~~~~~~~~~~~";
                // errs() << "cross_cpt_callees size: " << cross_cpt_callees.size() << "\n";
                //debug commend
                IRBuilder<> *IRB;
                IRB = new IRBuilder<>(cs.getInstruction());
                Type *VoidTy = IRB->getVoidTy();
                Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_indirect_transfer", VoidTy, nullptr);
                Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                IRB->CreateCall(CheckUseEvtFunc); 
            }
            
        }

        return false;
    }



    void AMI_instrument_cpt_rt(Module &M, SmallVector<Function *,50> &functions_with_cross_rt){
        //label runctions maybe invoked from other compartment
        for(Function * F : functions_with_cross_rt){
            // errs() << "======================"<< F->getName() << "======================\n";
            for(BasicBlock & BB : *F){
                for(Instruction & I : BB){
                    //find ret IR and insert label function
                    if(I.getOpcode() == Instruction::Ret){
                        //insert label function
                        //debug commend
                        IRBuilder<> *IRB;
                        IRB = new IRBuilder<>(&I);
                        Type *VoidTy = IRB->getVoidTy();
                        Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_rt_transfer", VoidTy, nullptr);
                        Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                        IRB->CreateCall(CheckUseEvtFunc); 
                    }
                }
            }
        }
    }


    // __AMI_fake_local_wrt
    // __AMI_fake_shared_wrt

    //lable memory write in from end pass
    void AMI_label_mem_wrt(Module &M){

        for (auto& F : M) {
            for (auto& BB : F) {
                for (auto& I : BB) {
                    if (auto* storeInst = llvm::dyn_cast<llvm::StoreInst>(&I)) {
                        llvm::Value* ptrOperand = storeInst->getPointerOperand();
                        if (ptrOperand->hasName()) {
                            if (llvm::isa<llvm::GlobalVariable>(ptrOperand)) {
                                // llvm::errs() << "Stored global variable: " << ptrOperand->getName() << "\n";

                                //check static attribute, jinwen write this for debug

                                // if (llvm::GlobalVariable* GV = llvm::dyn_cast<llvm::GlobalVariable>(ptrOperand->stripPointerCasts())) {
                                //     if (GV->hasInternalLinkage()) {
                                //         // The operand is a pointer to a static variable.
                                //         errs() << "hasInternalLinkage" << ptrOperand->getName() << "\n";

                                //     } else {
                                //         // The operand is a pointer to a non-static variable.
                                //         errs() << "non-static variable" << ptrOperand->getName() << "\n";
                                //     }
                                // } else {
                                //     // The operand is not a pointer to a GlobalVariable.
                                // }

                                std::string curr_glb_var_name = ptrOperand->getName();                                
                                std::string shared_variable = SHARED_DATA_REGION;

                                if(var2sec[curr_glb_var_name] == shared_variable){
                                    //insert global variable write lable function
                                    IRBuilder<> *IRB;
                                    IRB = new IRBuilder<>(&I);
                                    Type *VoidTy = IRB->getVoidTy();
                                    Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_shared_wrt", VoidTy, nullptr);
                                    Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                                    IRB->CreateCall(CheckUseEvtFunc); 

                                    // errs() << "__AMI_fake_shared_wrt\n";
                                }
                                else{
                                    //insert local variable write lable function
                                    //backend should have the relationship between function and section

                                    // IRBuilder<> *IRB;
                                    // IRB = new IRBuilder<>(&I);
                                    // Type *VoidTy = IRB->getVoidTy();
                                    // Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_local_wrt", VoidTy, nullptr);
                                    // Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                                    // IRB->CreateCall(CheckUseEvtFunc); 

                                    IRBuilder<> *IRB;
                                    IRB = new IRBuilder<>(&I);
                                    Type *VoidTy = IRB->getVoidTy();
                                    Constant *CheckUseEvt = M.getOrInsertFunction("__AMI_fake_local_wrt", VoidTy, nullptr);
                                    Function *CheckUseEvtFunc = cast<Function>(CheckUseEvt);
                                    IRB->CreateCall(CheckUseEvtFunc); 

                                    // errs() << "__AMI_fake_local_wrt\n";

                                }

                                //modifying local variables
                            } else if (llvm::isa<llvm::AllocaInst>(ptrOperand)) {
                                // llvm::errs() << "Stored local variable: " << ptrOperand->getName() << "\n";
                                //TODO stack isolation lablel
                            }
                        }
                        else{
                            if (ptrOperand->getType()->isPointerTy()) {
                                //TODO label variable write through pointer
                                // errs() << "The type of the pointer operand is: " << *(ptrOperand->getType()) << "\n";
                                // errs() << "found pointers";
                                // llvm::Type* ptrType = ptrOperand->getType();
                                    // It is a pointer type, get the pointee type
                                // llvm::Type* pointeeType = ptrType->getPointerElementType();
                                //TODO type based point to analysis, move all varaibles that is possible
                                //accessed by multiple sections to global variable section

                                // If you want to print the pointee type
                                // llvm::errs() << "Pointee type: " << *pointeeType << "\n";
                            }
                        }
                    }
                }
            }
        }


    }



    //AMI shared variables identification
    void AMI_identifySharedVar(Module &M){

        for (auto& F : M) {
            for (auto& BB : F) {
                for (auto& I : BB) {
                    if (auto* storeInst = llvm::dyn_cast<llvm::StoreInst>(&I)) {
                        llvm::Value* ptrOperand = storeInst->getPointerOperand();
                        if (ptrOperand->hasName()) {
                            if (llvm::isa<llvm::GlobalVariable>(ptrOperand)) {
                                // llvm::errs() << "Stored global variable: " << ptrOperand->getName() << "\n";

                                std::string curr_glb_var_name = ptrOperand->getName();

                                //global variable appear the first time
                                if(var2sec.find(curr_glb_var_name) == var2sec.end()){
                                    var2sec[curr_glb_var_name] = F.getSection();
                                }
                                else{
                                    std::string existing_section = var2sec[curr_glb_var_name];
                                    //check whether the global variable is accessed from multiple differnt sections
                                    if(existing_section != F.getSection()){
                                        var2sec[curr_glb_var_name] = SHARED_DATA_REGION; 
                                        //reassign the variable section, untested code
                                        GlobalVariable *GV;
                                        GV = M.getGlobalVariable(StringRef(curr_glb_var_name), true);
                                        GV->setSection(StringRef(SHARED_DATA_REGION));
                                    }                                    
                                }

                                //modifying local variables
                            } else if (llvm::isa<llvm::AllocaInst>(ptrOperand)) {
                                // llvm::errs() << "Stored local variable: " << ptrOperand->getName() << "\n";
                                //TODO stack isolation
                            }
                        }
                        else{
                            if (ptrOperand->getType()->isPointerTy()) {
                                // errs() << "The type of the pointer operand is: " << *(ptrOperand->getType()) << "\n";
                                // errs() << "found pointers";
                                llvm::Type* ptrType = ptrOperand->getType();
                                    // It is a pointer type, get the pointee type
                                llvm::Type* pointeeType = ptrType->getPointerElementType();
                                //TODO type based point to analysis, move all varaibles that is possible
                                //accessed by multiple sections to global variable section

                                // If you want to print the pointee type
                                // llvm::errs() << "Pointee type: " << *pointeeType << "\n";
                            }
                        }
                    }
                }
            }
        }

        AMI_label_mem_wrt(M);

        // for(const auto &pair : var2sec){
        //     // errs() << "Key: " << pair.first << ", Value: " << pair.second << "\n";
        //     errs() << "Key: " << pair.first << ", Value: " << pair.second << "\n";
        // }
    }





    //AMI Function Transfer Identification

    void AMI_identifyTransitions(Module &M){
        //functions which will return to different compartment, compartment id the function will return to
        SmallVector<Function *,50> functions_with_cross_rt;

        for(Function & F : M.getFunctionList()){
            if(F.isIntrinsic() || F.isDeclaration() || 
                F.getName().startswith("__AMI") || 
                F.getName().startswith("llvm.") ){
                    // || !F.getName().startswith("_ZN11AP_ICEngine6updateEv")){
                continue;
            }
            
            //debug commend
            // if(!F.getName().startswith("_ZN7HALSITL10SITL_StateC2Ev")){
            //     continue;
            // }

            for(BasicBlock & BB : F){
                for(Instruction & I : BB){
                    if (CallSite cs = CallSite(&I)){
                        if (!isa<InlineAsm>(cs.getCalledValue())){
                            //jinwen comment for debug
                            AMI_isTransition(M, &F, cs, functions_with_cross_rt);
                        }
                    }
                }
            }
        }
        AMI_instrument_cpt_rt(M, functions_with_cross_rt);
    }




    //identify compartment transfer and previous stack access
    //including pointers of previous function local varibales passed in function.
    void __AMI_identifyTransitions(Module &M){
        //functions which will return to different compartment, compartment id the function will return to
        SmallVector<Function *,50> functions_with_cross_rt;

        for(Function & F : M.getFunctionList()){
            if(F.isIntrinsic() || F.isDeclaration() || 
                F.getName().startswith("__AMI") || 
                F.getName().startswith("llvm.") ){
                    // || !F.getName().startswith("_ZN11AP_ICEngine6updateEv")){
                continue;
            }

            // errs() << F.getName() << "\n";
            //debug commend
            // if(!F.getName().startswith("_ZN6Copter9fast_loopEv")){
            //     continue;
            // }

            for(BasicBlock & BB : F){
                for(Instruction & I : BB){
                    if (CallSite cs = CallSite(&I)){
                        if (!isa<InlineAsm>(cs.getCalledValue())){
                            AMI_isTransition(M, &F, cs, functions_with_cross_rt);
                        }

                        //-------------------new codes start-------------------------  
                        
                        if(F.getName().startswith("main")){

                            Function *called_func = cs.getCalledFunction();
                            if(called_func && !called_func->isDeclaration()){
                                errs() << "function name: "<< called_func->getName() << " arg num:" << cs.arg_size() <<  "inst oper num: " << I.getNumOperands()<<"\n";
                            }
                            else{continue;}
                            int arg_index = 0;
                            for (CallSite::arg_iterator arg = cs.arg_begin(); arg_index != cs.arg_size(); arg++,arg_index++){
                    
                                // errs() << "byval:" << cs.isByValArgument(arg_index) << "\n";
                                // errs() << "byvaloralloc" << cs.isInAllocaArgument(arg_index) << "\n";

                                // if(cs.isByValArgument(arg_index)){

                                //     errs() << F.getName() << "\n";
                                //         errs() <<";;;;;;;;" <<arg_index << ";;;;;;;;\n ";
                                // } 

                                FunctionType *FT =  called_func->getFunctionType();

                                Type *ParamTy = FT->getParamType(arg_index);

                                PointerType *ParamPTy = dyn_cast<PointerType>(ParamTy);

                                if(ParamPTy){
                                    errs() << "pointer params\n";
                                }

                                // if(called_func->getAttributes().hasAttrSomewhere(Attribute::ByVal)){
                                //     errs() << "****byval****\n";
                                // }

                                //the last one is the function to be called
                                for(int i = 0; i < I.getNumOperands(); i++){
                                    errs() << "operand " << i<< ": " << *(I.getOperand(i)) << "\n";
                                    errs() << "operand type: " << *(I.getOperand(i)->getType()) << "\n";
                                    // errs() << "operand name: " << I.getOperand(i)->getValueName() << "\n";
                                }                           

                            }
                        }

                        //-------------------new codes end-------------------------  

                    }

                }
            }
        }

        AMI_instrument_cpt_rt(M, functions_with_cross_rt);

    }





    // void AMI_identifyPreviousStackAccess(Module &M){

    // }




    /**************************************************************************
     * runOnModule
     * Reads in a policy JSON file and moves functions and data to the
     * designated regions
     *
     *************************************************************************/
    bool runOnModule(Module &M) override {

        // return false;

        if ( HexboxPolicy.compare("-") == 0 )
            return false;

        //Read in Policy File
        Json::Value PolicyRoot;
        std::ifstream policyFile;
        policyFile.open(HexboxPolicy);
        policyFile >> PolicyRoot;

        // errs() << "pos1\n";

        //assigning sections for each compartment
        assignLinkerSections(M,PolicyRoot);

        // errs() << "pos2\n";

        // std::map<std::string, int> var2sec;

        //jinwen comment this for debug
        //identify shared variables, reassign these variables to shared variable section
        AMI_identifySharedVar(M);

        // errs() << "pos3\n";


        //label each variable access to easy data SFI afterwards

        //identify function transfers and add function transfer fake functions
        //meanwhile, record possible transfer targets
        //Read in CFG File
        std::ifstream cfgFile;
        // cfgFile.open("/home/osboxes/Desktop/conattest/ardupilot/analysis_result.json");
        cfgFile.open("./analysis_result.json");        
        cfgFile >> CFGRoot;

        //jinwen comment this for debug
        //debug commend
        AMI_identifyTransitions(M);

        // errs() << "pos4\n";

        // //identifying memory access on previous stack space
        // AMI_identifyPreviousStackAccess(M);

        // original acse codes
        // buildCompartments(M,PolicyRoot);
        // insertHexboxInit(M,PolicyRoot);

        return true;
    }



    bool doFinalization(Module &M) override{

        if ( HexboxPolicy.compare("-") == 0 )
            return false;

        return false;
    }


    void getAnalysisUsage(AnalysisUsage &AU) const override {
      //AU.setPreservesAll();
    }
  };

}
char HexboxApplication::ID = 0;
INITIALIZE_PASS(HexboxApplication, "HexboxApplication", "Applies specified hexbox policy", false, false)


ModulePass *llvm::createHexboxApplicationPass(){
  DEBUG(errs() << "Hexbox Application Pass" <<"\n");
  return new HexboxApplication();
}


