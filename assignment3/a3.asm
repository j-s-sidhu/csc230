;;
; AssemblerApplication1.asm
;
; Created: 11/15/2019 9:27:39 AM
; Author : justicesidhu

;
.org 0x0000
	rjmp intro



.org 0x0028
	jmp timer1_ISR


	

timer1_ISR:
; dont push r10, 11 12 because value needs to remain changed
	push r16
	lds r16, sreg
	push r16

	push r10
	push r11
	push r12
	call next_value
	pop r12
	pop r11
	pop r10

	call three_byte_to_string
	call two_byte_to_string
	call update_bottom
	call timer_speed_change

	pop r16
	sts sreg, r16
	pop r16
	reti

.cseg
intro:

	ldi zl, low(name)
	ldi zh, high(name)

	ldi r16, 'J'
	st z+, r16
	ldi r16, 'u'
	st z+, r16
	ldi r16, 's'
	st z+, r16
	ldi r16, 't'
	st z+, r16
	ldi r16, 'i'
	st z+, r16
	ldi r16, 'c'
	st z+, r16
	ldi r16, 'e'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, 'S'
	st z+, r16
	ldi r16, 'i'
	st z+, r16
	ldi r16, 'd'
	st z+, r16
	ldi r16, 'h'
	st z+, r16
	ldi r16, 'u'
	st z+, r16
	clr r16
	st z+, r16

	ldi zl, low(course_year)
	ldi zh, high(course_year)

	ldi r16, 'C'
	st z+, r16
	ldi r16, 'S'
	st z+, r16
	ldi r16, 'C'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, '2'
	st z+, r16
	ldi r16, '3'
	st z+, r16
	ldi r16, '0'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, 'F'
	st z+, r16
	ldi r16, 'a'
	st z+, r16
	ldi r16, 'l'
	st z+, r16
	ldi r16, 'l'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, '1'
	st z+, r16
	ldi r16, '9'
	st z+, r16
	clr r16
	st z+, r16

	call lcd_init
	call lcd_clr

	ldi r16, 0
	push r16
	ldi r16, 0
	push r16

	call lcd_gotoxy

	pop r16
	pop r16

	ldi r16, high(name)
	push r16
	ldi r16, low(name)
	push r16

	call lcd_puts
	pop r16
	pop r16

	ldi r16, 1
	push r16
	ldi r16, 0
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	ldi r16, high(course_year)
	push r16
	ldi r16, low(course_year)
	push r16
	call lcd_puts
	pop r16
	pop r16

	call delay2

display_setup:

	ldi zl, low(top_row)
	ldi zh, high(top_row)

	ldi r16, ' '
	st z+, r16
	ldi r16, 'n'
	st z+, r16
	ldi r16, '='
	st z+, r16
	ldi r16, '0'
	st z+, r16
	ldi r16, '0'
	st z+, r16
	ldi r16, '0'
	st z+, r16
	ldi r16, '*'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, 'S'
	st z+, r16
	ldi r16, 'P'
	st z+, r16
	ldi r16, 'D'
	st z+, r16
	ldi r16, ':'
	st z+, r16
	ldi r16, '0'
	st z+, r16
	clr r16
	st z+, r16

	ldi zl, low(bot_row)
	ldi zh, high(bot_row)

	ldi r16, 'c'
	st z+, r16
	ldi r16, 'n'
	st z+, r16
	ldi r16, 't'
	st z+, r16
	ldi r16, ':'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, '0'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, 'v'
	st z+, r16
	ldi r16, ':'
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, ' '
	st z+, r16
	ldi r16, '0'
	st z+, r16
	clr r16
	st z+, r16

	call lcd_clr

	ldi r16, 0
	push r16
	push r16
	call lcd_gotoxy
	pop r16
	pop r16
	ldi r16, high(top_row)
	push r16
	ldi r16, low(top_row)
	push r16
	call lcd_puts
	pop r16
	pop r16

	ldi r16, 1
	push r16
	ldi r16, 0
	push r16
	call lcd_gotoxy
	pop r16
	pop r16
	ldi r16, high(bot_row)
	push r16
	ldi r16, low(bot_row)
	push r16
	call lcd_puts
	pop r16
	pop r16

	;initialize adc converter
	ldi r16, 0x87
	sts ADCSRA, r16
	ldi r16, 0x40
	sts ADMUX, r16


