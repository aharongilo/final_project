/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: key selection (Psi)

Description: this module represent the key selection function in the ANUBIS algorithm
this function is the second part of the key schedule

input:
- clk
- reset
- clk_en
- evolutioned_key (128 bits)

output:
- round_key
**************************/

module key_selection(
	input clk,
	input reset,
	input clk_en,
	input [127:0] evolutioned_key
	output [127:0] round_key
);

localparam F_GAMMA = 2'b00;
localparam F_OMEGA = 2'b01;
localparam F_TAU   = 2'b10;

wire [127:0] step1,step2,step3;
reg [127:0] gamma_out,omega_out,selected_key;
reg [1:0] state;

gamma sk1(evolutioned_key,step1);
omega sk2(clk,gamma_out,step2);
tau sk3(omega_out,step3)

/*state machine goes here*/

assign round_key = selected_key;

endmodule