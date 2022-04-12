/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: anubis

Description: this module is the top module of the algorithm implementation
			 it derive all the nested modules of the algorithm.

input:
- clk
- reset
- plain_text
- key

output:
- cipher_text
**************************/
module anubis(
	input clk,
	input reset,
	input start,
	input [127:0] plain_text,
	input [127:0] key,
	output [127:0] cipher_text,
	output end_flag
);
/*make and derive clk_en and load key\text*/

reg load;// mayb should be an input??
reg clk_en = 0;
reg [3:0] counter = 0;
reg [3:0] round_num = 0;
reg done = 1; //flag to see if all 12 rounds are finished
wire [127:0] evolutioned_key;
wire [127:0] selected_key;
wire [127:0] cipher;

localparam key_evolution = 2'b00;
localparam key_selection = 2'b01;
localparam round = 2'b10;
// the 4th state in the machine - use else, will sent to the beginnig


always@(posedge clk)
	counter = counter+1;
	
always@(posedge clk) // clk_en proccess. tells when to move stages inside the nested modules (evolution key, selected key and round)
begin
		if (counter%4 == 0)
			clk_en = 1;
		else
			clk_en = 0;
end

always@(posedge clk) // load proccess, tells when to jump to the next module (evolution key, selected key and round)
begin

	if (counter == 15)
		load = 1;
	else
		load = 0;
end

always@(negedge clk) // done proccess. indicates when the cipher text is ready.
/*negedge to sample the start signal and round number after they change in posedge*/
begin
	if (round_num == 13)
	begin
		done = 1;
	end
	else
	begin
		if (start)	
			done = 0;
		else
			done = 1;
	end
end

/*enter the nested modules usage in here*/

always@(posedge clk)
if (reset)
/*what happened in reset: 
1. results registers
2. round number*/
else
begin
	if (done)
	/*what happened when I'm done*/
	else
	begin
	/*state machine for the anubis code*/
	end
end



assign end_flag = done;


endmodule

/*grey code for the state machine*/
/*localparam evolution_key1 = 4'b0000;
localparam evolution_key2 = 4'b0001;
localparam evolution_key3 = 4'b0011;
localparam evolution_key4 = 4'b0010;
localparam selection_key1 = 4'b0110;
localparam selection_key2 = 4'b0111;
localparam selection_key3 = 4'b0101;
localparam selection_key4 = 4'b0100;
localparam round1 = 4'b1100;
localparam round2 = 4'b1101;
localparam round3 = 4'b1111;
localparam round4 = 4'b1110;*/
/*the last four states in teh machine could use for recieve and transmit words to and from the algorithm
to do that, we need to insert some flags to indicate when transmition and recieve is happening*/
