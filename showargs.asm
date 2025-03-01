;DESCRIPTION                : Demonstrating the way to access command line
;                           : arguments on the stack. This version accesses the stack "nondestructively"
;                           : by using memory references calculated from RBP rather than POP instructions.
;
;Architecture               : X86-64
;CPU                        : Intel® Core™2 Duo CPU T6570 @ 2.10GHz × 2
;NASM                       : 2.14.02
;
;
;------------------------------------------------------------------------------------------------------------------

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

;------------------------------------------------------------------------------------------------------------------

SECTION .bss

MAXARGS            EQU 15             ;Maximum # of args we support <16: 15 + Invocation text>
ARGLENS:           RESQ MAXARGS       ;Table of argument lengths

;------------------------------------------------------------------------------------------------------------------

SECTION .text

GLOBAL _start

_start:

PUSH RBP                    ;Alignment prolog
MOV RBP,RSP                 ;
AND RSP,-16                 ;Forces the lower four bits of the stack to 0.Therefore aligning to a 16-byte boundary

; Copy the command line argument count from the stack and validate it:

MOV R13,[RBP+8]         ;Skip over pushed RBP and access argument count from the stack
CMP QWORD R13,MAXARGS   ;Do we have too many arguments?
JA ERROR                ;If so, exit wiht an error msg

; Here we calculate argument lengths and store lengths in table ARGLENS

MOV RBX,1               ; Stack address offset starts at RBX*8 - R GPs are 8 bytes long <64 bits>

SCANONE:
XOR RAX,RAX            ;Clear AL, because we're looking for 0
MOV RCX,0000FFh        ;Limit search to 65535 bytes max
MOV RDI,[RBP+8+RBX*8]  ;Put address of string to search in RDI
MOV RDX,RDI            ;Put address of string to search in RDI

CLD
REPNE SCASB
JNZ NEAR ERROR

MOV BYTE [RDI-1],EOL
SUB RDI,RDX
MOV [ARGLENS+RBX*8],RDI
INC RBX
CMP RBX,R13
JBE SCANONE

; Display all arguments to stdout:

MOV RBX,1

SHOW:
MOV RAX,SYS_WRITE_CALL_VAL
MOV RDI,STDOUT_FD
MOV RSI,[RBP+8+RBX*8]
MOV RDX,[ARGLENS+RBX*8]
SYSCALL

INC RBX
CMP RBX,R13
JBE SHOW
JMP EXIT

ERROR:
MOV RAX,SYS_WRITE_CALL_VAL
MOV RDI,STDOUT_FD
MOV RSI,ERRMSG
MOV RDX,ERRLEN
SYSCALL

EXIT:
MOV RSP,RBP                 ;Epilogue
POP RBP

MOV RAX,EXIT_SYSCALL
MOV RDI,OK_RET_VAL
SYSCALL 
