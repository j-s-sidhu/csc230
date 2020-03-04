/*
 * a4.c
 *
 * Created: 12/13/2019 3:06:27 PM
 * Author : justicesidhu
 */ 

#include <avr/io.h>
#include <string.h>
#include <stdio.h>
#include "CSC230.h"

#define  ADC_BTN_RIGHT 0x032
#define  ADC_BTN_UP 0x0C3
#define  ADC_BTN_DOWN 0x17C
#define  ADC_BTN_LEFT 0x22B
#define  ADC_BTN_SELECT 0x316

unsigned short adc_button;
unsigned short prev_button;
volatile int button;

volatile int speed_curr;
volatile int speed_mem;

volatile int n_total;
volatile int val;
volatile int count;
volatile char v[7];
volatile char c[4];

volatile int blink_num;
volatile int position;
volatile int n_array[16];
volatile unsigned char output_line[16];
volatile unsigned char bot_line[17];

// Change the settings for timer4 based on what is stored in curr_speed
void change_speed(){
	// Set the appropriate value for whatever the current speed is
	if(speed_curr == 0){
		TIMSK4 = 0;
		TCCR4B = 0;
	}
	
	if(speed_curr == 1){
		TCCR4B = (1<<CS42)|(1<<CS40);
		TCNT4 = 0xFFFF - 977;
		TIMSK4 = (1<<TOIE4);
	}
	else if(speed_curr == 2){
		TCNT4 = 0xFFFF - 1953;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 3){
		TCNT4 = 0xFFFF - 3906;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 4){
		TCNT4 = 0xFFFF - 7812;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 5){
		TCNT4 = 0xFFFF - 15625;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 6){
		TCNT4 = 0xFFFF - 23438;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 7){
		TCNT4 = 0xFFFF - 31250;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 8){
		TCNT4 = 0xFFFF - 39063;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
	
	else if(speed_curr == 9){
		TCNT4 = 0xFFFF - 46875;
		TIMSK4 = (1<<TOIE4);
		TCCR4B = (1<<CS42)|(1<<CS40);
	}
}

// get the next value of the collatz sequence and update count
void collatz_next(){
	if(val == 1){
		return;
	}
	count++;
	if(val % 2 == 0){
		val = val/2;
	}
	else{
		val = 3 * val + 1;
	}
}

// UPDATE the bottom line to display collatz value
void update_value(){
	
	//change count and val to strings
	
	sprintf(v, "%d", val);
	
	int x;
	for(x = 15; x >= 10; x--){
		if(v[x-10] == '\0'){
			bot_line[x] = ' ';
		}
		else{
			bot_line[x] = v[x-10];
		}
	}

	//change bottom line to reflect new values
}

// UPDATE the bottom line to display new count
void update_count(){
	
	//change count and val to strings
	
	sprintf(c, "%d", count);
	
	int x;
	for(x = 6; x >= 4; x--){
		if(c[x-4] == '\0'){
			bot_line[x] = ' ';
		}
		else{
			bot_line[x] = c[x-4];
		}
	}

	//change bottom line to reflect new values
}

// set up timer4 which will control the updating of the collatz sequence and count
void start(){
	TCCR4A = 0;
	TCCR4B = (1<<CS42)|(1<<CS40); // prescaler of 1024
	
	// Set the appropriate value for whatever the current speed is
	change_speed();
	val = n_total;
	count = 0;
	update_count();
	update_value();
}

// Move the cursor to the right by one
void right(){
	//14 is the right most position allowed so do nothing and return if this is true
	if(position == 14){
		return;
	}
	// move right otherwise
	if(position <= 5){
		position++;
		return;
	}
	
	if(position == 6){
		position = 14;
	}
}


// move the cursor to the left
void left(){
	// 3 is the leftmost so return if true
	if(position == 3){
		return;
	}
	
	if(position == 14){
		position = 6;
		return;
	}
	
	position--;
}

// change the value of whatever the cursor is pointed at if it points at the asterisk then start updating collatz
void up(){
	//update total value of n and update the array that holds true value to help with blinking based on where cursor was when pressed
	//start collatz counting if on asterisk
	if(position == 5 && n_array[5] != '9'){
		n_total++;
		n_array[5] = n_array[5]+1;
	}
	else if(position == 4 && n_array[4] != '9'){
		n_total = n_total + 10;
		n_array[4] = n_array[4]+1;
	}
	
	else if(position == 3 && n_array[3] != '9'){
		n_total = n_total + 100;
		n_array[3] = n_array[3]+1;
	}
	
	else if(position == 14 && n_array[14] != '9'){
		speed_curr++;
		//change speed because it must change as the spd value changes
		change_speed();
		n_array[14] = n_array[14] + 1;
	}
	else if(position == 6){
		start();
	}
}


// change total value by the required amount
// update output strings to reflect change
// start if on asterisk
void down(){
	if(position == 5 && n_array[5] != '0'){
		n_total++;
		n_array[5] = n_array[5]-1;
	}
	else if(position == 4 && n_array[4] != '0'){
		n_total = n_total - 10;
		n_array[4] = n_array[4]-1;
	}
	
	else if(position == 3 && n_array[3] != '0'){
		n_total = n_total - 100;
		n_array[3] = n_array[3]-1;
	}
	
	else if(position == 14 && n_array[14] != '0'){
		speed_curr--;
		n_array[14] = n_array[14] - 1;
		change_speed();
	}
	else if(position == 6){
		start();
	}
	
}


// swap current and memory speed values
// change the timer to the new speed
// update output strings to reflect new speed
void select(){
	int temp = speed_curr;
	speed_curr = speed_mem;
	speed_mem = temp;
	// change timer4 speed to reflect new value of speed
	char tmp[2];
	sprintf(tmp, "%d", speed_curr);
	n_array[14] = tmp[0];
	output_line[14] = tmp[0];
	change_speed();
}



int main(void)
{
	
	
    //ADC Set up
    ADCSRA = 0x87;
    ADMUX = 0x40;
	adc_button = 0xffff;
	//initialize lcd
	lcd_init();
	
	// output intro for 1 second
	char intro1[] = "Justice Sidhu";
	char intro2[] = "CSC230 Fall 19";
	lcd_xy(0,0); 
	lcd_puts(intro1);
	lcd_xy(0,1);
	lcd_puts(intro2);
	
	_delay_ms(1000);
	
	// set up the input/output screen
	output_line[0] = ' ';
	output_line[1] = 'n';
	output_line[2] = '=';
	output_line[3] = '0';
	output_line[4] = '0';
	output_line[5] = '0';
	output_line[6] = '*';
	output_line[7] = ' ';
	output_line[8] = ' ';
	output_line[9] = ' ';
	output_line[10] = 'S';
	output_line[11] = 'P';
	output_line[12] = 'D';
	output_line[13] = '=';
	output_line[14] = '0';
	output_line[15] = '\0';
	bot_line[0] = 'c';
	bot_line[1] = 'n';
	bot_line[2] = 't';
	bot_line[3] = ':';
	bot_line[4] = ' ';
	bot_line[5] = ' ';
	bot_line[6] = '0';
	bot_line[7] = ' ';
	bot_line[8] = 'v';
	bot_line[9] = ':';
	bot_line[10] = ' ';
	bot_line[11] = ' ';
	bot_line[12] = ' ';
	bot_line[13] = ' ';
	bot_line[14] = ' ';
	bot_line[15] = '0 ';
	bot_line[17] = '\0';
	char line2[] = "cnt:  0 v:     0";
	lcd_xy(0,0);
	lcd_puts(output_line);
	lcd_xy(0,1);
	lcd_puts(line2);
	
	
	
	
	// set up inital values of zero
	speed_mem = 0;
	speed_curr = 0;
	n_total = 0;
	val = 0;
	count = 0;
	blink_num = 0;
	position = 5;
	n_array[3] = '0';
	n_array[4] = '0';
	n_array[5] = '0';
	n_array[6] = '*';
	n_array[14] = '0';
	//set up timer1 for button
	TCCR1A = 0;
	TCCR1B = (1<<CS12)|(1<<CS10);	// Prescaler of 1024
	TCNT1 = 0xFFFF - 781;			// Initial count (1/20 second)
	TIMSK1 = 1<<TOIE1;
	
	//set up timer2 for blinking
	TCCR3A = 0;
	TCCR3B = (1<<CS32)|(1<<CS30);	// Prescaler of 1024
	TCNT3 = 0xFFFF - 7812;			// Initial count 
	TIMSK3 = 1<<TOIE3;
	sei();
	
	adc_button = 0xffff;
	prev_button = 0;
	button = 0;
	
    while (1) 
    {
		
	
		
		lcd_xy(0,0);
		lcd_puts(output_line);
		lcd_xy(0,1);
		
		lcd_puts(bot_line);
		if(prev_button != button){
			
		
			if(button == 1){
			
				right();
			}
			else if(button == 2){
				up();
				
			}
			else if(button == 3){
				down();
			}
			else if(button == 4){
				left();
			}
			else if(button == 5){
				select();
			}
		}
		prev_button = button;
	}
}



// From lab9
//A short is 16 bits wide, so the entire ADC result can be stored
//in an unsigned short.
unsigned short poll_adc(){
	unsigned short adc_result = 0; //16 bits
	
	ADCSRA |= 0x40;
	while((ADCSRA & 0x40) == 0x40); //Busy-wait
	
	unsigned short result_low = ADCL;
	unsigned short result_high = ADCH;
	
	adc_result = (result_high<<8)|result_low;
	
	
	return adc_result;
}

// isr to check whatever button is being pressed
ISR(TIMER1_OVF_vect) {
	// Reset the initial count and get button adc value
	adc_button = poll_adc();
	if(adc_button < ADC_BTN_RIGHT){
		
		button = 1;
	}
	else if(adc_button < ADC_BTN_UP){
		button = 2;
	}
	else if(adc_button < ADC_BTN_DOWN){
		button = 3;
	}
	else if(adc_button < ADC_BTN_LEFT){
		button = 4;
	}
	else if(adc_button < ADC_BTN_SELECT){
		button = 5;
	}
	else{
		button = 0;
	}
	TCNT1 = 0xFFFF - 781;

	
}

//ISR TO Control the blinking of the cursor
ISR(TIMER3_OVF_vect){
	// if the flag is 0 set current position to space
	if(blink_num == 0){
		output_line[position] = ' ';
		blink_num++;
	}
	
	// otherwise put all the correct values where they should be
	else if(blink_num == 1){
		output_line[3] = n_array[3];
		output_line[4] = n_array[4];
		output_line[5] = n_array[5];
		output_line[6] = n_array[6];
		output_line[14] = n_array[14];
		blink_num--;
	}
	TCNT3 = 0xFFFF - 7812;
}


//update value of count and get next collatz value
//reset timer
//update output strings
ISR(TIMER4_OVF_vect){
	collatz_next();
	update_count();
	update_value();
	// call change speed because the timer needs to be reset but it is reset based on the value in speed_curr
	change_speed();
}