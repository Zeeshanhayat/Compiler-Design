/*
    LAB ASSIGNMENT # 03 
     Compiler Design
        GROUP AA
Muhammad Ikram Ul Haq  - 387605
Zeeshan Hayat          - 387503
Asim Siddiqui          - 387527

Algorithem:

We followed the Reaching Pass Approach. To do that we followed below mentioned steps:
----- First Part Def Pass
- We created Gen Set from each basic block using store instruction.
- We just initialized the IN & OUT Set for each Basic Block. To start with this step we initialized OUT Set of each Basic Block with 
  all variables inside the program.
- We have a loop which then calculated NEW IN and NEW OUT for each Basic Block. We get one Basic Block and check all of its predecessor 
  and calculated the OUTs of each of its PREDECESSOR. At the end we did the INTERSERSECTION of all OUTS of Predecessors to get the IN of 
  Basic Block.
- To calculate the IN of each Basic Block , we used INTERSECTION(OUTS of ALL PREDECESSORS).
- As a next step we calculated the NEW OUT of each Basic Block, For this we used the GEN Set of Each Basic Block along with NEW IN of each Basic Block.
- To get the OUT of each Basic Block we used OUT = GEN Union NEW_IN.
- Then after calculation IN and OUT we compare the NEW IN and NEW OUT with previous IN and OUT for each Basic Block. If it changes we swap the previous 
  Value with new one and move towards the new Basic Block to perform compution again.
- To Print The Uninitialized Variable we are checking for each Load instruction inside each Basic Block and two things.
   . Variable must not be lie inside the IN set of this basic block.
   . Variable is not inside in IN set and also has not been intialized within this Basic Block. 
  so if both of these conditions are satisfied we are printing the Variables as Uninitialized.
-
----- Second Part Fix Pass
- To start with FIX PASS , we iterate towards each Basic Block and find each Variable (Allocate Instruction).
- We find out the Type of each Variable and set the new value correspondingly like for integer 10, double 20 ...
- As a lst step we Created a new store instruction and assigned that variable new value just after that allocated instruction 
  where it is being used using insertAfter built-in function.

*/


#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/Analysis/CFG.h"
#include <set>
#include <list>
using namespace llvm;
using namespace std;

namespace {

    class GenSets {
        public:
            std::set<string> gen;
    };
     
    class OutSets {
        public:
            std::set<string> out;
    };

    struct VarInfo {
        bool isStored;
    };

    class BBGenSets {
        public:
            BasicBlock *bb;
            std::set<string> gen;
            BBGenSets(BasicBlock *val) { bb = val; }
            //To Check Gen function Output.
            void genString() {
                errs() << "Gen Set of BB:" + bb->getName().str() + '\n';
                for (auto instr = gen.begin(); instr != gen.end(); instr++) {
                    errs() << '\t' << *instr << '\n';
                }
            }
    };

    class BBInAndOut {
        public:
            BasicBlock *bb;
            std::set<string> in;
            std::set<string> out;
            BBInAndOut(BasicBlock *val) { bb = val; }
            //To Check INs and Outs.
            void inString() {
                errs() << "In Set of BB:" << bb << '\n';
                for (auto instr = in.begin(); instr != in.end(); instr++) {
                    errs() << '\t' << *instr << '\n';
                }
            }
            void outString() {
                errs() << "Out Set of BB:" << bb << '\n';
                for (auto instr = out.begin(); instr != out.end(); instr++) {
                    errs() << '\t' << *instr << '\n';
                }
            }
    };
	
	void printSet(set<string> out) {
            for (auto it = out.begin(); it != out.end(); it++) {           	
            	  errs() << '\t' << *it << '\n';
            }
    }

    struct DefinitionPass : public FunctionPass {
        static char ID;
        set<string> allocatedVars; // To store all Allocated Variables 
        DefinitionPass() : FunctionPass(ID) {}
        
