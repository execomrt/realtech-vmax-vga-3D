		COMMENT	$
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±	
		±	±
		±	ROTOZOOM.ASM ±
		±	±
		±	Routine graphique de rotozoom avec distortion sinusoidale±
		±	±
		±	Version 2.01 12/07/95 ±
		±	±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±	
		$	
;****************************************************************************;	
;	;
;	ÚÄÚÄ¿Ú ÚÄ  Ú¿ ³ ³  ÚÄ¿ÚÄÚÄ¿³ ÚÄ¿³ ³                      ;
;	³ ³ ³³³Ã   ÃÁ¿ÀÄ´  ÃÂÙÃ ÃÄÙ³ ÃÄ´ÀÄ´                      ;
;	ÀÄÀÄÙÀ ÀÄ  ÀÄÙÄÄÙ  ³ ³ÀÄ³  ÀÄ³ ³ÄÄÙ                      ;
;	;
;****************************************************************************;	
		EXTRN	`W?Ppage_texture$npna` :BYTE
		PUBLIC	`W?Rotozoom$n(ll)v`
		PUBLIC	`W?Maketab$n()v`
		_DATA	SEGMENT BYTE PUBLIC USE32 'DATA'
		sin		dw	0,6,13,19,25,31,38,44
		dw		50,56,62,68,74,80,86,92
		dw		98,104,109,115,121,126,132,137
		dw		142,147,152,157,162,167,172,177
		dw		181,185,190,194,198,202,206,209
		dw		213,216,220,223,226,229,231,234
		dw		237,239,241,243,245,247,248,250
		dw		251,252,253,254,255,255,256,256
		cos		dw	256,256,256,255,255,254,253,252
		dw		251,250,248,247,245,243,241,239
		dw		237,234,231,229,226,223,220,216
		dw		213,209,206,202,198,194,190,185
		dw		181,177,172,167,162,157,152,147
		dw		142,137,132,126,121,115,109,104
		dw		98,92,86,80,74,68,62,56
		dw		50,44,38,31,25,19,13,6
		dw		0,-6,-13,-19,-25,-31,-38,-44
		dw		-50,-56,-62,-68,-74,-80,-86,-92
		dw		-98,-104,-109,-115,-121,-126,-132,-137
		dw		-142,-147,-152,-157,-162,-167,-172,-177
		dw		-181,-185,-190,-194,-198,-202,-206,-209
		dw		-213,-216,-220,-223,-226,-229,-231,-234
		dw		-237,-239,-241,-243,-245,-247,-248,-250
		dw		-251,-252,-253,-254,-255,-255,-256,-256
		dw		-256,-256,-256,-255,-255,-254,-253,-252
		dw		-251,-250,-248,-247,-245,-243,-241,-239
		dw		-237,-234,-231,-229,-226,-223,-220,-216
		dw		-213,-209,-206,-202,-198,-194,-190,-185
		dw		-181,-177,-172,-167,-162,-157,-152,-147
		dw		-142,-137,-132,-126,-121,-115,-109,-104
		dw		-98,-92,-86,-80,-74,-68,-62,-56
		dw		-50,-44,-38,-31,-25,-19,-13,-6
		dw		0,6,13,19,25,31,38,44
		dw		50,56,62,68,74,80,86,92
		dw		98,104,109,115,121,126,132,137
		dw		142,147,152,157,162,167,172,177
		dw		181,185,190,194,198,202,206,209
		dw		213,216,220,223,226,229,231,234
		dw		237,239,241,243,245,247,248,250
		dw		251,252,253,254,255,255,256,256
		x1		dw	0
		y1		dw	0
		x2		dw	0
		y2		dw	0
		centrex		db	12h
		centrey		db	12h
		compteur		dd	0
		cpt		dd	0
		compt_bcl2		db	0
		tot_pasyy		dw	0
		tot_pasyx		dw	0
		taille_map		dd	65536*350/2
		zoom		dw	0
		sens		db	1
		angle		dd	256-16-64-32
		tab_sin		db	256 dup (0)
		db		256 dup (0)
_DATA	ENDS
		DGROUP	GROUP _DATA
		_TEXT	SEGMENT BYTE PUBLIC USE32 'CODE'
		ASSUME	CS:_TEXT,DS:DGROUP,SS:DGROUP
