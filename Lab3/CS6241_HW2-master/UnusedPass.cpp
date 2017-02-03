#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/IR/DebugInfo.h"
#include <set>
#include <list>
#include <queue>
using namespace llvm;

namespace {

    struct UnusedPass : public FunctionPass {
        static char ID;
        UnusedPass() : FunctionPass(ID) {}

        virtual bool runOnFunction(Function &F) {
            std::set<Value*> unused;
            for (Function::iterator fit = F.begin(); fit != F.end(); fit++) {
                for (BasicBlock::iterator bbit = fit->begin(); bbit != fit->end(); bbit++) {
                    if (AllocaInst *inst = dyn_cast<AllocaInst>(bbit)) {
                        unused.insert(dyn_cast<Value>(inst));
                        errs() << "Variable Name: " << inst->getName() << " loc: " << inst << '\n';
                    }
                    if (StoreInst *inst = dyn_cast<StoreInst>(bbit)) {
                        Value *value = inst->getValueOperand();
                        if (dyn_cast<Constant>(value)) {
                            continue;
                        }
                        std::queue<Instruction *> queue;
                        queue.push(cast<Instruction>(value));
                        while (!queue.empty()) {
                            Instruction* pred_inst = queue.front();
                            for (User::op_iterator op_it = pred_inst->op_begin(); op_it != pred_inst->op_end(); op_it++) {
                                Value *v1 = pred_inst->getOperand(0);
                                unused.erase(v1);
                                if (Instruction* subInst = dyn_cast<Instruction>(v1)) 
                                    queue.push(subInst);
                            }
                            queue.pop();
                        }
                    }
                }
            }
            for (Value *v : unused) {
                errs() << "Unused Variable: " << v << '\n';
            }
            return false;
        }
        
    };
    
    char UnusedPass::ID = 0;
    static RegisterPass<UnusedPass> X("unused-pass", "Detects Unused calls", false, false);
}
