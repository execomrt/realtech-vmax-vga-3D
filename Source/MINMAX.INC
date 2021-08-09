;/************************************************************************
;*
;*	File        :   MINMAX.INC
;*
;*	Description :   Construction Min/Max
;*
;*	Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
;===========================[             ]=================================

MACRO EnterMinMax
		ENTERPROC	_si _di
		mov	eax,[@@PARn]
		mov	[n],eax
		mov	eax,[@@PARsourcepts]
		autoMOV 1+@@src
		mov	eax,[@@PARpolypts]
		autoMOV 1+@@poly
		CLD
ENDM

;===========================[             ]=================================

MACRO	MinMaxVars

		Y320		dd	?
		XA		dd	?
		XB		dd	?
		M_Y		dd	?
		N1		dd	?
		N2		dd	?
		N12		dd	?
		N22		dd	?
		YVA		dd	?
		n		dd	?
ENDM

;===========================[             ]=================================

MACRO	Min_Max_Points
		mov 	esi,[@@PARpolypts]
		mov	ecx,7FFFFFFFh
		mov	edx,NOT 7FFFFFFFh
		xor	ebx,ebx
		mov	edi,[n]
		shl	edi,3
@@MINMAXBOUCLECOMP:
		mov	eax,[esi+ebx+4]
		cmp	eax,ecx
		JG	short @@MinMaxymaxi
		mov	[n1],ebx
		mov	ecx,eax
@@MINMAXYMAXI:	cmp	eax,edx
		JL	short @@MinMaxymini
		mov	edx,eax
@@MINMAXYMINI:	add	ebx,8
		cmp	ebx,edi
		JL	short @@MinMaxbouclecomp
		mov	eax,[n1]
		SHR	eax,3
		mov	[n1 ],eax
		mov	[n2 ],eax
		mov	[n12],eax
		mov	[n22],eax
		mov	[M_Y],ecx
		mov	eax,edx
		AUTOmov	1+@@MinMax_v2
		mov	eax,[_FENETRE.BytesPerLine]
		AUTOmov	1+@@MinNxt4
		push	ebx
		mov	ebx,eax
		mov	eax,ecx
		mul	ebx
		pop	ebx
		add	eax,[_FENETRE.vid_ptr]
		mov	[Y320],eax
ENDM

;===========================[             ]=================================

MACRO	MinMax_readline
@@poly:		mov 	esi,12345678h
@@src:		mov	edi,12345678h
		mov	eax,[M_Y]
		mov	ebx,[n22]
		cmp	eax,[esi+ebx*8+4]
		JE	@@MinMaxadpoint1
@@MINMAXTEST2:
		mov	ebx,[n12]
		cmp	eax,[esi+ebx*8+4]
		JE	@@MinMaxadpoint2
@@MINMAXREMPLIT:
		mov	ebx,[_FENETRE.ymax]
		cmp	eax,ebx
		JG	@@MinMaxfintotale
		mov	ebx,[_FENETRE.ymin]
		cmp	eax,ebx
		JL	@@MinMax_fbouc
		;//eax : 1er pts, ecx:2eme pts
		mov	eax,[xa]
		mov	ebx,[xb]

		SAR	eax,16
		SAL	eax,16-ROR_size

		SAR	ebx,16
		SAL	ebx,16-ROR_size

		mov	ecx,ebx
		sub	ecx,eax
		JZ	@@MinMax_fbouc
ENDM

;===========================[             ]=================================


MACRO	MinMax_NextLine
@@MinNxt1:	mov	eax,12345678h
@@MinNxt2:	mov	ebx,12345678h
@@MinNxt3:	mov	ecx,12345678h
@@MinNxt4:	mov	esi,12345678h
		ADD	[XA  ],eax
		ADD	[XB  ],ebx
		ADD	[YVA ],ecx
		ADD	[Y320],esi
		mov	eax,[M_Y]
		INC	eax
		mov	[M_Y],eax
@@MINMAX_V2:	cmp	eax,12345678h
ENDM

;===========================[             ]=================================

MACRO	CGM_phase1
@@MINMAXADPOINT1:
		mov	ebx,[N22]
		mov	[N2],ebx
		INC	ebx
		cmp	ebx,[n]
		JB	short @@MinMaxokN1
		xor	ebx,ebx
@@MINMAXOKN1:
		mov	[N22],ebx
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N2]
		mov	eax,[esi+ebx*8+4]
		sub	edx,eax
		AND	edx,edx
		JNZ	short @@MinMaxpashori
		xor	ecx,ecx
@@MINMAXENCORE1:
		mov	ebx,[N22]
		mov	[N2],ebx
		INC	ebx
		cmp	ebx,[n]
		JB	short @@MinMaxokN2
		xor	ebx,ebx
@@MINMAXOKN2:	mov	[N22],ebx
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N2]
		sub	edx,[esi+ebx*8+4]
		INC	ecx
		cmp	ecx,[n]
		JGE	@@MinMaxfintotale
		AND	edx,edx
		JZ	short @@MinMaxencore1

;===========================[             ]=================================

@@MINMAXPASHORI:
		mov	ebx,[N2]
		mov	ecx,[esi+ebx*8]
		mov	ebx,[N22]
		mov	eax,[esi+ebx*8]
		mov	ebx,ecx
		sub	eax,ecx
		sal	ebx,16
		sal	eax,16
		mov	[XB],ebx
		mov	ecx,edx
		PUSH	edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvsigN1
		NEG	ecx
		NEG	eax
ENDM

;===========================[             ]=================================

MACRO	CGM_phase2
@@MINMAXADPOINT2:
		mov	ebx,[N12]
		mov	[N1],ebx
		DEC	ebx
		AND	ebx,ebx
		JNS	short @@MinMaxokN12
		mov	ebx,[n]
		DEC	ebx
@@MINMAXOKN12:	mov	[N12],ebx
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N1]
		mov	eax,[esi+ebx*8+4]
		sub	edx,eax
		AND	edx,edx
		JNZ	short @@MinMaxpashori2
		xor	ecx,ecx
@@MINMAXENCORE2:
		mov	ebx,[N12]
		mov	[N1],ebx
		DEC	ebx
		AND	ebx,ebx
		JNS	short @@MinMaxokN22
		mov	ebx,[n]
		DEC	ebx
@@MINMAXOKN22:	mov	[N12],ebx
		mov	edx,[esi+ebx*8+4]
		mov	ebx,[N1]
		sub	edx,[esi+ebx*8+4]
		INC	ecx
		cmp	ecx,[n]
		JGE	@@MinMaxfintotale
		AND	edx,edx
		JZ	short @@MinMaxencore2
@@MINMAXPASHORI2:
		mov	ebx,[N1]
		mov	ecx,[esi+ebx*8]
		mov	ebx,[N12]
		mov	eax,[esi+ebx*8]
		mov	ebx,ecx
		sub	eax,ecx
		sal	ebx,16
		sal	eax,16
		mov	[XA],ebx
		mov	ecx,edx
		PUSH	edx
		XOR	edx,edx
		AND	eax,eax
		JNS	short @@MinMaxvsigN2
		NEG	eax
		NEG	ecx
ENDM