; button check taken and modified from course folder
;.equ UP	    = 0x0C3
;.equ DOWN	= 0x17C
;.equ LEFT	= 0x22B
;.equ SELECT	= 0x316
.equ RIGHT	= 0x032
.equ UP     = 0x0FA
.equ DOWN   = 0x1C2
.equ LEFT   = 0x28A
.equ SELECT = 0x352




.equ TIMER1_ticks1 = 977
.equ timer1_ticks2 = 1953
.equ timer1_ticks3 = 3906
.equ timer1_ticks4 = 7812
.equ timer1_ticks5 = 15625
.equ timer1_ticks6 = 23438
.equ timer1_ticks7 = 31250
.equ timer1_ticks8 = 39063
.equ timer1_ticks9 = 46875
.equ TIMER1_MAX_COUNT = 0xFFFF
.equ TIMER1_COUNTER_INIT1=TIMER1_MAX_COUNT-TIMER1_ticks1
.equ TIMER1_COUNTER_INIT2=TIMER1_MAX_COUNT-TIMER1_ticks2
.equ TIMER1_COUNTER_INIT3=TIMER1_MAX_COUNT-TIMER1_ticks3
.equ TIMER1_COUNTER_INIT4=TIMER1_MAX_COUNT-TIMER1_ticks4
.equ TIMER1_COUNTER_INIT5=TIMER1_MAX_COUNT-TIMER1_ticks5
.equ TIMER1_COUNTER_INIT6=TIMER1_MAX_COUNT-TIMER1_ticks6
.equ TIMER1_COUNTER_INIT7=TIMER1_MAX_COUNT-TIMER1_ticks7
.equ TIMER1_COUNTER_INIT8=TIMER1_MAX_COUNT-TIMER1_ticks8
.equ TIMER1_COUNTER_INIT9=TIMER1_MAX_COUNT-TIMER1_ticks9

	rjmp main_setup

.def button=r20
.def pointer=r21
.def n_low=r16
.def n_high=r17
.def speed=r19
.def count_l=r14
.def count_h=r15
.def value_low=r10
.def value_m=r11
.def value_h=r12
.def toggle_char=r13
.def prev_button=r24

start:
	; 000 - timer disabled
	; 001 - clock (no scaling)
	; 010 - clock / 8
	; 011 - clock / 64
	; 100 - clock / 256
	; 101 - clock / 1024
	; 110 - external pin Tx falling edge
	; 111 - external pin Tx rising edge
	ldi r23, (1<<CS12)|(1<<CS10)
	sts TCCR1B, r23


	cpi speed, 9
	brne not_9
	ldi r23, (1<<CS12)|(1<<CS10)
	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init9)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init9)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_9:
	cpi speed, 8
	brne not_8
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init8)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init8)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_8:
	cpi speed, 7
	brne not_7
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init7)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init7)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_7:
	cpi speed, 6
	brne not_6
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init6)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init6)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_6:
	cpi speed, 5
	brne not_5
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init5)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init5)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_5:
	cpi speed, 4
	brne not_4
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init4)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init4)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_4:
	cpi speed, 3
	brne not_3
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init3)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init3)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_3:
	cpi speed, 2
	brne not_2
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init2)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init2)
	sts TCNT1l, r23
	rjmp timer_on_end_adj
not_2:
	cpi speed, 1
	brne not_1
;	ldi r23, (1<<CS12)|(1<<CS10)
;	sts TCCR1B, r23
	ldi r23, high(timer1_counter_init1)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init1)
	sts TCNT1L, r23
	rjmp timer_on_end_adj
not_1:
	;means it is 0 so stop interrupts
	clr r23
	sts timsk1, r23
	sts tccr1b, r23
	rjmp end_timer_adj

timer_on_end_adj:
	ldi r23, (1<<CS12)|(1<<CS10)
	sts TCCR1B, r23
	ldi r23, 1<<TOIE1
	sts TIMSK1, r23
	

end_timer_adj:
	mov r10, n_low
	mov r11, n_high
	clr r12
	clr count_l
	clr count_h
	call three_byte_to_string
	call two_byte_to_string
	call update_bottom
	sei
	rjmp end_check
	

; value will be stored in registers 10,11,12
main_setup:
	ldi zl, low(spd)
	ldi zh, high(spd)
	ldi r18, 0
	st z, r18
	ldi pointer, 5
	ldi n_low, 0
	clr n_high
	ldi speed, 0
	clr count_l
	clr count_h
	clr prev_button
	ldi button, 0
	clr value_h
	clr value_m
	clr value_low
	cli
	clr r0
	jmp main

