;/************************************************************************
;*
;*	File        :   MAP.INC
;*
;*	Description :   Construction Mapping
;*
;*	Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
MACRO	SHADE_HIGH
		add	ah,[byte ptr @@offshade]
ENDM
MACRO	SHADE_LOW
		add	al,[byte ptr @@offshade]
ENDM
MACRO	Mapping_Init
		EnterMinMax
		mov	eax,[@@PARsource]
		mov	[source],eax
		Min_Max_Points
		xor	ebp,ebp
ENDM
;/***************************************************************
;*
;*
;* MACRO Mapping_Init
;*
;*/
MACRO	Mapping_End

@@me_1:		mov	eax,12345678h ;//[dxCAM]
@@me_2:		mov	ebx,12345678h ;//[dxvb]
@@me_3:		mov	ecx,12345678h ;//[dyvb]
		add	[xva],eax
		add	[xvb],ebx
		add	[yvb],ecx
		MinMax_NextLine
		JLE	@@MAPboucle_y
		LEAVEPROC	_si _di
ENDM
;/***************************************************************
;*
;*
;* MACRO Mapping_MiMax
;*
;*/
MACRO	Mapping_MiMax
		CGM_phase1
@@MINMAXVSIGN1:
		IDIV	ecx
		autoMOV 1+@@MinNxt2
		;//	mov	[dxb],eax
		pop	edx
		mov	ebx,[n2]
		mov	ecx,[edi+ebx*8]
		mov	ebx,[n22]
		mov	eax,[edi+ebx*8]
		mov	ebx,ecx
		SUB	eax,ecx
		SAL	ebx,16
		SAL	eax,16
		mov	[xvb],ebx
		mov	ecx,edx
		PUSH	edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvxsign1
		NEG	ecx
		NEG	eax
@@MINMAXVXSIGN1:
		IDIV	ecx
		autoMOV 1+@@me_2
		;// 	mov	[dxvb],eax
		pop	edx
		mov	ebx,[n2]
		mov	ecx,[edi+ebx*8+4]
		mov	ebx,[n22]
		mov	eax,[edi+ebx*8+4]
		mov	ebx,ecx
		SUB	eax,ecx
		SAL	ebx,16
		SAL	eax,16
		mov	[yvb],ebx
		mov	ecx,edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvysign1
		NEG	ecx
		NEG	eax
@@MINMAXVYSIGN1:
		IDIV	ecx
		autoMOV	1+@@me_3
		;//	mov	[dyvb],eax
		mov	ebx,[n12]
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[n22]
		mov	ebx,[esi+ebx*8+4]
		mov	eax,[M_Y]
		JMP	@@MinMaxtest2
		CGM_phase2
@@MINMAXVSIGN2:
		IDIV	ecx
		autoMOV 1+@@MinNxt1
		;//	mov	[dxva],eax
		pop	edx
		mov	ebx,[n1]
		mov	ecx,[edi+ebx*8]
		mov	ebx,[n12]
		mov	eax,[edi+ebx*8]
		mov	ebx,ecx
		SAL	ebx,16
		mov	[xva],ebx
		SUB	eax,ecx
		SAL	eax,16
		mov	ecx,edx
		PUSH	edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvxsign2
		NEG	eax
		NEG	ecx
@@MINMAXVXSIGN2:
		IDIV	ecx
		autoMOV	1+@@me_1
		;//	mov	[dxCAM],eax
		pop	edx
		mov	ebx,[n1]
		mov	ecx,[edi+ebx*8+4]
		mov	ebx,[n12]
		mov	eax,[edi+ebx*8+4]
		mov	ebx,ecx
		SAL	ebx,16
		mov	[yva],ebx
		SUB	eax,ecx
		SAL	eax,16
		mov	ecx,edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvysign2
		NEG	eax
		NEG	ecx
@@MINMAXVYSIGN2:
		IDIV	ecx
		autoMOV 1+@@MinNxt3
		;//	mov	[dyva],eax
		mov	ebx,[n12]
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[n22]
		mov	ebx,[esi+ebx*8+4]
		mov	eax,[M_Y]
		JMP	@@MinMaxremplit
@@MINMAXFINTOTALE:
		LEAVEPROC	_si _di
ENDM
;/***************************************************************
;*
;*
;* MACRO Mapping_Calcul
;*
;*/

MACRO	Mapping_Calcul
		MinMax_readline
		PUSH	eax ebx ecx
		MOV	eax,[xvb]
		SUB	eax,[xva]
		JNS	short @@MAPsigndiv1
		NEG	eax
		NEG	ecx
@@MAPSIGNDIV1:  ;//Pas DXV = xvb / taille
		xor	edx,edx
		idiv	ecx
@@TileMod0:	sar	eax,8
		mov	[dxv2],ax
		pop	ecx
		mov	eax,[yvb]
		SUB	eax,[yva]
		JNS	short @@MAPsigndiv2
		NEG	eax
		NEG	ecx
@@MAPSIGNDIV2:  ;// Pas DYV
		xor	edx,edx
		idiv	ecx
@@TileMod1:	sar	eax,8
		mov	[dyv2],ax
		pop	ecx eax
		mov	ebx,[xva]
		mov	edx,[yva]
		CMP	eax,ecx
		JL	short @@MAPverif
		XCHG	eax,ecx
		mov	ebx,[xvb]
		mov	edx,[yvb]
@@MAPVERIF:
		shr	ebx,8
		shr	edx,8
		mov	esi,[y320]
		sub	ecx,eax   ;//eax : 1er pts, ecx:2eme pts
		add	eax,esi
		mov	edi,eax
		mov	eax,esi
@@Maxou1:	;//add	eax,0;                      //12345678h ;//[_FENETRE.xmin]
		autoMov 1+@@Ma_ldimin
		mov	eax,esi
@@Maxou2:	add	eax,[_FENETRE.BytesPerLine]; //12345678h ;//[_FENETRE.xmax]
		autoMov 1+@@Ma_ldimax
ENDM
;/***************************************************************
;*
;*
;* MACRO Mapping_Range
;*                   ebp,edx,eax,edi,ecx
;*/
MACRO	Mapping_Range
		mov	bp,dx
		mov	edx,ebx
@@Ma_ldimin:	mov	ebx,12345678h
		CMP	edi, ebx
		JA	short @@MAPokgauche
		SUB	edi, ebx
		mov	ax,di
		NEG	ax
		add	ecx,edi
		JS	@@MAPfinbouc2
		PUSH	eax edx
		IMUL	[dxv2]
		pop	edx
		add	dx,ax
		pop	eax
		PUSH	edx
		IMUL	[dyv2]
		add	bp,ax
		pop	edx
		mov	edi,ebx
@@MAPOKGAUCHE:
@@Ma_ldimax:	mov	ebx,12345678h
		CMP	edi,ebx
		JA	@@MAPfinbouc2
		SUB	ebx,ecx
		CMP	edi,ebx
		JB	short @@MAPokdroite
		add	ecx,ebx
		SUB	ecx,edi
		JS	@@MAPfinbouc2
		JZ	@@MAPfinbouc2
ENDM
