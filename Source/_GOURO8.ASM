;/************************************************************************
;*
;*      File        :   _GOURO8.ASM
;*
;*      Description :   Gouraud shading
;*
;*      Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
IDEAL
		INCLUDE 'model.inc'
		INCLUDE '_vga.inc'
		INCLUDE 'optimal.inc'
		INCLUDE 'minmax.inc'
		INCLUDE 'gouraud.inc'
CSEGMENTS       _GOURAUD

CDATASEG
		ALIGN   4
		MinMaxVars
		Xvb             dd      ?
		DC              dd      ?
		EXTRN   _realpalette : dword
		EXTRN   _VESA_Selector:word
		EXTRN   _glenzmode:DWORD
		EXTRN   _FENETRE:Fenster
		ROR_size	EQU     16
ENDS
CCODESEG        _GOURAUD
		CPUBLIC FILLGOURAUD_8bit
		CPUBLIC FILLGOURAUD_GLENZ_8bit
		CPUBLIC meshGOURAUD_8bit
;/*------------------------------------------------------------------------
;*
;*      PROTOTYPE  : FILLGOURAUD @@PARn,@@PARsourcepts,@@PARpolypts
;*
;*      DESCRIPTION :
;*
;*/
CPROC   fillGOURAUD_8bit @@PARn,@@PARsourcepts,@@PARpolypts
		EnterMinMax
		Min_Max_Points
@@GOUROBOUCLE_Y:
		Gouraud_Calc
@@GLine2:
		mov     esi,ecx
		mov     eax,ebx
		rol     eax,16
		rol     edx,16
@@GLine04:      test	edi,3h ;// BX peut etre reutilise
		jz  	short @@GLine05
		mov     [byte ptr fsEDI],al
		add     eax,edx
		adc     al,0
		inc     edi
		dec     esi
		jnz     short @@GLine04
@@GLine05:      mov	ebx,esi
		and	ebx,3
		shr     esi,2
		jz      short @@GLine32
@@GLine3:       mov     cl,al
		add     eax,edx
		adc     al,0
		mov     ch,al
		_bswap  ecx
		add     eax,edx
		adc     al,0
		mov     ch486,al
		add     eax,edx
		adc     al,0
		mov     cl486,al
		_bswap  ecx
		add     eax,edx
		adc     al,0
		mov     [fsEDI],ecx
		add     edi,4
		dec     esi
		jnz     short @@GLine3
@@GLine32:      or	ebx,ebx
		jz      short @@MinMax_fbouc
@@GLine4:       mov     [fsEDI],al
		add     eax,edx
		adc     al,0
		inc     edi
		dec     ebx
		jnz     short @@GLine4
@@MINMAX_FBOUC:
		mov     eax,12345678h
		add     [xvb],eax
		MinMax_NextLine
		jle     @@GOUROboucle_y
		LEAVEPROC       _si _di
		Gouraud_GMinMax
@@MINMAXFINTOTALE:
		LEAVEPROC       _si _di
ENDP
;/*------------------------------------------------------------------------
;*
;*      PROTOTYPE  : meshGOURAUD @@PARn,@@PARsourcepts,@@PARpolypts
;*      DESCRIPTION :
;*
;*/
CPROC   meshGOURAUD_8bit @@PARn,@@PARsourcepts,@@PARpolypts
		EnterMinMax
		Min_Max_Points
@@GOUROBOUCLE_Y:
		Gouraud_Calc
@@GLine2:
		mov     esi,ecx
		mov     eax,ebx
		rol     eax,16
		rol     edx,16
		shr	esi,1
		or	esi,esi
		jz      short @@MinMax_fbouc
@@GLine4:     	mov     [fsEDI],al
		add     eax,edx
		adc     al,0
		add     eax,edx
		adc     al,0
		add	edi,2
		dec     esi
		jnz     short @@GLine4
@@MINMAX_FBOUC:
		mov     eax,12345678h
		add     [xvb],eax
		MinMax_NextLine
		jle     @@GOUROboucle_y
		LEAVEPROC       _si _di
		Gouraud_GMinMax
@@MINMAXFINTOTALE:
		LEAVEPROC       _si _di
ENDP



MACRO GlenzRealCode
		test    edi,3
		jz      short @@GlenzReal4
		mov     al,dl
@@Modif30:	add     edx,12345678h
		adc 	dl,0
@@PASx_30:      mov     ebx,[12345678h+4*eax] ;// dans ebx : ptr de
		mov     al,[byte ptr fsEDI]
		mov     al,[byte ptr ebx+eax]
		mov     [fsEDI],al
		inc     edi
		dec     ebp
		jnz     short @@GLine5
		jmp	@@EndGlenz
	      ;/********************* Glenz Real Aligned ******************** */
@@GlenzReal4:
		push	ebp
		shr	ebp,2
		jz      @@GlenzRealLeft
@@GR_1:       ;/********************* Glenz Real ******************** */
		mov	ebx,[fsEDI] ;// Lit un DWORD dans le A-Buffer
		;// *****************************************
		mov     al,dl
