;/************************************************************************
;*
;*	File        :   _MAP.ASM
;*
;*	Description :   Texture mapping
;*
;*	Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/
IDEAL
JUMPS
		INCLUDE	'model.inc'
		INCLUDE	'optimal.inc'
		INCLUDE	'_vga.inc'
		INCLUDE	'map.inc'
		INCLUDE	'minmax.inc'


		REALCOLOR	EQU	12345678h
		TEXTURE		EQU	12345678h
		PHONG		EQU	12345678h
		ROR_size	EQU     16

CSEGMENTS	TEXTURE_MAPPING_

CDATASEG
		ALIGN	4
		MinMaxVars
		OLDeax		dd	?
		XVA		dd	?
		XVB		dd	?
		YVB		dd	?
		source		dd	?
		XBP		dw	?
		DYV2		dw	?
		DXV2		dw	?
		XMINi2		dw	?

		copyrightText   DB      0Dh,"VECT LIB32 v2.10 - (C) 1993,1995 Realtech",0,1Ah
		EXTRN	_realpalette:dword
		EXTRN	_glenzmode:dword
		EXTRN	_VESA_Selector:word
		EXTRN   _mask_vidptr:dword
		EXTRN   _FENETRE:Fenster
ENDS
CCODESEG	TEXTURE_MAPPING_
		CPUBLIC	glenzMAPPING_8bit
		CPUBLIC	fillMAPPING_8bit
		CPUBLIC	spriteMAPPING_8bit
		CPUBLIC	doubleMAPPING_8bit
;/*------------------------------------------------------------------------
;*
;*	PROTOTYPE  : FILLMAPPING @@PARn,@@PARsourcepts,@@polypts,@@PARsource
;*
;*	DESCRIPTION : Texture Mapping Normal 256x256 (aligned / unrolled)
;*
;*/
CPROC	fillMAPPING_8bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource
		Mapping_Init;
		mov	eax,[source]
		AUTOmov	2+@@PAS_a
		AUTOmov	2+@@PAS_b
		AUTOmov	2+@@PAS_c
		AUTOmov	2+@@PAS_d
		AUTOmov	2+@@PAS_e
		AUTOmov	2+@@PAS_f
@@MAPBOUCLE_Y:
		Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,[dxv2]
		AUTOmov16	2+@@PAS_11
		AUTOmov16	2+@@PAS_12
		AUTOmov16	2+@@PAS_13
		AUTOmov16	2+@@PAS_14
		AUTOmov16	2+@@PAS_15
		AUTOmov16	2+@@PAS_16
		Mapping_Range


@@MAPOKDROITE:
;//******************************* ALIGN EDI *****************************
		mov	eax,edx
@@MAP04:	test	edi,3h
		jz	@@MAPligne0
		mov	ebx,ebp
		mov	bl,ah
@@PAS_E:      	mov	dl,[ebx+TEXTURE]
		mov	[byte ptr fsEDI],dl
@@PAS_16:     	add	ax,1234h
		add	bp,si
		inc	edi
		dec	ecx
		jnz	short @@MAP04
;//**************************** ALIGNED **********************************
@@MAPLIGNE0:	push	ecx
		shr	ecx,2
		jz	short @@MAPfinbouc21
@@MAPLIGNE: 	mov	ebx,ebp
		mov	bl,ah
@@PAS_A:    	mov	dl,[TEXTURE+ebx]
@@PAS_11:   	add	ax,1234h
		add	bp,si
		mov	ebx,ebp
		mov	bl,ah
@@PAS_B:    	mov	dh,[TEXTURE+ebx]
@@PAS_12:   	add	ax,1234h
		add	bp,si
		_bswap	edx
		mov	ebx,ebp
		mov	bl,ah
@@PAS_C:	mov	dh486,[TEXTURE+ebx]
@@PAS_13:   	add	ax,1234h
		add	bp,si
		mov	ebx,ebp
		mov	bl,ah
@@PAS_D: 	mov	dl486,[TEXTURE+ebx]
@@PAS_14:	add	ax,1234h
		add	bp,si
		_bswap	edx
		mov	[dword ptr fsEDI],edx
		add	edi,4h
		dec	ecx
		jnz	@@MAPligne
;// *************************** END ALIGNEMENT *************************
@@MAPFINBOUC21:	pop	ecx
		and	ecx,3
		jz	short @@MAPfinbouc2
@@MAPLIGNECX2: 	mov	ebx,ebp
		mov	bl,ah
@@PAS_F:    	mov	dl,[ebx+TEXTURE]
		mov	[byte ptr fsEDI],dl
@@PAS_15:   	add	ax,1234h
		add	bp,si
		inc	edi
		dec	ecx
		jnz	short @@MAPligneCX2
@@MAPFINBOUC2:
@@MINMAX_FBOUC:	MAPPING_END
		Mapping_MiMax
ENDP
;/*------------------------------------------------------------------------
;*
;*	PROTOTYPE  : spriteMAPPING @@PARn,@@PARsourcepts,@@polypts,@@PARsource
;*
;*	DESCRIPTION : Mapping 'sprit‚' 256x256
;*
;*/
CPROC	spriteMAPPING_8bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource
		Mapping_Init;
		mov	eax,[source]
		AUTOmov	2+@@PAS_f
