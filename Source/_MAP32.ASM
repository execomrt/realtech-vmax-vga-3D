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
		ROR_size	EQU     14
                BIT_SIZE	EQU	4

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


		EXTRN	_realpalette:dword
		EXTRN	_glenzmode:dword
		EXTRN	_VESA_Selector:word
		EXTRN   _FENETRE:Fenster
ENDS
CCODESEG	TEXTURE_MAPPING_
		CPUBLIC	glenzMAPPING_32bit
		CPUBLIC	fillMAPPING_32bit
		CPUBLIC	spriteMAPPING_32bit
;/*------------------------------------------------------------------------
;*
;*	PROTOTYPE  : FILLMAPPING @@PARn,@@PARsourcepts,@@polypts,@@PARsource
;*
;*	DESCRIPTION : Texture Mapping 32bit
;*
;*/
CPROC	fillMAPPING_32bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource
		Mapping_Init;
		mov	eax,[source]
		AUTOmov	3+@@PAS_g

@@MAPBOUCLE_Y:
		Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,[dxv2]
		shl	si,2
		shl	ax,2
		AUTOmov16	2+@@PAS_18
		Mapping_Range
@@MAPOKDROITE:
		shr	ecx,2
		jz	short @@MAPFINBOUC2
		mov	eax,edx
@@MAP06:       	mov	ebx,ebp
		mov	bl,ah
@@PAS_G:      	mov	edx,[BIT_SIZE*ebx+12345678h]
@@PAS_18:     	add	ax,1234h
		add	bp,si

		mov	[dword ptr fsEDI],edx
		add	edi,BIT_SIZE
		dec	ecx
		jnz	short @@MAP06

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
CPROC	spriteMAPPING_32bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource
		Mapping_Init;
		mov	eax,[source]
		AUTOmov	3+@@PAS_g

@@MAPBOUCLE_Y:
		Mapping_Calcul
		mov	si,[dyv2]
		mov	ax,[dxv2]
		shl	si,BIT_SIZE/2     ;// Pas 32bit
		shl	ax,BIT_SIZE/2     ;// Pas 32bit
		AUTOmov16	2+@@PAS_18
		Mapping_Range


@@MAPOKDROITE:
		shr	ecx,BIT_SIZE/2
		jz	short @@MAPFINBOUC2
		mov	eax,edx
@@MAP06:       	mov	ebx,ebp
		mov	bl,ah
@@PAS_18:     	add	ax,1234h
		add	bp,si
@@PAS_G:      	mov	edx,[BIT_SIZE*ebx+12345678h]
		or	edx,edx
		jz	@@Skipy
		mov	[dword ptr fsEDI],edx
		add	edi,BIT_SIZE
		dec	ecx
		jnz	short @@MAP06

@@MAPFINBOUC2:
@@MINMAX_FBOUC:	MAPPING_END
@@Skipy:
		add	edi,BIT_SIZE
		dec	ecx
		jnz	@@MAP06
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


CPROC	glenzMAPPING_32bit @@PARn,@@PARsourcepts,@@PARpolypts,@@PARsource

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
		add	edi,BIT_SIZE
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

ENDS
END

























