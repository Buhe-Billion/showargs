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

SYS_WRITE_CALL_VAL EQU 1
STDERR_FD          EQU 2
SYS_READ_CALL_VAL  EQU 0
STDIN_FD           EQU 0
STDOUT_FD          EQU 1
EXIT_SYSCALL       EQU 60
OK_RET_VAL         EQU 0
EOF_VAL						 EQU 0
EOL                EQU 10

SECTION .bss

MAXARGS            EQU 15             ;Maximum # of args we support <16: 15 + Invocation text>
ARGLENS:           RESQ MAXARGS       ;Table of argument lengths
