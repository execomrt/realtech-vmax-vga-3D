;///************************************************************************
;//*
;//*     File        :   VGAREGS.INC
;//*
;//*     Description :   VGA Registers
;//*
;//*     Copyright (C) 1994,95 Realtech
;//*
;//***********************************************************************/

		SCREEN_SEG	EQU 0A0000h
		VERT_RETRACE	EQU 3DAh
		RASTER		EQU 3C0h
		PLANE		EQU 0102h
		SC_INDEX	EQU 3C4h 	;// Sequence Controller Index registere
		GC_INDEX	EQU 3CEh 	;// Graphics Controller Index register
		CRTC_INDEX	EQU 3D4h 	;// CRT Controller Index register
		MAP_MASK	EQU 2 	 	;// Map Mask register index in SC
		MEMORY_MODE	EQU 4 	 	;// Memory Mode register index in SC
		MAX_SCAN_LINE	EQU 9 	 	;// Maximum Scan Line reg index in CRTC
		UNDERLINE	EQU 14h 	;// Underline Location reg index in CRTC
		MODE_CONTROL	EQU 17h 	;// Mode Control register index in CRTC
		READ_MAP	EQU 4 		;// Read Map register index in GC
		GRAPHICS_MODE	EQU 5 		;// Graphics Mode register index in GC
		MISCELLANEOUS	EQU 6 		;// Miscellaneous register index in GC
		WORD_OUTS_OK	EQU 1 		;// Set to 0 for VGAs that can't handle
		MISC_OUTPUT	EQU 3C2h 	;// Miscellaneous Output register
		INPUT_STATUS_1	EQU 03DAh 	;// Input Status 1 register
		START_ADDR_HIGH	EQU 0Ch 	;// start address high byte
		START_ADDR_LOW	EQU 0Dh 	;// start address low byte
STRUC	Fenster
		xmin		dd	?
		ymin		dd	?
		xmax		dd	?
		ymax		dd	?
		BytesPerLine	dd	?
		VRAM_Size       dd      ?
		Vid_Ptr         dd      ?
		VideoMode       dw      ?
		Page            db      ?
		Vbl             db      ?
		Rap_Screen	dd	?
		ByteSize        db      ?
		filler1         db      27 dup (?)

ENDS
		fsEDI		EQU	fs:edi
MACRO	OUT_WORD
		if	WORD_OUTS_OK
		out	dx,ax
ELSE
		out	dx,al
		inc	dx
		xchg	ah,al
		out	dx,al
		dec	dx
		xchg	ah,al
ENDIF
ENDM
MACRO	CONSTANT_TO_INDEXED_REG ADDRESS, INDEX, VALUE
		mov	dx,ADDRESS
		mov	ax,(VALUE shl 8) + INDEX
		OUT_WORD
ENDM
MACRO	S320XY
		push	edx
		mov	edx,[_FENETRE.BytesPerLine]
		mul	edx
		add	ebx,eax
		pop	edx
ENDM
MACRO	OffScreenXY
		mov	edx,[_FENETRE.BytesPerLine]
		mul	edx
		add	ebx,eax
ENDM

MACRO	SET_VESA_ON
	       ;////	push	fs
		mov	ax,[_VESA_Selector]
		mov	fs,ax
ENDM
MACRO	SET_VESA_OFF
	       ;////	pop	fs
ENDM
MACRO	SET_ES_ON
		push	es
		push	ax
		mov	ax,[_VESA_Selector]
		mov	es,ax
		pop	ax
ENDM
MACRO	SET_ES_OFF
		pop	es
ENDM
MACRO	SET_DS_ON
		push	ds
		push	ax
		mov	ax,[_VESA_Selector]
		mov	ds,ax
		pop	ax
ENDM
MACRO	SET_DS_OFF
		pop	ds
ENDM
MACRO	SETBIT x
		mov	cl,x ;// get the plane # of the pixel
		mov	eax,PLANE
		shl	ah,cl ;// set the bit corresponding to plane
		mov	edx,SC_INDEX
		OUT_WORD
ENDM

MACRO	WaitVBL
		local	@@zsp3,@@zsp4,@@zsp5
		push	eax edx
		MOV	edx,VERT_RETRACE
@@ZSP3:
		in	al,dx
		test	al,8
		jne	short @@zsp3
@@ZSP4:
		in	al,dx
		test	al,8
		je	short @@zsp4
		pop 	edx eax
ENDM
MACRO	SETBIT x
		mov	cl,x ;//// get the plane # of the pixel
		mov	eax,PLANE
		shl	ah,cl ;//// set the bit corresponding to plane
		mov	edx,SC_INDEX
		OUT_WORD
ENDM
