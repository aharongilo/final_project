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


reg load;// mayb should be an input??
reg load_key_evolution;
reg load_key_selection;
reg load_round;
reg clk_en = 0;
reg [3:0] counter = 0;
reg [3:0] round_num = 0;
reg [1:0] state = 0;
reg done = 1; //flag to see if all 12 rounds are finished
reg [127:0] evolutioned_key;
reg [127:0] selected_key;
reg [127:0] round_out;
reg [127:0] cipher;
wire [127:0] step1;
wire [127:0] step2;
wire [127:0] step3;

localparam key_evolution = 2'b00;
localparam key_selection = 2'b01;
localparam round = 2'b10;

always@(posedge clk)
	if (reset)
		counter = 0;
	else
		counter = counter+1;
	
always@(posedge clk) // clk_en proccess. tells when to move stages inside the nested modules (evolution key, selected key and round)
begin
	if (reset)
		clk_en = 0;
	else
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
	if (round_num > 12)
	begin
		if (start == 0)
			done = 1;
		else
			done = 0;
	end
end

key_evolution first(clk,reset,clk_en,load_key_evolution,round_num,key,<round constant>,step1);
key_selection second(clk,reset,clk_en,load_key_selection,evolutioned_key,step2);
round step3(clk,reset,clk_en,load_round,round_num,plain_text,selected_key,step3);

always@(posedge clk)
if (reset)
begin
	evolutioned_key = 0;
	selected_key = 0;
	round_out = 0;
	round_num = 1;
	state = 0;
end
/*what happened in reset: 
1. results registers
2. round number*/
else
begin
	if (done)
	/*what happened when I'm done*/
	begin
		cipher = round_out;
		round_num = 1;
		state = 0;
	end
	else
	begin
	/*state machine for the anubis code*/
		case(state)
			key_evolution: if(load)
						   begin
								state = key_selection;
								evolutioned_key = step1;
						   end
			key_selection: if(load)
						   begin
								state = round;
								selected_key = step2;
						   end
			round: if(load)
				   begin
						state = key_evolution;
						round_out = step3;
						round_num = round_num + 1;
				   end
			else // in any other situatuion, the flow wil restart itself
			begin
				state = key_evolution;
				round_num = 0;
				counter = 0;
			end
				
		endcase
	end
end



assign end_flag = done;
assign cipher_text = cipher;

endmodule

