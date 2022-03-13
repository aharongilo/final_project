/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: rounde 

Description: this module represent a round in ANUBIS algorithm

input:
- clk
- clk_en
- round plain text (128 bits)
- round key (128 bits)

output:
- round cipher text
**************************/
module round(
	input clk,
	input clk_en,
	input [127:0] round_plain_text,
	input [127:0] round_key,
	output [127:0] round_cipher_text
);



endmodule