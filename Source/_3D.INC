;/************************************************************************
;*
;*     File        :   _3D.INC
;*
;*     Description :   3D Interface
;*
;*     Copyright (C) 1994,95 Realtech
;*
;***********************************************************************/

STRUC Lpts3d
	x			dd      ?
	y			dd	?
	z			dd	?
ENDS

STRUC Spts3d
	x			dw      ?
	y			dw	?
	z			dw	?
ENDS

STRUC Light_Struct
	MAXSHADECOLOR		dd	?
	Ggamma			dd	?
	Gambient		dd	?
	MaxColor		dd	?
	Reflection		dd	?
	Reflection_Red		dd	?
	LightSource		Lpts3d  <?>
	rot_LightSource		Lpts3d  <?>
	Specular		dd	?
	SpecularTable		dd	?
	RGBvalue		dd	?
	filler			db	24	dup  (?)
ENDS

STRUC ObjetFace
	distance		dd      ?
	faceTab			dd      ?
	number			dd      ?
	map			dd      ?
	vector_norm		dd      ?
	render_face		dd      ?
	vect_norm_or		Lpts3d  <?>
	visible			Lpts3d  <?>
	temp			Spts3d  <?>
	mp			dd      ?
	sommets			dd      ?
	type			dd      ?
	shade			dd      ?
	disp			dd      ?
ENDS
STRUC Trackinfo
	angle			Lpts3d	<?>
	translate		Lpts3d	<?>
	filler			db	2	dup(?)
ENDS
STRUC Obj3d
	vertex			dd      ?
	face			dd	?
	render_funct		dd	?
	Tk			Trackinfo <?>
	Vertices		dw	?
	Faces			dw	?
	map_vertex		dd	?
	normal_edges2		dd	?
	MaxMaterial		dw	?
	MaterialName		dd	?
	MatCode			dd	?
	filler			db      6	dup(?)
ENDS
