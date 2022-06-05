/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: sigma

Description:
this module represent the sigma function in teh algorithm
this function do bitwise xor between 2 inputs

input:
- in1 (128 bits)
- in2 (128 bits)

output:
- out (128 bits)
**************************/


module sigma
(
	input [127:0] in1,
	input [127:0] in2,
	output [127:0] out
);

assign out = in1^in2;

endmodule