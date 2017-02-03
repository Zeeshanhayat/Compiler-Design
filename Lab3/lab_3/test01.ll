; ModuleID = 'test01.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define void @main() #0 {
  %a = alloca i32, align 4
  %c = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i32* %a}, metadata !11), !dbg !13
  store i32 5, i32* %a, align 4, !dbg !14
  call void @llvm.dbg.declare(metadata !{i32* %c}, metadata !15), !dbg !16
  store i32 1, i32* %c, align 4, !dbg !17
  %1 = load i32* %c, align 4, !dbg !18
  %2 = load i32* %a, align 4, !dbg !18
  %3 = icmp sgt i32 %1, %2, !dbg !18
  br i1 %3, label %4, label %8, !dbg !18

; <label>:4                                       ; preds = %0
  %5 = load i32* %c, align 4, !dbg !20
  %6 = load i32* %c, align 4, !dbg !20
  %7 = add nsw i32 %5, %6, !dbg !20
  store i32 %7, i32* %c, align 4, !dbg !20
  br label %12, !dbg !22

; <label>:8                                       ; preds = %0
  %9 = load i32* %c, align 4, !dbg !23
  %10 = load i32* %a, align 4, !dbg !23
  %11 = sub nsw i32 %9, %10, !dbg !23
  store i32 %11, i32* %a, align 4, !dbg !23
  br label %12

; <label>:12                                      ; preds = %8, %4
  store i32 0, i32* %c, align 4, !dbg !25
  ret void, !dbg !26
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9}
!llvm.ident = !{!10}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !"", i32 1} ; [ DW_TAG_compile_unit ] [/home/zeeshan/Desktop/Lab3/lab_3/test01.c] [DW_LANG_C99]
!1 = metadata !{metadata !"test01.c", metadata !"/home/zeeshan/Desktop/Lab3/lab_3"}
!2 = metadata !{}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 6, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @main, null, null, metadata !2, i32 7} ; [ DW_TAG_subprogram ] [line 6] [def] [scope 7] [main]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/zeeshan/Desktop/Lab3/lab_3/test01.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null}
!8 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!9 = metadata !{i32 2, metadata !"Debug Info Version", i32 1}
!10 = metadata !{metadata !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
!11 = metadata !{i32 786688, metadata !4, metadata !"a", metadata !5, i32 15, metadata !12, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 15]
!12 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!13 = metadata !{i32 15, i32 5, metadata !4, null}
!14 = metadata !{i32 15, i32 1, metadata !4, null}
!15 = metadata !{i32 786688, metadata !4, metadata !"c", metadata !5, i32 16, metadata !12, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c] [line 16]
!16 = metadata !{i32 16, i32 5, metadata !4, null}
!17 = metadata !{i32 16, i32 1, metadata !4, null}
!18 = metadata !{i32 17, i32 5, metadata !19, null}
!19 = metadata !{i32 786443, metadata !1, metadata !4, i32 17, i32 5, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/zeeshan/Desktop/Lab3/lab_3/test01.c]
!20 = metadata !{i32 19, i32 1, metadata !21, null}
!21 = metadata !{i32 786443, metadata !1, metadata !19, i32 18, i32 1, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/zeeshan/Desktop/Lab3/lab_3/test01.c]
!22 = metadata !{i32 20, i32 1, metadata !21, null}
!23 = metadata !{i32 23, i32 1, metadata !24, null}
!24 = metadata !{i32 786443, metadata !1, metadata !19, i32 22, i32 1, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/zeeshan/Desktop/Lab3/lab_3/test01.c]
!25 = metadata !{i32 26, i32 1, metadata !4, null}
!26 = metadata !{i32 27, i32 1, metadata !4, null}