@@MAPBOUCLE_Y: 	Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,[dxv2]
		AUTOmov16	2+@@PAS_15
		Mapping_Range
@@MAPOKDROITE: 	mov	eax,edx
		or	ecx,ecx
		jz	@@MAPfinbouc2
@@MAPLIGNECX2: 	mov	ebx,ebp
		mov	bl,ah
@@PAS_F:    	mov	dl,[ebx+TEXTURE]
@@PAS_15:   	add	ax,1234h
		add	bp,si
		or	dl,dl
		jz	@@Skippy
		mov	[fsEDI],dl
		inc	edi
		dec	ecx
		jnz	short @@MAPligneCX2
@@MAPFINBOUC2:
@@MINMAX_FBOUC:	MAPPING_END
@@SKIPPY:	inc	edi
		dec	ecx
		jnz	@@MAPligneCX2
		jmp	@@MAPFINBOUC2
		Mapping_MiMax
ENDP
;/*------------------------------------------------------------------------
;*
;*	PROTOTYPE  : spriteMAPPING @@PARn,@@PARsourcepts,@@polypts,@@PARsource
;*
;*	DESCRIPTION : Mapping 'sprit‚' 256x256
;*
;*/


CPROC	glenzMAPPING_8bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource

		Mapping_Init;
		mov	eax,[_realpalette]
		AUTOmov 3+@@rea_0
		AUTOmov 3+@@rea_1
		AUTOmov 3+@@rea_2
		AUTOmov 3+@@rea_3
		AUTOmov 3+@@rea_4
		AUTOmov 3+@@rea_5
		mov	eax,[source]
		AUTOmov	2+@@map_0
		AUTOmov	2+@@map_1
		AUTOmov	2+@@map_2
		AUTOmov	2+@@map_3
		AUTOmov	2+@@map_4
		AUTOmov	2+@@map_5
@@MAPBOUCLE_Y: 	Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,si
		AUTOmov16	3+@@pay_0
		AUTOmov16	3+@@pay_1
		AUTOmov16	3+@@pay_2
		AUTOmov16	3+@@pay_3
		AUTOmov16	3+@@pay_4
		AUTOmov16	3+@@pay_5
		mov	ax,[dxv2]
		AUTOmov16	2+@@pax_0
		AUTOmov16	2+@@pax_1
		AUTOmov16	2+@@pax_2
		AUTOmov16	2+@@pax_3
		AUTOmov16	2+@@pax_4
		AUTOmov16	2+@@pax_5
		Mapping_Range
@@MAPOKDROITE: 	mov	eax,edx
		mov	esi,ecx
		xor	ecx,ecx
		or	esi,esi
		jz	@@MAPfinbouc2
@@MAPLIGNECX2:
		test    edi,3h
		jz      @@MapAligned

		mov	ebx,ebp
		mov	bl,ah
@@map_0:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_0:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI]  ;// lit l'ecran            :ecx
		mov     DL,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_0:   	add	ax,1234h
@@pay_0:	add	bp,1234h
		mov	[fsEDI],DL
		inc	edi
		dec	esi
		jnz	short @@MAPligneCX2
;==========================================================================
@@MapAligned:   push	esi
		shr	esi,2
		jz      @@MapEndAligned
@@Mp4:
		mov	ebx,ebp
		mov	bl,ah
@@map_1:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_1:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI]  ;// lit l'ecran            :ecx
		mov     DL,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_1:   	add	ax,1234h
@@pay_1:	add	bp,1234h

		mov	ebx,ebp
		mov	bl,ah
@@map_2:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_2:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI+1]  ;// lit l'ecran            :ecx
		mov     DH,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_2:   	add	ax,1234h
@@pay_2:	add	bp,1234h

		_bswap	EDX

		mov	ebx,ebp
		mov	bl,ah
@@map_3:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_3:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI+2]  ;// lit l'ecran            :ecx
		mov     DH486,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_3:   	add	ax,1234h
@@pay_3:	add	bp,1234h

		mov	ebx,ebp
		mov	bl,ah
@@map_4:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_4:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI+3]  ;// lit l'ecran            :ecx
		mov     DL486,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_4:   	add	ax,1234h
@@pay_4:	add	bp,1234h

		_bswap	EDX
		mov	[fsEDI],EDX
		add	edi,4
		dec	esi
		jnz	@@MP4
;==========================================================================
@@MapEndAligned:
		pop	esi
		and	esi,3
		jz      short @@MAPFINBOUC2
@@Mp5:
		mov	ebx,ebp
		mov	bl,ah
@@map_5:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_5:        mov     ebx,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
		mov     CL,[byte ptr fsEDI]  ;// lit l'ecran            :ecx
		mov     DL,[byte ptr ebx+ecx] ;// calcul le reacolor dans:dl
@@pax_5:   	add	ax,1234h
@@pay_5:	add	bp,1234h

		mov	[fsEDI],DL
		inc	edi
		dec	esi
		jnz	short @@Mp5

