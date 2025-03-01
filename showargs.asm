;DESCRIPTION                : Demonstrating the way to access command line
;                           : arguments on the stack. This version accesses the stack "nondestructively"
;                           : by using memory references calculated from RBP rather than POP instructions.
;
;Architecture               : X86-64
;CPU                        : Intel® Core™2 Duo CPU T6570 @ 2.10GHz × 2
;NASM                       : 2.14.02
;

SECTION .data

ERRMSG DB "Terminated with error.",10
ERRLEN EQU $-ERRMSG

SECTION .bss