`W?ROTOZOOM$N(LL)V`:	
		pushad	
		db		0a3h
		dd		1+offset videobuf
		db		89h
		db		15h
		dd		2+offset pic1
		db		89h
		db		15h
		dd		2+offset pic2
		add	byte ptr [cpt],3
		MOV	esi,[angle]
		add	esi,esi
		MOV	ax,255 ;x1
		imul	word ptr [cos+esi]
		MOV	di,dx
		shl	edi,16 ;<=> push di mais plus rapide
		MOV	di,ax
		MOV	ax,0 ;y1
		imul	word ptr [sin+esi]
		shl	edx,16
		MOV	dx,ax
		sub	edi,edx
		sar	edi,8
		MOV	[x1],di
		MOV	ax,0 ;y1
		imul	word ptr [cos+esi]
		MOV	di,dx
		shl	edi,16
		MOV	di,ax
		MOV	ax,255 ;x1
		imul	word ptr [sin+esi]
		shl	edx,16
		MOV	dx,ax
		add	edi,edx
		sar	edi,8
		MOV	[y1],di
		MOV	ax,0 ;x2
		imul	word ptr [cos+esi]
		MOV	di,dx
		shl	edi,16 ;<=> push di mais plus rapide
		MOV	di,ax
		MOV	ax,255 ;y2
		imul	word ptr [sin+esi]
		shl	edx,16
		MOV	dx,ax
		sub	edi,edx
		sar	edi,8
		MOV	[x2],di
		MOV	ax,255 ;y2
		imul	word ptr [cos+esi]
		MOV	di,dx
		shl	edi,16
		MOV	di,ax
		MOV	ax,0 ;x2
		imul	word ptr [sin+esi]
		shl	edx,16
		MOV	dx,ax
		add	edi,edx
		sar	edi,8
		MOV	[y2],di
		MOV	ecx,taille_map
		MOVSX	edx,[x1]
		xor	eax,eax
		idiv	ecx
;	mov     word ptr [pasxx+1],ax
		db		66h
		db		0a3h
		dd		3+offset pasxx1
		db		66h
		db		0a3h
		dd		3+offset pasxx2
		shr	eax,16
		xor	ah,ah
;	mov     word ptr [pasxy+2],ax
		db		66h
		db		0a3h
		dd		1+offset pasxy
		MOVSX	edx,[y1]
		xor	eax,eax
		idiv	ecx
;	mov     word ptr [pasxy+2+2],ax
		db		66h
		db		0a3h
		dd		3+offset pasxy
		shr	eax,16
		MOV	byte ptr [1+intxx],al
		MOVSX	edx,[x2]
		xor	eax,eax
		idiv	ecx
		shr	eax,8
;	mov     word ptr [pasyx+2],ax
		db		66h
		db		0a3h
		dd		3+offset pasyx
		MOVSX	edx,[y2]
		xor	eax,eax
		idiv	ecx
		shr	eax,8
;	mov     word ptr [pasyy+1],ax
		db		66h
		db		0a3h
		dd		2+offset pasyy
		MOV	[compteur],200/2
		xor	di,di
		xor	al,al
		MOV	ah,[centrex]
		MOV	cl,ah
		MOV	[tot_pasyy],ax
		MOV	ah,[centrey]
		MOV	ch,ah
		MOV	[tot_pasyx],ax
		MOV	ebx,100
		add	bx,word ptr [cpt]
		MOV	bl,[tab_sin+ebx]
		MOV	ax,cx
		add	al,bl
		VIDEOBUF:	mov edi,12345678h
BCL1:	
		xor	edx,edx
		MOV	dl,al
		MOVZX	ebx,ax
		xor	si,si
		INTXX:	mov al,12h
		PASXY:	mov ebp,12345678h
		MOV	[compt_bcl2],80
BCL2:	
		PIC1:	mov cl,[12345678h+ebx] ;attrape le point
PASXX1:	add si,1234h
		adc	edx,ebp
		adc	bh,al
		MOV	ch,cl
		MOV	bl,dl
		rol	ecx,16
PASXX2:	add si,1234h
		PIC2:	mov cl,[12345678h+ebx] ;attrape le point
		adc	edx,ebp
		MOV	ch,cl
		adc	bh,al
		rol	ecx,16
		MOV	bl,dl
		MOV	[edi],ecx
		MOV	[320+edi],ecx
		add	edi,4
		dec	[compt_bcl2]
		jne	bcl2
		add	edi,320
		MOV	ax,[tot_pasyy]
PASYY:	add ax,1234h
		MOV	[tot_pasyy],ax
		MOV	bx,[tot_pasyx]
PASYX:	add bx,1234h
		MOV	[tot_pasyx],bx
		MOV	esi,[compteur]
		add	esi,[cpt]
		add	bh,[tab_sin+esi]
		MOV	al,bh
		dec	[compteur]
		jne	bcl1
		inc	byte ptr [angle]
		CMP	cs:[sens],0
		js	inverse
		inc	[centrex]
		inc	[centrey]
		sub	[taille_map],65536
		inc	[zoom]
		cmp	[zoom],110
		jne	next
		MOV	[zoom],0
		neg	[sens]
		jmp	short next
INVERSE:	
		dec	[centrex]
		dec	[centrey]
		add	[taille_map],65536
		inc	[zoom]
		cmp	[zoom],110
		jne	next
		MOV	[zoom],0
		neg	[sens]
NEXT:	
		popad	
		RET	
`W?MAKETAB$N()V`:	
		pushad	
		xor	esi,esi
		xor	edi,edi
MAKETAB_J1:	
		MOV	ax,150
		imul	word ptr [sin+esi]
		shl	edx,16
		MOV	dx,ax
		sar	edx,8
		MOV	[tab_sin+edi],dl
		MOV	[tab_sin+edi+256],dl
		inc	edi
		add	esi,2
		cmp	esi,256*2
		jne	maketab_j1
		popad	
		RET	
_TEXT	ENDS
		END	