        virtual bool runOnFunction(Function &F) {
            std::list<BBGenSets> listOfSets;
            std::list<BBInAndOut> output;
            getAllocatedVariable(F);

            //First, Generate the Gen Sets And initialize the output 
            for (Function::iterator f_it = F.begin(); f_it != F.end(); ++f_it) {
                listOfSets.push_back(createBBGenSets(F, f_it)); 
            }
            // For initializing the output i.e all outs of BB to Allocated variables
            for (Function::iterator bb = F.begin(); bb != F.end(); ++bb) {
                BBInAndOut out(bb);
                output.push_back(createBBInOutSets(F, bb));
            }

            //Now go through a while loop to generate new ins and  new outs.
            bool change = true;
            while (change) {
                //Set this to false for now, change if changes are made.
                change = false;
                for (BBGenSets sets : listOfSets) {
		            //First get out the in and out for this basic block.
                    for (std::list<BBInAndOut>::iterator it = output.begin(); it != output.end(); it++) {
                        if (it->bb == sets.bb) {
                            std::set<std::string> new_in;
                            std::set<std::string> new_out;			
                            //Go through predecessors and get new In
                            int count_for_pred = 0;
                            for (pred_iterator pi = pred_begin(sets.bb); pi != pred_end(sets.bb); pi++) {
				                count_for_pred++;
                                std::set<std::string> new_temp_in;
                                std::set<std::string> global_in;
                                BasicBlock *pred = *pi;
                                for (std::list<BBInAndOut>::iterator list_it = output.begin();list_it != output.end(); list_it++) {
                                    BBInAndOut &pred_out = *list_it;
                                    if (pred_out.bb == pred) {                                          
                                       for (std::string inst  : pred_out.out) {                                                                   
					  	                    new_temp_in.insert(inst);                                           					   					   
                                        }                                                                                
                                    }                                  
                                }        
                                if (count_for_pred == 1) {
                                    new_in = new_temp_in ;
                                }
                                else {
                                 // Taking Intersection of all Precdessor OUTs to calculate the IN of each Basic Block
                                    global_in = new_in;
                                    std::set<string> local_intersection;              
 			                        set_intersection(global_in.begin(),global_in.end(),new_temp_in.begin(),new_temp_in.end(),std::inserter(local_intersection,local_intersection.begin()));  
                                    new_in =  local_intersection ;                                          
                                }
                            }

                            //Now get new Out from gen set union (IN)
                            for (std::string inst : sets.gen) {
                                new_out.insert(inst);
                            }
                                                
                            for (std::string inst : new_in) {                            
                                new_out.insert(inst);                              
                            }
                         
                            //Now Check for Changes
                             
                            if (new_out != it->out || new_in != it->in) {
                                change = true;
                                swap(it->in, new_in);
                                swap(it->out, new_out);      
                            }
                        }
                    }
                }
            }

            /* To Print Uninitialized Vars*/
            printUninitializedVars(listOfSets,output);          
                
            return false;
        }
        
        /* To print the Uninitialized Variables */
        void printUninitializedVars(std::list<BBGenSets> listOfSets , std::list<BBInAndOut> output){

                for (BBGenSets sets : listOfSets) {
                    for (std::list<BBInAndOut>::iterator it = output.begin(); it != output.end(); it++) {                        
			            if (it->bb == sets.bb) {
                            BasicBlock *currentBlock = sets.bb;
 			                std::map<string,VarInfo> localBasicBlockGen; 
                            VarInfo variableStatus;
                            for (BasicBlock::iterator ii = currentBlock->begin(), ie = currentBlock->end(); ii != ie; ++ii) { 
                                if (LoadInst *li = dyn_cast<LoadInst>(&*ii)) {
                       		       std::string varName = li->getOperand(0)->getName().str();
                        	       DebugLoc Loc = li->getDebugLoc();
				                   if (li->getOperand(0)->hasName()){                                    
                                        if ((it->in.count(varName) == 0 ) && (localBasicBlockGen[varName].isStored == false)) {                                    
                                           errs() <<"Variable "<<varName<<" may be uninitialized on line " << Loc.getLine() << " " <<"\n";
                                        }
				                    }
                                }  
                                     
                                if (StoreInst *SI = dyn_cast<StoreInst>(&*ii)) {
                                   Value *PtrOp = SI->getPointerOperand();
                       		       std::string varName = PtrOp->getName().str();
                                    if (PtrOp->hasName()){
                               		   variableStatus.isStored = true;                                                  
                              		    localBasicBlockGen[varName] = variableStatus;                              
                                    }
                               }     
                            }        
                        }
                    }
		        }
        } 
        
