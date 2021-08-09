;/************************************************************************
;*
;*	File        :   _GOURAUD.ASM
;*
;*	Description :   Gouraud shading
;*
;*	Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/


MACRO	Gouraud_GMinMax
		CGM_phase1
@@MINMAXVSIGN1:
		IDIV	ecx ;// Division
		autoMOV 1+@@MinNxt2
		;//mov	[Dxb],eax
		pop	edx
		mov	ebx,[N2]
		mov	ecx,[edi+ebx*4]
		mov	ebx,[N22]
		mov	eax,[edi+ebx*4]
		mov	ebx,ecx
		sub	eax,ecx
		sal	eax,16
		sal	ebx,16
		mov	[xvb],ebx
		mov	ecx,edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvxsigN1
		neg	ecx
		neg	eax
@@MINMAXVXSIGN1:
		IDIV	ecx ;// Division
		automov	1+@@MINMAX_FBOUC
		;//mov	[dcb],eax
		mov	ebx,[N12]
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N22]
		mov	ebx,[esi+ebx*8+4]
		mov	eax,[M_Y]
		JMP	@@MinMaxtest2
		CGM_phase2
@@MINMAXVSIGN2:
		IDIV	ecx ;// Division
		autoMOV 1+@@MinNxt1
		;//mov	[dxva],eax
		pop	edx
		mov	ebx,[N1]
		mov	ecx,[edi+ebx*4]
		mov	ebx,[N12]
		mov	eax,[edi+ebx*4]
		mov	ebx,ecx
		sub	eax,ecx
		sal	eax,16
		sal	ebx,16
		mov	[yva],ebx
		mov	ecx,edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvxsigN2
		neg	eax
		neg	ecx
@@MINMAXVXSIGN2:
		IDIV	ecx ;// Division
		autoMOV 1+@@MinNxt3
		;//mov	[dyva],eax
		mov	ebx,[N12]
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N22]
		mov	ebx,[esi+ebx*8+4]
		mov	eax,[M_Y]
		JMP	@@MinMaxremplit
ENDM

MACRO	Gouraud_Calc
		MinMax_readline
		PUSH	eax
		PUSH	ebx
		mov	eax,[xvb]
		sub	eax,[yva]
		JNS	short @@Gsigndiv1
		NEG	eax
		NEG	ecx
@@GSIGNDIV1:	XOR	edx,edx
		IDIV	ecx
		automov 1+@@Gdc
		pop	ecx
		pop	eax
		mov	ebx,[yva]
		cmp	eax,ecx
		JL	short @@GOUROverif
		XCHG	eax,ecx
		mov	ebx,[xvb]
@@GOUROVERIF:	mov	esi,[Y320]
		sub	ecx,eax
		add	eax,esi
		mov	edi,eax
		mov	eax,esi
		;//add	eax,[_FENETRE.xmin]
		automov 1+@@Gline0
		;//mov	[LDImin],eax
		mov	eax,esi
		add	eax,[_FENETRE.BytesPerLine]
@@Gdc:		mov	edx,12345678h
		mov	esi,eax ;//[LDImax]
		cmp	edi,esi
		JA	@@MinMax_fbouc
		sub	esi,ecx
		cmp	edi,esi
		JB	short @@GLine0
		add	ecx,esi
		sub	ecx,edi
		JS	@@MinMax_fbouc
		JZ	@@MinMax_fbouc
@@GLine0:	mov	esi,12345678h ;//[LDImin]
@@GLine: 	cmp	edi,esi
		JAE	short @@GLine2
		INC	edi
		add	ebx,edx
		dec	ecx
		jnz	short @@GLine
		jmp	@@MinMax_fbouc
ENDM
