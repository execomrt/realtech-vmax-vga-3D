;/************************************************************************
; *
; *     File        : SPRITE_F.C
; *
; *     Description : Sprite functions
; *
; *     Copyright (C) 1995 RealTech
; *
; ************************************************************************/
#ifndef _TWEAK400
#define _TWEAK400
typedef struct {
    long int xmin,ymin,xmax,ymax;
    long BytesPerLine;
    long VRAM_Size;
    uchar *vid_ptr;
    ushort VideoMode;
    uchar Page;
    uchar Vbl;
    long Rap_Screen;
    uchar ByteSize;
    char filler0[3];
    ulong *RGBmask;
    char filler[27-3-4];
}Fenster;
#ifdef __cplusplus
extern "C" {
    #endif
    /* Asm */
    int cdecl VGAinit320400(void);
    int cdecl VGAinit320240(void);
    int cdecl VGAinit320200(void);
    int cdecl VGAinit360480(void);
    void cdecl clearGraphics(void);
    void cdecl putTWK400line(ulong lineNum,ulong xOff,ulong lineLen,void *buf);
    void cdecl BITBLT_tweaked(void);
    void cdecl setpage(ulong zpage);
    void cdecl showpage(ulong zpage);
    int cdecl isVga(void);
    void cdecl Init_Vga_Mode(long int m);
    /* Global */
    extern Fenster FENETRE,*fenster;
    #ifdef __cplusplus
}
#endif
#endif
