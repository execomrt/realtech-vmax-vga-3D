;/************************************************************************
;*
;*     File        :   PENTIUM.INC
;*
;*     Description :   Macros for Pentium
;*
;*     Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
;//	CMPXCHG8B       Compare and Exchange 8 Bytes EDX:EAX compared with mem64
//	if equal mem64 <- ECX:EBX else EDX:EAX<- mem64
MACRO	CMPXCHG8B reg,mem64
		db		00001111b,11000111b,reg,mem64
ENDM
MACRO	CPUID
		db		00001111b,10100010b
ENDM
;//	RDMSR           Read from Model-Specific Register (EECX copied to EDX:EAX)
MACRO	RDMSR
		db		00001111b,00110010b
ENDM
;//	RDTSC           Read from Time Stamp Counter (EDX:EAX)
MACRO	RDTSC
		db		00001111b,00110001b
ENDM
;//	RSM             Resume from System Management Mode
MACRO	RSM
		db		00001111b,10101010b
ENDM
;//WRMSR	Write to Model-Specific Register (EDX:EAX copied to EECX)
MACRO	WRMSR
		db		00001111b,00110000b
ENDM
