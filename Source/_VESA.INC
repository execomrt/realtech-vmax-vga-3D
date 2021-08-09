;/************************************************************************	
;*
;*     File        :   _VESA.INC
;*
;*     Description :   VESA Interface
;*
;*     Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/

STRUC	VgaInfoBlock
		VESASignature		db	'VBE2' ; 4 signature bytes
		VESAVersion		dw	? ; VESA version number
		OEMStringPtr		dd	? ; Pointer to OEM string
		Capabilities		db	4 dup(?) ; capabilities of the video environment
		VideoModePtr		dd	? ; pointer to supported Super VGA modes
		Memory			dw	? ; Number of 64kb memory blocks on board
		OemSoftwareRev		dw	?
		OemVendorNamePtr	dd	?
		OemProductNamePtr	dd	?
		OemProductRevPtr	dd	?
		Reserved		db	222 dup(?) ; Remainder of VgaInfoBlock
		OemDATA			db	256 dup(?) ; Remainder of VgaInfoBlock
ENDS
STRUC	Vesamode
		ModeAttributes		dw	? ;//mode attributes
		WinAAttributes		db	? ;//window A attributes
		WinBAttributes		db	? ;//window B attributes
		WinGranularity		dw	? ;//window granularity
		WinSize			dw	? ;//window size
		WinASegment		dw	? ;//window A start segment
		WinBSegment		dw	? ;//window B start segment
		WinFuncPtr		dd	? ;//pointer to window function
		BytesPerLine		dw	? ;//bytes per scan line
		XResolution		dw	? ;//horizontal resolution
		YResolution		dw	? ;//vertical resolution
		XCharSize		db	? ;//character cell width
		YCharSize		db	? ;//character cell height
		NumberOfPlanes		db	? ;//number of memory planes
		BitsPerPixel		db	? ;//bits per pixel
		NumberOfBanks		db	? ;//number of banks
		MemoryModel		db	? ;//memory model type
		BankSize		db	? ;//bank size in kb
		NumberOfImagePages	db	? ;//number of images
		Reserved		db	1 ;//reserved for page function
		RedMaskSize		db	? ;//size of direct color red mask in bits
		RedFieldPosition	db	? ;//bit position of LSB of red mask
		GreenMaskSize		db	? ;//size of direct color green mask in bits
		GreenFieldPosition	db	? ;//bit position of LSB of green mask
		BlueMaskSize		db	? ;//size of direct color blue mask in bits
		BlueFieldPosition	db	? ;//bit position of LSB of blue mask
		RsvdMaskSize		db	? ;//size of direct color reserved mask in bits
		RsvdFieldPosition	db	? ;//size of direct color reserved mask in bits
		DirectColorModeInfo	db	? ;//Direct Color mode attributes
		PhyBasePtr		dd	?
		OffScreenMemOffset	dd	?
		OffScreenMemSize	dd	?
		Reserveds		db	206 dup(?) ; remainder of ModeInfoBlock
ENDS
MACRO	NEWBANK
		call	[bankadr]
ENDM
MACRO	BKADR func
		mov	[func],1
		mov	[bankadr],OFFSET _&func
ENDM
MACRO	NOJMP
		local	lbl
		jmp	short lbl
LBL:
ENDM
