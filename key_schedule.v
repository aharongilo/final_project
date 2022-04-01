/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: key schedule

Description: this module represent the key schedule in the ANUBIS algorithm

input:
- clk
- reset
- clk_en
- load key
- key (128 bits)

output:
- round key
**************************/
module key_schedule(
	input clk,
	input reset,
	input clk_en,
	input load_key,
	input [127:0] key,
	output [127:0] round_key
);





endmodule