        /* This function will Create the Gen Set for each Basic Block and return the Gen Set */
        BBGenSets createBBGenSets(Function &F, BasicBlock *f_it) {
            BBGenSets bbSets(f_it);
            for (BasicBlock::iterator bb_it = f_it->begin(); bb_it != f_it->end(); bb_it++) {
                if (StoreInst *inst = dyn_cast<StoreInst>(bb_it)) {
                    Value *var = inst->getPointerOperand();
                    string varName = inst->getPointerOperand()->getName().str();
                    GenSets sets; 
                    if (var-> hasName()) 
                       if (sets.gen.count(varName) == 0)
                          sets.gen.insert(varName);                 
                            for (std::string genVar : sets.gen) {
                               bbSets.gen.insert(genVar);
                            }
                }
            }
            return bbSets;
        }

        /* This function will get all Allocated Variables inside the Code  */
        void getAllocatedVariable(Function &F){
            for (BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
                for (BasicBlock::iterator bb_it = b.begin(); bb_it != b.end(); bb_it++) {
                    if (AllocaInst *inst = dyn_cast<AllocaInst>(&*bb_it)) {
                        string varName = inst->getName().str();
                        if (inst-> hasName()) 
                            if (allocatedVars.count(varName) == 0)
                                allocatedVars.insert(varName);                
                    }
	           }        
            }
        }
        /* This function will INITIALIZE all OUTs of Each Basic Block with ALLOCATED VARIABLES */
        BBInAndOut createBBInOutSets(Function &F, BasicBlock *f_it) {
            BBInAndOut bbSets(f_it);
            bbSets.out = allocatedVars;                
            return bbSets;
        }
    };

/* This Class cover the FIX PASS Implementation */
class FixingPass : public FunctionPass {
public:
  static char ID;
  map<string,string> allocatedVarsWithType; // Map to store all variable and their type correspondingly
  FixingPass() : FunctionPass(ID) {}

  virtual void getAnalysisUsage(AnalysisUsage &au) const {
    au.setPreservesCFG();
  }

  virtual bool runOnFunction(Function &F) {
    assignAllocatedVariableWithValue(F);  
    return true;
  }
  
  /* This function will Get ALL ALLOCATED VARIABLES and assign a new Value to them corresonding to its type
      Integer = 10;
      Double = 30.0;
      Float = 20.0; 
  */
   void assignAllocatedVariableWithValue(Function &F){
        for (BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
            for (BasicBlock::iterator bb_it = b.begin(); bb_it != b.end(); bb_it++) {
                if (AllocaInst *inst = dyn_cast<AllocaInst>(&*bb_it)) {
                    string varName = inst->getName().str();
                    string varType;
                    if(inst->hasName()) //And it has a name
                        {
                            if(inst->getAllocatedType()->isDoubleTy()) {
                                varType = "Double";
                                double d_init = 30.0;
                                Value *num = ConstantFP::get(Type::getDoubleTy(b.getContext()), d_init);
                                StoreInst *my_store = new StoreInst(num,inst);
                                my_store->insertAfter(inst);
                            }
                            else if(inst->getAllocatedType()->isFloatTy()) {
                                varType = "Float";
                                float f_init = 20.0;                             
                                Value *num = ConstantFP::get(Type::getFloatTy(b.getContext()), f_init);
                                StoreInst *my_store = new StoreInst(num,inst);
                                my_store->insertAfter(inst);
                            }
                            else if(inst->getAllocatedType()->isIntegerTy()) {
                                varType = "Integer";
                                int i_init = 10 ;
                                Value *num = ConstantInt::get(Type::getInt32Ty(b.getContext()), i_init);
                                StoreInst *my_store = new StoreInst(num,inst);
                                my_store->insertAfter(inst);
                            }
                            else {
                                errs() << " unknown type";
                            }

                        }
                   allocatedVarsWithType[varName] = varType ;                
                }
	        }
        }
    }

};
    
char DefinitionPass::ID = 0;
char FixingPass::ID = 1;

// Pass registrations
static RegisterPass<DefinitionPass> X("def-pass", "Uninitialized variable pass");
static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");
}