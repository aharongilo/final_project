/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: rounde 

Description: this module represent a round in ANUBIS algorithm

input:
- clk
- reset
- clk_en
- round number
- load_text
- round plain text (128 bits)
- round key (128 bits)

output:
- round cipher text
**************************/
module round(
	input clk,
	input reset,
	input clk_en,
	input load_text,
	input [3:0] round_number, // in the 12th round, we don't do sigma
	input [127:0] round_plain_text,
	input [127:0] round_key,
	output [127:0] round_cipher_text
);

localparam F_GAMMA = 2'b00;
localparam F_TAU   = 2'b01;
localparam F_THETA = 2'b10;
localparam F_SIGMA = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out, tau_out, theta_out,cipher,data_in;
reg [1:0] state;

/*
	clk_en will be driven by the ANUBIS top module
	it will rise up every 3 clocks, to let the slowest function,
	theta (which contain a call to ROM memory), time to recover 
	and end it's task
*/
gamma s1(round_plain_text,step1);
tau s2(gamma_out,step2);
theta s3(clk,tau_out,step3);
sigma s4(round_key,theta_out,step4);

always @(negedge clk)
if (reset)
begin
	state <= F_GAMMA;
	cipher <= 0;
end	
else
begin
	if (load_text == 1)
		state <= F_GAMMA;
	else
		case(state)
			F_GAMMA: if (clk_en)
						begin
							state <= F_TAU;
							gamma_out <= step1;
						end
			F_TAU:   if (clk_en)
						begin
							state <= F_THETA;
							tau_out <= step2;
						end
			F_THETA: if (clk_en)
						begin
							if (round_number == 12)
							begin
								state <= F_GAMMA;
								cipher <= step3;
							end
							else
							begin
								state <= F_SIGMA;
								theta_out <= step3;
							end
						end
			F_SIGMA: if (clk_en)
						begin
							state <= F_GAMMA;
							cipher <= step4;
						end
		endcase
end

assign round_cipher_text = cipher;
		

/*gamma s1(round_plain_text,step1);
tau   s2(gamma_out,step2);
theta s3(tau_out,step3);
sigma s4(theta_out,step4);*/

endmodule