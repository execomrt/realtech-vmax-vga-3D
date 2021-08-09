;/************************************************************************
;*
;*     File        :   OPTIMAL.INC
;*
;*     Description :   Macros for Optimised operations
;*
;*     Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
;
IFDEF CODE486
		cl486	= cl
		dl486	= dl
		ch486	= ch
		dh486	= dh
		AL_486  = ah
		AH_486  = al
		bh486   = bh
		bl486   = bl

ELSE
		cl486	= ch
		dl486	= dh
		ch486	= cl
		dh486	= dl
		AL_486  = al
		AH_486  = ah
		bh486   = bl
		bl486   = bh

ENDIF
MACRO   _BSWAP reg32
IFDEF   CODE486
		bswap   reg32
ELSE
		ror     reg32,10h
ENDIF
ENDM
;/*****************************************************************
;*                                                                *
;* new lodsb and movsb                                            *
;*                                                                *
;******************************************************************/
MACRO   LODSB_486
		mov     al,[byte ptr DSSI]
		inc     _SI
ENDM
MACRO   STOSB_486
		mov     [edi],al
		inc     _DI
ENDM
MACRO   STOSW_486
		mov     [edi],ax
		add     _DI,2h
ENDM
MACRO   STOSD_486
		mov     [edi],eax
		add     _DI,4h
ENDM
MACRO   BITBLT_STORE_ALIGNED
		local   ALIGNELOOP,ALREADYALIGNED,KASSTOI
ALIGNELOOP:     test    edi,3h
		jz      short ALREADYALIGNED
		stosb
		dec     ecx
		jg      short ALIGNELOOP
ALREADYALIGNED: or      ecx,ecx
		jz      short KASSTOI
		push    ecx
		shr     ecx,2h
		rep     stosd
		pop     ecx
		and     ecx,3
		rep     stosb
KASSTOI:
ENDM


MACRO   BITBLT_MOVE_ALIGNED
		local   ALIGNELOOP,ALREADYALIGNED
ALIGNELOOP:     test    edi,3h
		jz      short ALREADYALIGNED
		movsb
		dec     ecx
		jg      short ALIGNELOOP
ALREADYALIGNED: mov     eax,ecx
		and     eax,3
		shr     ecx,2h
		rep     movsd
		mov     ecx,eax
		rep     movsb
ENDM

MACRO   BITBLT_STORE_ALIGNED_2
		push	ecx
		shr	ecx,1
		rep     stosd
		pop	ecx
		and	ecx,1
		rep	stosw
ENDM


MACRO   BITBLT_MOVE_ALIGNED_2
		rep     movsw
ENDM

MACRO   BITBLT_STORE_ALIGNED_4
		rep     stosd
ENDM


MACRO   BITBLT_MOVE_ALIGNED_4
		rep     movsd
ENDM

;/*************************************************************************
;*
;* Macro Remplacement du LOOP
;*                     ; (386) ou (486) cycles
;**************************************************************************/
MACRO   LOOPECX labelx
		dec     ecx             ;// 2 ou 1
		jnz     short labelx    ;// 7+m ou 3 => 9+m ou 4 cycles
ENDM
;//*********************-Automodification code -*************************
MACRO   autoMOV labelx
		db              0A3h
		dd              labelx
ENDM
MACRO   autoMOV16 labelx
		db              066h,0A3h
		dd              labelx
ENDM
MACRO   autoMOV8 labelx
		db              066h,0A2h
		dd              labelx
ENDM

;//*********************-Division sans overflow 16.16 -*******************
;//*    Avoid 'Divide Overflow' error                                    *
;//***********************************************************************
MACRO   DIV1616 x,y
		xor     eax,eax
		shrd    eax,x,10h
		sar     x,10h
		idiv    y
ENDM
Macro div3216 reg16

  mov edx,eax
  sar edx,16
  idiv reg16
  and eax,000000ffh  ;// dx:ax divise par cx: quotient dans al, reste dans dx

ENDM
