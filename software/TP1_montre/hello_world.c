/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "altera_up_avalon_parallel_port_regs.h"
#include "sys/alt_irq.h"
#include "alt_types.h"    //<alt_types.h>

 /* A variable to hold the value of the button pio edge capture register. */
volatile int edge_capture;
void init_pio();
/*  WE USED unsigned long instead of the alt_type: alt_u32  */
void handle_sw_interrupts(void* context, unsigned long id);

void Update_HEX_display(int);

/*

enum type {
	SHOW_TIME = 0x00, SHOW_CHRONO = 0x01
} type;

enum chrono_state {
	ARRET = 0x00, PAUSE = 0x01, ACTIF = 0x02
} chrono_state;

int h, m, s, ms; // vars of the time
int hc, mc, sc, msc; // these are the variables of the chronometer
*/

volatile int * btn_ptr = (int*) 0x1001060; // KEY_BASE;
volatile int * sw_ptr = (int*) 0x1001050 ; //SW_BASE;
volatile int * hex_ptr = (int*)0x1001020; // HEX_BASE;
volatile int * ledr_ptr = (int*) 0x1001030; //LEDR_BASE;
volatile int * ledg_ptr = (int*)0x1001040; // LEDG_BASE;
int val = 0;


char seven_seg_decode_table[] = { 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D,
		0x07, 0x7F, 0x6F, 0x77, 0x73, 0x39, 0x5E, 0x79, 0x71 };
char hex_segments[] = { 0, 0, 0, 0, 0, 0, 0, 0 };

int main() {

    init_pio();

    while(1)
    {
    	*ledr_ptr = val;
    	//usleep(000);
    	//val = 0;
    }



	/*int dis_s, unit_s, dis_m, unit_m, hex_num;
	int dis_s_c, unit_s_c, dis_m_c, unit_m_c;

	type = SHOW_TIME;
	chrono_state = ARRET;

	printf("Hello CS2E!\n");

	Update_HEX_display(0x4321);

	while (1) {
		int SW_val = *sw_ptr;
		int KEY_val = *btn_ptr;

		if (KEY_val & 0x8) // RESET is KEY[3]
				{
			ms = 0;
			s = 0;
			m = 0;
			h = 0;
			continue;
		}

		if (!SW_val & 0x01)
			type = SHOW_TIME;
		else
			type = SHOW_CHRONO;

		if (KEY_val & 0x4)
			chrono_state = (chrono_state == PAUSE ? ACTIF : PAUSE);

		if (KEY_val & 0x2) {
			hc = 0;
			mc = 0;
			sc = 0;
			msc = 0;
		}

		if (ms == 1000) {
			ms = 0;
			s++;

			if (chrono_state == ACTIF) {
				msc = 0;
				sc++;
			}

			if (type == SHOW_TIME) {
				dis_s = s / 10;
				unit_s = s % 10;
				dis_m = m / 10;
				unit_m = m % 10;
				hex_num = (unit_s) | (dis_s << 4) | (unit_m << 8) | (dis_m << 12);
			} else {
				dis_s_c = sc / 10;
				unit_s_c = sc % 10;
				dis_m_c = mc / 10;
				unit_m_c = mc % 10;
				hex_num = (unit_s_c) | (dis_s_c << 4) | (unit_m_c << 8) | (dis_m_c << 12);
			}

			Update_HEX_display(hex_num);

			printf("time: %d:%d ----\t\tchrono:  %d:%d   -- %s\n", m, s, mc, sc,
					(type == SHOW_TIME ? "time" : "chrono"));
		}
		if (s == 60) {
			s = 0;
			m++;

			if (chrono_state == ACTIF) {
				sc = 0;
				mc++;
			}
		}
		if (m == 60) {
			m = 0;
			h++;
			if (chrono_state == ACTIF) {
				mc = 0;
				hc++;
			}

		}

		/////////

		usleep(0);
		ms++;

	}
		*/

	return 0;
}


void handle_sw_interrupts(void* context, unsigned long id)
{
    /* Cast context to edge_capture's type. It is important that this be
     * declared volatile to avoid unwanted compiler optimization.
     */
    volatile int* edge_capture_ptr = (volatile int*) context;
    /* Store the value in the Button's edge capture register in *context. */
    *edge_capture_ptr = IORD_ALT_UP_PARALLEL_PORT_EDGE_CAPTURE(SW_BASE);
   // n++;
    /*  Set ur action here   */
    val = ~val; // == 0 ? 1 : 0); //IORD_ALT_UP_PARALLEL_PORT_DATA(SW_BASE);

    /* Reset the Button's edge capture register. */
	IOWR_ALT_UP_PARALLEL_PORT_EDGE_CAPTURE(SW_BASE, 1);
	//IOWR_ALT_UP_PARALLEL_PORT_EDGE_CAPTURE(SW_BASE, 0);

}

/* Initialize the pio. */
void init_pio()
{
    /* Recast the edge_capture pointer to match the alt_irq_register() function
     * prototype. */
    void* edge_capture_ptr = (void*) &edge_capture;
    /* Enable first four interrupts. */
    IOWR_ALT_UP_PARALLEL_PORT_INTERRUPT_MASK(SW_BASE, 0x3ff);
    ////IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_BASE, 0xf);

    /* Reset the edge capture register. */
	IOWR_ALT_UP_PARALLEL_PORT_EDGE_CAPTURE(SW_BASE, 1);
	IOWR_ALT_UP_PARALLEL_PORT_EDGE_CAPTURE(SW_BASE, 0);    ////IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_BASE, 0x0);
    /* Register the interrupt handler. */
    alt_irq_register(SW_IRQ, edge_capture_ptr,
                      handle_sw_interrupts );
}

/*******************************************************************************
 * Updates the value displayed on the hex display. The value is taken from the
 * buffer.
 ********************************************************************************/
void Update_HEX_display(int buffer) {
	volatile int* HEX3_HEX0_ptr = (int*) HEX_BASE;

	int shift_buffer, nibble;
	char code;
	int i;

	shift_buffer = buffer;
	for (i = 0; i < 8; ++i) {
		nibble = shift_buffer & 0x0000000F; // character is in rightmost nibble
		code = seven_seg_decode_table[nibble];
		hex_segments[i] = code;
		shift_buffer = shift_buffer >> 4;
	}
	*(HEX3_HEX0_ptr) = *(int *) hex_segments; // drive the hex displays
	return;
}