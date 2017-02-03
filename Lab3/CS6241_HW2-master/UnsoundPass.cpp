#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/IR/DebugInfo.h"
#include <set>
#include <list>
using namespace llvm;

namespace {

    struct UnsoundPass : public FunctionPass {
        static char ID;
        UnsoundPass() : FunctionPass(ID) {}
        
        virtual bool runOnFunction(Function &F) {
            std::set<Value*> allocated;
            std::set<Value*> defined;
            for (Function::iterator fit = F.begin(); fit != F.end(); fit++) {
                for (BasicBlock::iterator bbit = fit->begin(); bbit != fit->end(); bbit++) {
                    if (AllocaInst *inst = dyn_cast<AllocaInst>(bbit)) {
                        allocated.insert(dyn_cast<Value>(inst));
                    }
                    if (StoreInst *inst = dyn_cast<StoreInst>(bbit)) {
                        defined.insert(inst->getPointerOperand());
                    }
                    if (LoadInst *inst = dyn_cast<LoadInst>(bbit)) {
                        if (defined.find(dyn_cast<Value>(inst)) == defined.end()) {
                            if (MDNode *md = bbit->getMetadata("dbg")) {
                                DILocation loc(md);
                                unsigned line = loc.getLineNumber();
                                errs() << "On line " << line << '\n';
                            }
                            errs() << "\tUninitialized variable found " << inst->getPointerOperand()->getName() << '\n';
                        }
                    }
                }
            }
            return false;
        }
        
    };
    
    char UnsoundPass::ID = 0;
    static RegisterPass<UnsoundPass> X("unsound-pass", "Detects Unsound calls", false, false);
}
