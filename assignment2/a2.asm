.dseg
.org 0x200 
	array: .byte 100

; This stores the array in data memory
.cseg
	ldi ZL, low(array)
	ldi zh, high(array)

	;Make first row of table
	ldi r16, 1
	st z+, r16
	ldi r17, 1
	ldi r18, 10
	push r17
	call loop

	
	;second row of table
	ldi r16, 1
	st z+, r16
	st z+, r16
	ldi r17, 2
	call loop

	;3rd row of table
	ldi r16, 1
	st z+, r16
	ldi r16, 2
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 3
	call loop

	;4th row
	ldi r16, 1
	st z+, r16
	ldi r16, 3
	st z+, r16
	ldi r16, 3
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 4
	call loop

	;5th row
	ldi r16, 1
	st z+, r16
	ldi r16, 4
	st z+, r16
	ldi r16, 6
	st z+, r16
	ldi r16, 4
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 5
	call loop

	;6th row
	ldi r16, 1
	st z+, r16
	ldi r16, 5
	st z+, r16
	ldi r16, 10
	st z+, r16
	ldi r16, 10
	st z+, r16
	ldi r16, 5
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 6
	call loop

	;7th
	ldi r16, 1
	st z+, r16
	ldi r16, 6
	st z+, r16
	ldi r16, 15
	st z+, r16
	ldi r16, 20
	st z+, r16
	ldi r16, 15
	st z+, r16
	ldi r16, 6
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 7
	call loop

	;8
	ldi r16, 1
	st z+, r16
	ldi r16, 7
	st z+, r16
	ldi r16, 21
	st z+, r16
	ldi r16, 35
	st z+, r16
	ldi r16, 35
	st z+, r16
	ldi r16, 21
	st z+, r16
	ldi r16, 7
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 8
	call loop

	;9
	ldi r16, 1
	st z+, r16
	ldi r16, 8
	st z+, r16
	ldi r16, 28
	st z+, r16
	ldi r16, 56
	st z+, r16
	ldi r16, 70
	st z+, r16
	ldi r16, 56
	st z+, r16
	ldi r16, 28
	st z+, r16
	ldi r16, 8
	st z+, r16
	ldi r16, 1
	st z+, r16
	ldi r17, 9
	call loop

	;10
	ldi r16, 1
	st z+, r16
	ldi r16, 9
	st z+, r16
	ldi r16, 36
	st z+, r16
	ldi r16, 84
	st z+, r16
	ldi r16, 126
	st z+, r16
	ldi r16, 126
	st z+, r16
	ldi r16, 84
	st z+, r16
	ldi r16, 36
	st z+, r16
	ldi r16, 9
	st z+, r16
	ldi r16, 1
	st z+, r16

initialize:
	ldi r25, 0
	ldi r16, 0x87
	sts ADCSRA, r16
	ldi r16, 0x40
	sts ADMUX, r16

	ldi r21, 0xff
	sts ddrl, r21
	out ddrb, r21


	;pointer
	ldi xl, low(array)
	ldi xh, high(array)
	ld r20, x
	;for bound testing
	ldi yl, low(array)
	ldi yh, high(array)

	call display
	
main:

	call button_check   ; check to see if a button is pressed 	
	call delay
	rjmp main      ; Go back to main loop after a short delay


;.equ UP     = 0x0FA
;.equ DOWN   = 0x1C2
;.equ LEFT   = 0x28A
;.equ SELECT = 0x352

.equ RIGHT	= 0x032
.equ UP	    = 0x0FA
.equ DOWN	= 0x1C2
.equ LEFT	= 0x28A
.equ SELECT	= 0x352

button_check:
	; start a2d conversion
	lds	r16, ADCSRA	  ; get the current value of SDRA
	ori r16, 0x40     ; set the ADSC bit to 1 to initiate conversion
	sts	ADCSRA, r16

	; wait for A2D conversion to complete