main:
; Update the screen with any changes if they were made	

	tst value_h
	brne not_one_yet
	tst value_m
	brne not_one_yet
	ldi r18, 1
	cp value_low, r18
	brne not_one_yet
	cli

not_one_yet:
	call update_lcd

	call button_check

	cp button, prev_button
	breq end_check


	


	mov prev_button, button
	
	cpi button, 5
	breq go_right
	cpi button, 4
	breq go_up
	cpi button, 3
	breq go_down_help
	cpi button, 2
	breq go_left


end_check:
	

	call delay

	rjmp main


go_down_help:
	jmp go_down

go_right:
	ldi r18, 14
	cp pointer, r18
	brsh end_check ; if pointer is at speed or farther (which should never happen) then go back to end check
	ldi r18, 6
	cp pointer, r18
	breq six_to_14
	inc pointer; if pointer isnt at 6 then value just goes up by one

back_to_movement:
	jmp end_check

six_to_14:
	ldi pointer, 14
	jmp back_to_movement

go_up:
	ldi r18, 3
	cp pointer, r18
	breq add_100
	ldi r18, 4
	cp pointer, r18
	breq add_10_help
	ldi r18, 5
	cp pointer, r18
	breq add_1_help
	ldi r18, 6
	cp pointer, r18
	breq start_help
	ldi r18, 14
	call speed_up
	jmp end_check

start_help:
	jmp start

go_left:
	ldi r18, 3
	cp pointer, r18
	breq end_check ; if pointer is at 3 then do nothing
	ldi r18, 14
	cp pointer, r18
	breq fourteen_to_six
	dec pointer ; if pointer isnt at 14 then go down by one

back_to_left:

	jmp end_check

add_10_help:
	jmp add_10
fourteen_to_six:
	ldi pointer, 6
	jmp back_to_left

help_for_add:
	jmp end_check

add_1_help:
	jmp add_1

go_down:
	ldi r18, 3
	cp pointer, r18
	breq sub_100
	ldi r18, 4
	cp pointer, r18
	breq sub_10_half
	ldi r18, 5
	cp pointer, r18
	breq sub_1_half
	ldi r18, 6
	cp pointer, r18
	breq start_help
	ldi r18, 14
	call speed_down
	jmp end_check



add_100:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+3
	ldi r23, '9'
	cp r18, r23
	breq help_for_add
	inc r18
	std z+3, r18
	ldi r18, 100
	add n_low, r18
	ldi r18, 0
	adc n_high, r18
	rjmp end_check

add_10:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+4
	ldi r23, '9'
	cp r18, r23
	breq end_jmp
	inc r18
	std z+4, r18
	ldi r18, 10
	add n_low, r18
	ldi r18, 0
	adc n_high, r18
	rjmp end_check
sub_1_half:
	jmp sub_1

sub_10_half:
	jmp sub_10

add_1:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+5
	ldi r23, '9'
	cp r18, r23
	breq end_jmp
	inc r18
	std z+5, r18
	ldi r18, 1
	add n_low, r18
	ldi r18, 0
	adc n_high, r18
	jmp end_check
	
sub_100:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+3
	ldi r23, '0'
	cp r18, r23
	breq end_jmp
	dec r18
	std z+3, r18
	ldi r18, 100
	sub n_low, r18
	ldi r18, 0
	sbc n_high, r18
	jmp end_check

sub_10:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+4
	ldi r23, '0'
	cp r18, r23
	breq end_jmp
	dec r18
	std z+4, r18
	ldi r18, 10
	sub n_low, r18
	ldi r18, 0
	sbc n_high, r18
end_jmp:
	jmp end_check

sub_1:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+5
	ldi r23, '0'
	cp r18, r23
	breq end_jmp
	dec r18
	std z+5, r18
	ldi r18, 1
	sub n_low, r18
	ldi r18, 0
	sbc n_high, r18
	jmp end_check

speed_up:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+14
	ldi r23, '9'
	cp r18, r23
	breq end_jmp
	inc r18
	inc speed
	std z+14, r18
	sts spd, speed
	brie timer_speed_change
	ret

speed_down:
	ldi zl, low(top_row)
	ldi zh, high(top_row)
	ldd r18, z+14
	ldi r23, '0'
	cp r18, r23
	breq end_jmp
	dec r18
	dec speed
	std z+14, r18
	sts spd, speed
	brie timer_speed_change
	ret

