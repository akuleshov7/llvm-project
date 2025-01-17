! Check the flang-omp-report plugin for omp-atomic.f90

! REQUIRES: plugins

! RUN: %flang_fc1 -load %llvmshlibdir/flangOmpReport.so -plugin flang-omp-report -fopenmp %s -o - | FileCheck %s

! Check OpenMP 2.13.6 atomic Construct

  a = 1.0
  !$omp parallel num_threads(4) shared(a)
  !$omp atomic seq_cst, read
  b = a

  !$omp atomic seq_cst write
  a = b
  !$omp end atomic

  !$omp atomic capture seq_cst
  b = a
  a = a + 1
  !$omp end atomic

  !$omp atomic
  a = a + 1
  !$omp end parallel
end

! CHECK:---
! CHECK-NEXT:- file:            '{{[^"]*}}omp-atomic.f90'
! CHECK-NEXT:  line:            11
! CHECK-NEXT:  construct:       atomic-read
! CHECK-NEXT:  clauses:
! CHECK-NEXT:    - clause:      seq_cst
! CHECK-NEXT:      details:     ''
! CHECK-NEXT:- file:            '{{[^"]*}}omp-atomic.f90'
! CHECK-NEXT:  line:            14
! CHECK-NEXT:  construct:       atomic-write
! CHECK-NEXT:  clauses:
! CHECK-NEXT:    - clause:      seq_cst
! CHECK-NEXT:      details:     ''
! CHECK-NEXT:- file:            '{{[^"]*}}omp-atomic.f90'
! CHECK-NEXT:  line:            18
! CHECK-NEXT:  construct:       atomic-capture
! CHECK-NEXT:  clauses:
! CHECK-NEXT:    - clause:      seq_cst
! CHECK-NEXT:      details:     ''
! CHECK-NEXT:- file:            '{{[^"]*}}omp-atomic.f90'
! CHECK-NEXT:  line:            23
! CHECK-NEXT:  construct:       atomic-atomic
! CHECK-NEXT:  clauses:         []
! CHECK-NEXT:- file:            '{{[^"]*}}omp-atomic.f90'
! CHECK-NEXT:  line:            10
! CHECK-NEXT:  construct:       parallel
! CHECK-NEXT:  clauses:
! CHECK-NEXT:    - clause:      num_threads
! CHECK-NEXT:      details:     '4'
! CHECK-NEXT:    - clause:      shared
! CHECK-NEXT:      details:     a
! CHECK-NEXT:...
