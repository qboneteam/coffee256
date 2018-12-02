	device zxspectrum128
	org	#6000
SnaStart:
	ei
	xor a
	out (#fe),a
	ld hl,#4000
	ld de,#4001
	ld bc,#1800
	ld (hl),l
	ldir
	ld (hl),#06
	ld b,#03
	ldir

;kruzhka:
	ld hl,#5a00+12
	ld de,#5a00+12+1
	ld c,7
	ld (hl),%00010010 ;#ff
	ldir
	ld l,b
	ld e,#00+32
	inc b
	ldir

	ld hl,#5a00+32+22
	ld d,b
	ld b,6
.l0:
	ld (hl),%00010010
	add hl,de
	djnz .l0

	ld hl,%0001001000010010
	ld (#5a00+32+21),hl
	ld (#5a00+32+21+32*5),hl

	ld hl,sintab
	ld de,sintab+32
	inc b
	ldir

ZaLoop
	halt
	halt
zlp00:
	ld a,#00
	inc a
	inc a
	and #07
	ld (zlp00+1),a
	or #40
	ld h,a
	ld d,a
	ld l,0
	ld e,1
	ld bc,256
	ldir
	dec h
	set 3,h
	ld d,h
	inc b
	ldir

	ld iy,sintab
	ld ix,#4000+16-4
	ld b,64
lup00:
smesch2:
	ld a,(iy+00)
mainsmesch:
	add a,(iy+0)

	ld c,a
	rlca
	rlca
	rlca
	and %00111000
	xor %00111000
	or  %11000110
	ld (ustanoffka+3),a
	ld a,c
	rrca
	rrca
	rrca
	and #0f
	ld (ustanoffka+2),a
ustanoffka:
	set 0,(ix+0)

	ld a,(mainsmesch+2)
	xor %00010000
;	xor %00000001
	ld (mainsmesch+2),a

	ld a,b
	and %00000111
	jr nz,us0
	ld a,(mainsmesch+2)
	inc a
	ld (mainsmesch+2),a
us0:
	bit 0,b
	jr nz,.l1
	inc iy
.l1

	push ix
	pop hl
	inc h
	inc h
	ld a,h
	and #07
	jr nz,.l0
	ld a,l
	sub -#20
	ld l,a
	sbc a,a
	and -#08
	add a,h
	ld h,a
.l0
	push hl
	pop ix

	djnz lup00

	ld a,(mainsmesch+2)
	sub 6
	and #1f
	ld (mainsmesch+2),a

	ld a,(smesch2+2)
	inc a
	and #1f
	ld (smesch2+2),a
	jp ZaLoop

sintab:
	incbin "sin32x32.bin"

	display "dlina = ",$-#6000
	savehob "CCup.$C","CCup.C",#6000,$-#6000
	savesna "coffeecup.sna",SnaStart