timer_speed_change:
	lds speed, spd
	cpi speed, 9
	brne not_9_1
	ldi r23, high(timer1_counter_init9)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init9)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_9_1:
	cpi speed, 8
	brne not_8_1
	ldi r23, high(timer1_counter_init8)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init8)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_8_1:
	cpi speed, 7
	brne not_7_1
	ldi r23, high(timer1_counter_init7)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init7)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_7_1:
	cpi speed, 6
	brne not_6_1
	ldi r23, high(timer1_counter_init6)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init6)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_6_1:
	cpi speed, 5
	brne not_5_1
	ldi r23, high(timer1_counter_init5)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init5)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_5_1:
	cpi speed, 4
	brne not_4_1
	ldi r23, high(timer1_counter_init4)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init4)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_4_1:
	cpi speed, 3
	brne not_3_1
	ldi r23, high(timer1_counter_init3)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init3)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_3_1:
	cpi speed, 2
	brne not_2_1
	ldi r23, high(timer1_counter_init2)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init2)
	sts TCNT1l, r23
	rjmp timer_on_end_adj1
not_2_1:
	cpi speed, 1
	brne not_1_1
	ldi r23, high(timer1_counter_init1)
	sts TCNT1H, r23
	ldi r23, low(timer1_counter_init1)
	sts TCNT1L, r23
	rjmp timer_on_end_adj1
not_1_1:
	;means it is 0 so stop interrupts
	clr r23
	sts timsk1, r23
	sts tccr1b, r23
	ret

timer_on_end_adj1:
	ldi r23, (1<<CS12)|(1<<CS10)
	sts TCCR1B, r23
	brie time_on ; if changing speed from outside interrupt
	ret
time_on:

	ldi r23, (1<<CS12)|(1<<CS10)
	sts TCCR1B, r23
	ldi r23, 1<<TOIE1
	sts TIMSK1, r23
	ret
button_check:
	; start a2d conversion
	push r16
	push r17
	push r21
	push r22
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

	cp r16, r22
	cp r17, r21
		
	;reaching here means no button pressed
	clr button

done_button:
	pop r22
	pop r21
	pop r17
	pop r16
	ret

pointer_right:
	ldi button, 5
	rjmp done_button

pointer_up:
	ldi button, 4
	rjmp done_button

pointer_down:
	ldi button, 3
	rjmp done_button

pointer_left:
	ldi button, 2
	rjmp done_button

;modified from solution posted
next_value:
	push zl
	push zh
	push r16
	push r17
	push r18

	push r24
	push r20
	push r21

	push r22
	push r23

	ldi r23, 0
	ldi r22, 1
	in zl, spl
	in zh, sph

	ldd r18, z+14  ; high
	ldd r17, z+15 ; mid
	ldd r16, z+16 ; low

	CP r16, r22
	CPC r17, r23
	CPC r18, r23
	BREQ return

	; increment the count
	ADD count_l, r22
	ADC count_h, r23

	; test even or odd
	LDI r24, 0b00000001
	AND r24, r16
	BREQ even
	
; odd
	; 3n + 1
	MOV r24, r16
	MOV r20, r17
	MOV r21, r18
	ADD r16, r24 ; 2n...
	ADC r17, r20
	ADC r18, r21
	ADD r16, r24 ; 3n...
	ADC r17, r20
	ADC r18, r21
	ADD r16, r22	; 3n+1
	ADC r17, r23
	ADC r18, r23
	
return:
	std z+16, r16
	std z+15, r17
	std z+14, r18
	pop r23
	pop r22
	pop r21
	pop r20
	pop r24
	pop r18
	pop r17
	pop r16
	pop zh
	pop zl
	ret

even:
	; n / 2
	LSR r16
	LSR r17
	BRCS carry_mid_to_low
return_from_carry:
	LSR r18
	BRCS carry_high_to_mid
    RJMP return
carry_mid_to_low:
	LDI r24, 0b10000000
	ADD r16, r24
	RJMP return_from_carry
carry_high_to_mid:
	ldi r24, 0b10000000
	add r17, r24
	rjmp return