@@MAPFINBOUC2:
@@MINMAX_FBOUC:	MAPPING_END
		Mapping_MiMax
ENDP

;/*------------------------------------------------------------------------
;*
;*	PROTOTYPE  : doubleMAPPING @@PARn,@@PARsourcepts,@@polypts,@@PARsource
;*
;*	DESCRIPTION : Mapping 'sprit‚' 256x256
;*
;*/


CPROC	doubleMAPPING_8bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource

		Mapping_Init;
		mov	eax,[_realpalette]
		AUTOmov 3+@@rea_0
		AUTOmov 3+@@rea_1
		AUTOmov 3+@@rea_2
		AUTOmov 3+@@rea_3
		AUTOmov 3+@@rea_4
		AUTOmov 3+@@rea_5
		mov	eax,[source]
		AUTOmov	2+@@map_0
		AUTOmov	2+@@map_1
		AUTOmov	2+@@map_2
		AUTOmov	2+@@map_3
		AUTOmov	2+@@map_4
		AUTOmov	2+@@map_5
		mov	eax,[_mask_vidptr]
		AUTOmov	2+@@pho_0
		AUTOmov	2+@@pho_1
		AUTOmov	2+@@pho_2
		AUTOmov	2+@@pho_3
		AUTOmov	2+@@pho_4
		AUTOmov	2+@@pho_5

@@MAPBOUCLE_Y: 	Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,si
		AUTOmov16	3+@@pay_0
		AUTOmov16	3+@@pay_1
		AUTOmov16	3+@@pay_2
		AUTOmov16	3+@@pay_3
		AUTOmov16	3+@@pay_4
		AUTOmov16	3+@@pay_5
		mov	ax,[dxv2]
		AUTOmov16	2+@@pax_0
		AUTOmov16	2+@@pax_1
		AUTOmov16	2+@@pax_2
		AUTOmov16	2+@@pax_3
		AUTOmov16	2+@@pax_4
		AUTOmov16	2+@@pax_5
		Mapping_Range
@@MAPOKDROITE: 	mov	eax,edx
		mov	esi,ecx
		xor	ecx,ecx
		or	esi,esi
		jz	@@MAPfinbouc2
@@MAPLIGNECX2:
		test    edi,3h
		jz      @@MapAligned
		push 	esi
		mov	ebx,ebp
		mov	bl,ah
@@map_0:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_0:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_0:	mov     CL,[ebx+PHONG]
		mov     DL,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_0:   	add	ax,1234h
@@pay_0:	add	bp,1234h
		mov	[fsEDI],DL
		inc	edi
		pop	esi
		dec	esi
		jnz	short @@MAPligneCX2
;==========================================================================
@@MapAligned:   push	esi
		shr	esi,2
		jz      @@MapEndAligned
@@Mp4:
		push	esi
		mov	ebx,ebp
		mov	bl,ah
@@map_1:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_1:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_1:	mov     CL,[ebx+PHONG];// lit l'ecran            :ecx
		mov     DL,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_1:   	add	ax,1234h
@@pay_1:	add	bp,1234h

		mov	ebx,ebp
		mov	bl,ah
@@map_2:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_2:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_2:	mov     CL,[ebx+PHONG] ;// lit l'ecran            :ecx
		mov     DH,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_2:   	add	ax,1234h
@@pay_2:	add	bp,1234h

		_bswap	EDX

		mov	ebx,ebp
		mov	bl,ah
@@map_3:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_3:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_3:	mov     CL,[ebx+PHONG]  ;// lit l'ecran            :ecx
		mov     DH486,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_3:   	add	ax,1234h
@@pay_3:	add	bp,1234h

		mov	ebx,ebp
		mov	bl,ah
@@map_4:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_4:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_4:	mov     CL,[ebx+PHONG];// lit l'ecran            :ecx
		mov     DL486,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_4:   	add	ax,1234h
@@pay_4:	add	bp,1234h

		_bswap	EDX
		mov	[fsEDI],EDX
		add	edi,4
		pop	esi
		dec	esi
		jnz	@@MP4
;==========================================================================
@@MapEndAligned:
		pop	esi
		and	esi,3
		jz      short @@MAPFINBOUC2
@@Mp5:
		push	esi
		mov	ebx,ebp
		mov	bl,ah
@@map_5:    	mov	cl,[ebx+TEXTURE]    ;// lit le pts dans la map :cl
@@rea_5:        mov     esi,[REALCOLOR+4*ecx] ;// lit le realcolor 'map' :ebx
@@pho_5:	mov     CL,[ebx+PHONG];// lit l'ecran            :ecx
		mov     DL,[byte ptr esi+ecx] ;// calcul le reacolor dans:dl
@@pax_5:   	add	ax,1234h
@@pay_5:	add	bp,1234h
		mov	[fsEDI],DL
		inc	edi
		pop	esi
		dec	esi
		jnz	short @@Mp5

@@MAPFINBOUC2:
@@MINMAX_FBOUC:	MAPPING_END
		Mapping_MiMax
ENDP


ENDS
END

























