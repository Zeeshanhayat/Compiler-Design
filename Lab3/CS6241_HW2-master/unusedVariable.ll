; ModuleID = 'unusedVariable.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !12), !dbg !13
  store i32 6, i32* %i, align 4, !dbg !13
  call void @llvm.dbg.declare(metadata !{i32* %k}, metadata !14), !dbg !15
  store i32 8, i32* %k, align 4, !dbg !15
  call void @llvm.dbg.declare(metadata !{i32* %j}, metadata !16), !dbg !17
  %0 = load i32* %k, align 4, !dbg !17
  %add = add nsw i32 %0, 4, !dbg !17
  store i32 %add, i32* %j, align 4, !dbg !17
  %1 = load i32* %k, align 4, !dbg !18
  ret i32 %1, !dbg !18
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10}
!llvm.ident = !{!11}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.5.0 (trunk 203350)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !"", i32 1} ; [ DW_TAG_compile_unit ] [/home/bobby/llvm-home/build/lib/Transforms/HW2/unusedVariable.c] [DW_LANG_C99]
!1 = metadata !{metadata !"unusedVariable.c", metadata !"/home/bobby/llvm-home/build/lib/Transforms/HW2"}
!2 = metadata !{}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 1, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !2, i32 1} ; [ DW_TAG_subprogram ] [line 1] [def] [main]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/bobby/llvm-home/build/lib/Transforms/HW2/unusedVariable.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!10 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!11 = metadata !{metadata !"clang version 3.5.0 (trunk 203350)"}
!12 = metadata !{i32 786688, metadata !4, metadata !"i", metadata !5, i32 2, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 2]
!13 = metadata !{i32 2, i32 0, metadata !4, null}
!14 = metadata !{i32 786688, metadata !4, metadata !"k", metadata !5, i32 3, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [k] [line 3]
!15 = metadata !{i32 3, i32 0, metadata !4, null}
!16 = metadata !{i32 786688, metadata !4, metadata !"j", metadata !5, i32 4, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [j] [line 4]
!17 = metadata !{i32 4, i32 0, metadata !4, null}
!18 = metadata !{i32 5, i32 0, metadata !4, null}