update_lcd:
	push r23


	call lcd_clr

	ldi r23, 0
	push r23
	push r23
	call lcd_gotoxy
	pop r23
	pop r23
	ldi r23, high(top_row)
	push r23
	ldi r23, low(top_row)
	push r23
	call lcd_puts
	pop r23
	pop r23

	ldi r23, 1
	push r23
	ldi r23, 0
	push r23
	call lcd_gotoxy
	pop r23
	pop r23
	ldi r23, high(bot_row)
	push r23
	ldi r23, low(bot_row)
	push r23
	call lcd_puts
	pop r23
	pop r23

	
	pop r23
	ret

;modified from posted lab
three_byte_to_string:
	.def dividend_low=r0
	.def dividend_mid=r5
	.def dividend_high=r6
	.def divisor=r1
	.def quotient_l=r2
	.def quotient_m=r7
	.def quotient_h=r8
	.def tempt=r18
	.def char0=r3
	.def num0=r4
	.def num1=r9
	;preserve the values of the registers
	push dividend_low
	push divisor
	push quotient_l
	push quotient_m
	push quotient_h
	push tempt
	push char0
	push ZH
	push ZL
	push num0
	push dividend_mid
	push dividend_high
	push num1


	clr num0
	clr num1
	inc num1


	;store '0' in char0
	ldi tempt, '0'
	mov char0, tempt
	;Z points to first character of num in SRAM
	ldi ZH, high(value)
	ldi ZL, low(value)
	ldi tempt, ' '
	st z+, tempt
	st z+, tempt
	st z+, tempt
	st z+, tempt
	st z+, tempt
	st z+, tempt
	st z+, tempt
	ldi ZH, high(value)
	ldi ZL, low(value)
	adiw ZH:ZL, 6 ;Z points to null character
	clr tempt 
	st Z, tempt ;set the last character to null
	sbiw ZH:ZL, 1 ;Z points the last digit location

	;initialize values for dividend, divisor
	ldi tempt, 132
	mov dividend_low, r10 
	mov dividend_mid, r11
	mov dividend_high, r12
	ldi tempt, 10
	mov divisor, tempt
	
	clr quotient_l
	clr quotient_m
	clr quotient_h
	digit2str2:
		cp dividend_low, divisor ; low byte and the low byte of divisor
		cpc dividend_mid, num0
		cpc dividend_high, num0
		brlo finish2
		division2:
			add quotient_l, num1
			adc quotient_m, num0
			adc quotient_h, num0
			sub dividend_low, divisor
			sbc dividend_mid, num0
			sbc dividend_high, num0
			cp dividend_low, divisor
			cpc dividend_mid, num0
			cpc dividend_high, num0
			brsh division2
		;change unsigned integer to character integer
		add dividend_low, char0
		st Z, dividend_low;store digits in reverse order
		sbiw r31:r30, 1 ;Z points to previous digit
		mov dividend_low, quotient_l
		mov dividend_mid, quotient_m
		mov dividend_high, quotient_h
		clr quotient_l
		clr quotient_m
		clr quotient_h
		jmp digit2str2
	finish2:
	add dividend_low, char0
	st Z, dividend_low ;store the most significant digit

	;restore the values of the registers
	pop num1
	pop dividend_high
	pop dividend_mid
	pop num0
	pop ZL
	pop ZH
	pop char0
	pop tempt
	pop quotient_h
	pop quotient_m
	pop quotient_l
	pop divisor
	pop dividend_low
	ret
	.undef dividend_low
	.undef dividend_mid
	.undef dividend_high
	.undef divisor
	.undef quotient_l
	.undef quotient_m
	.undef quotient_h
	.undef tempt
	.undef char0
	.undef num0
	.undef num1