wait:
	lds r16, ADCSRA
	andi r16, 0x40    ; see if conversion is over by checking ADSC bit
	brne wait          ; ADSC will be reset to 0 is finished

	; read the value available as 10 bits in ADCH:ADCL
	lds r16, ADCL
	lds r17, ADCH
	


	ldi r21, high(RIGHT)
	ldi r22, low(RIGHT)

	cp r16, r22
	cpc r17, r21
	brlo pointer_right

	ldi r21, high(UP)
	ldi r22, low(UP)

	cp r16, r22
	cpc r17, r21
	brlo pointer_up

	ldi r21, high(DOWN)
	ldi r22, low(DOWN)

	cp r16, r22
	cpc r17, r21
	brlo pointer_down

	ldi r21, high(LEFT)
	ldi r22, low(LEFT)

	cp r16, r22
	cpc r17, r21
	brlo pointer_left
	
	ldi r21, high(select)
	ldi r22, low(select)
		
	;reaching here means no button pressed
	;so return and do nothing
	call display
	ret

	
pointer_up:
	ldi r18, 10; low byte to subtract out of pointer to get new position
	ldi r19, 0 ; high byte
	sub xl, r18
	sbc xh, r19

	ld r20, x
	tst r20
	breq reverse_add ; points to invalid location so reverse the pointer operation

	;Ensure pointer is still within bounds of the array
	cp xl, yl
	cpc xh, yh
	brge finish ; if pointer is greater than or equal to the first position it is still within the array
	jmp reverse_add ; if pointer is less than first position operation must be reversed


pointer_right:
	ldi r18, 1
	ldi r19, 0
	add xl, r18
	adc xh, r19

	ld r20, x
	tst r20
	breq reverse_sub

	cp xl, zl
	cpc xh, zh
	brlo finish ; if less than n + 1 then index is still in bounds
	jmp reverse_sub



pointer_down:
	ldi r18, 10
	ldi r19, 0
	add xl, r18
	adc xh, r19

	ld r20, x
	tst r20
	breq reverse_sub

	cp xl, zl
	cpc xh, zh
	brlo finish ; if x < z
	jmp reverse_sub


pointer_left:
	ldi r18, 1
	ldi r19, 0
	sub xl, r18
	sbc xh, r19

	ld r20, x
	tst r20
	breq reverse_add

	cp xl, yl
	cpc xh, yh
	brge finish ; if pointer is greater than or equal to the first position it is still within the array
	jmp reverse_add

sub_reverse:
	sub xl, r18
	sbc xh, r19
	ld r20, x
	ret

add_reverse:
	add xl, r18
	adc xh, r19
	ld r20, x ;have to store old value into r20
	ret

reverse_add:
	call add_reverse
	jmp finish

reverse_sub:
	call sub_reverse
	jmp finish

finish:
	call display
	ret

loop:
	cp r17, r18
	breq fin
	ldi r16, 0
	st z+, r16
	inc r17
	jmp loop

fin:
	ret


; r20 will hold some binary number 0b0xxxxxxx
; r17 holds the value to turn the correct bits on for portl
; r16 is used to turn the proper bits of portb on
display:
	push r16
	push r17

	; clear to make sure no unexpected bits get added to portl or portb
	clr r16
	clr r17

	bst r20, 0
	bld r17, 7

	bst r20, 1
	bld r17, 5

	bst r20, 2
	bld r17, 3
	
	bst r20, 3
	bld r17, 1

	bst r20, 4
	bld r16, 3

	bst r20, 5
	bld r16, 1

	sts portl, r17
	out portb, r16

	pop r17
	pop r16
	ret

delay:
	push r21
	push r22
	push r20

	ldi r20, 0x3d
	x1:
		ldi r21, 0xF0
	x2:
			ldi r22, 0xF0
	x3:
				dec r22
				brne x3
			dec r21
			brne x2
		dec r20
		brne x1
		pop r20
		pop r22
		pop r21
		ret