@@Modif31:	add     edx,12345678h
		adc 	dl,0
@@PASx_31:      mov     esi,[12345678h+4*eax]
		mov     al,BL
		mov     al,[byte ptr esi+eax]
		mov     CL,al
		;// *****************************************
		mov     al,dl
@@Modif32:	add     edx,12345678h
		adc 	dl,0
@@PASx_32:      mov     esi,[12345678h+4*eax]
		mov     al,BH
		mov     al,[byte ptr esi+eax]
		mov     CH,al
		_bswap	ecx
		_bswap	ebx
		;// *****************************************
		mov     al,dl
@@Modif33:	add     edx,12345678h
		adc 	dl,0
@@PASx_33:      mov     esi,[12345678h+4*eax]
		mov     al,BH486
		mov     al,[byte ptr esi+eax]
		mov     CH486,al
		;// *****************************************
		mov     al,dl
@@Modif34:	add     edx,12345678h
		adc 	dl,0
@@PASx_34:      mov     esi,[12345678h+4*eax]
		mov     al,BL486
		mov     al,[byte ptr esi+eax]
		mov     CL486,al
		_bswap	ecx
		mov	[fsEDI],ecx
		add	edi,4
		dec	ebp
		jnz     short @@GR_1
@@GlenzRealLeft:
		pop	ebp
		and	ebp,3
		jz      short @@EndGlenz
@@GR_2:   ;/********************* Glenz Real ******************** */
		mov     al,dl
@@Modif35:	add     edx,12345678h
		adc 	dl,0
@@PASx_35:      mov     ebx,[12345678h+4*eax] ;// dans ebx : ptr de
		mov     al,[byte ptr fsEDI]
		mov     al,[byte ptr ebx+eax]
		mov     [fsEDI],al
		inc     edi
		dec     ebp
		jnz     short @@GR_2
		jmp	@@EndGlenz
@@EndGlenz:

ENDM


MACRO GlenzOther
		mov     al,[byte ptr _glenzmode]
		cmp     al,2
		je      short @@GLine5
		cmp     al,1
		je      short @@GLine4
@@GLine4:       ;/********************* Glenz SUB ********************* */
		mov     eax,edx
@@Modif2:	add     edx,12345678h
		adc	dl,0
		xor     ah,ah
		mov     bl,[byte ptr fsEDI]
		sub     ax,bx
		js      @@oksat2
		mov     [byte ptr fsEDI],al
		inc     edi
		dec     ebp
		jnz     short @@GLine4
		jmp     @@MinMax_fbouc
@@GLine3:       ;/********************* Glenz add       ********************** */
		mov     eax,edx
@@Modif1:	add     edx,12345678h
		adc	dl,0
		xor     ah,ah
		mov     bl,[byte ptr fsEDI]
		add     ax,bx
		or      ah,ah
		jnz     @@oksat
		mov     [byte ptr fsEDI],al
		inc     edi
		dec     ebp
		jnz     short @@GLine3
		jmp     @@MinMax_fbouc
ENDM
;/*------------------------------------------------------------------------
;*
;*      PROTOTYPE  : FILLGOURAUD_GLENZ @@PARn,@@PARsourcepts,@@PARpolypts
;*
;*      DESCRIPTION :
;*
;*/
CPROC   FILLGOURAUD_GLENZ_8bit @@PARn,@@PARsourcepts,@@PARpolypts
		EnterMinMax
		mov     eax,[_realpalette]
		AUTOmov 3+@@PASx_30
		AUTOmov 3+@@PASx_31
		AUTOmov 3+@@PASx_32
		AUTOmov 3+@@PASx_33
		AUTOmov 3+@@PASx_34
		AUTOmov 3+@@PASx_35

		Min_Max_Points
@@GOUROBOUCLE_Y:
		Gouraud_Calc
@@GLine2:
		mov	ebp,ecx
		mov	eax,edx
		mov     edx,ebx
		rol	eax,16
		rol	edx,16
		autoMov 2+@@Modif1
		autoMov 2+@@Modif2
		autoMov 2+@@Modif30
		autoMov 2+@@Modif31
		autoMov 2+@@Modif32
		autoMov 2+@@Modif33
		autoMov 2+@@Modif34
		autoMov 2+@@Modif35
		xor     ebx,ebx
		xor	eax,eax
		GlenzOther
@@GLine5:       ;/********************* Glenz Real ******************** */
		GlenzRealCode
@@MINMAX_FBOUC:
		mov     eax,12345678h
		add     [xvb],eax
		MinMax_NextLine
		JLe     @@GOUROboucle_y
		LEAVEPROC       _si _di
@@OKSAT:  	mov     [byte ptr fsEDI],255
		inc     edi
		dec     ebp
		jnz     @@GLine3
		jmp     @@MinMax_fbouc
@@OKSAT2:	mov     [byte ptr fsEDI],0
		inc     edi
		dec     ebp
		jnz     @@GLine4
		jmp     @@MinMax_fbouc
		Gouraud_GMinMax
@@MINMAXFINTOTALE:
		LEAVEPROC       _di _si
ENDP
ENDS
END