; for making the count a string
two_byte_to_string:
	.def dividend_low=r0
	.def dividend_mid=r5
	.def dividend_high=r6
	.def divisor=r1
	.def quotient_l=r2
	.def quotient_m=r7
	.def quotient_h=r8
	.def tempt=r18
	.def char0=r3
	.def num0=r4
	.def num1=r9
	;preserve the values of the registers
	push dividend_low
	push divisor
	push quotient_l
	push quotient_m
	push quotient_h
	push tempt
	push char0
	push ZH
	push ZL
	push num0
	push dividend_mid
	push dividend_high
	push num1


	clr num0
	clr num1
	inc num1


	;store '0' in char0
	ldi tempt, '0'
	mov char0, tempt
	;Z points to first character of num in SRAM
	ldi ZH, high(count_s)
	ldi ZL, low(count_s)
	ldi tempt, ' '
	st z+, tempt
	st z+, tempt
	st z+, tempt
	st z+, tempt
	ldi zh, high(count_s)
	ldi zl, low(count_s)
	adiw ZH:ZL, 3 ;Z points to null character
	clr tempt 
	st Z, tempt ;set the last character to null
	sbiw ZH:ZL, 1 ;Z points the last digit location

	ldi tempt, ' '

	;initialize values for dividend, divisor
	ldi tempt, 132
	mov dividend_low, count_l
	mov dividend_mid, count_h
	mov dividend_high, num0
	ldi tempt, 10
	mov divisor, tempt
	
	clr quotient_l
	clr quotient_m
	clr quotient_h
	digit2str:
		cp dividend_low, divisor ; low byte and the low byte of divisor
		cpc dividend_mid, num0
		cpc dividend_high, num0
		brlo finish
		division:
			add quotient_l, num1
			adc quotient_m, num0
			adc quotient_h, num0
			sub dividend_low, divisor
			sbc dividend_mid, num0
			sbc dividend_high, num0
			cp dividend_low, divisor
			cpc dividend_mid, num0
			cpc dividend_high, num0
			brsh division
		;change unsigned integer to character integer
		add dividend_low, char0
		st Z, dividend_low;store digits in reverse order
		sbiw r31:r30, 1 ;Z points to previous digit
		mov dividend_low, quotient_l
		mov dividend_mid, quotient_m
		mov dividend_high, quotient_h
		clr quotient_l
		clr quotient_m
		clr quotient_h
		jmp digit2str
	finish:
	add dividend_low, char0
	st Z, dividend_low ;store the most significant digit

	;restore the values of the registers
	pop num1
	pop dividend_high
	pop dividend_mid
	pop num0
	pop ZL
	pop ZH
	pop char0
	pop tempt
	pop quotient_h
	pop quotient_m
	pop quotient_l
	pop divisor
	pop dividend_low
	ret
	.undef dividend_low
	.undef dividend_mid
	.undef dividend_high
	.undef divisor
	.undef quotient_l
	.undef quotient_m
	.undef quotient_h
	.undef tempt
	.undef char0
	.undef num0
	.undef num1

update_bottom:
	push zl
	push zh
	push yh
	push yl
	push r18
	push r16
	;change count value first
	ldi zl, low(count_s)
	ldi zh, high(count_s)
	ldi yl, low(bot_row)
	ldi yh, high(bot_row)

	ldi r18, 4
	clr r16
	add yl, r18
	adc yh, r16

	ld r18, z+ ;holds the first character
	st y+, r18 ; first num stored
	ld r18, z+
	st y+, r18 ; second
	ld r18, z+
	st y+, r18 ; third

	; fourth character is null so dont do it

	ldi r18, 3
	add yl, r18
	adc yh, r16

	ldi zl, low(value)
	ldi zh, high(value)

	ld r18, z+
	st y+, r18 ; num 1
	ld r18, z+
	st y+, r18 ; num 2
	ld r18, z+
	st y+, r18 ; num 3
	ld r18, z+
	st y+, r18 ; num 4
	ld r18, z+
	st y+, r18 ; num 5
	ld r18, z+
	st y+, r18 ; num 6
	
	pop r16
	pop r18
	pop yl
	pop yh
	pop zh
	pop zl
	ret

	
	
delay:
	push r20
	push r21
	push r22
	; Nested delay loop
	ldi r20, 0x7f
x12:
		ldi r21, 0x7F
x22:
			ldi r22, 0x2F
x32:
				dec r22
				brne x32
			dec r21
			brne x22
		dec r20
		brne x12
	pop r22
	pop r21
	pop r20
	ret

delay2:
	push r20
	push r21
	push r22
	; Nested delay loop
	ldi r20, 0x7f
x1:
		ldi r21, 0xfF
x2:
			ldi r22, 0x7F
x3:
				dec r22
				brne x3
			dec r21
			brne x2
		dec r20
		brne x1
	pop r22
	pop r21
	pop r20
	ret

.dseg
.org 0x200

name: .byte 15
course_year: .byte 16

top_row: .byte 17
bot_row: .byte 17
value: .byte 7
count_s: .byte 4
spd: .byte 1
.undef button
.undef pointer
.undef n_low
.undef n_high
.undef speed
.undef prev_button
; Include the HD44780 LCD Driver for ATmega2560
;
; This library has it's own .cseg, .dseg, and .def
; which is why it's included last, so it would not interfere
; with the main program design.
#define LCD_LIBONLY
.include "lcd.asm"
