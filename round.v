/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: rounde 

Description: this module represent a round in ANUBIS algorithm

input:
- clk
- clk_en
- load_text
- round plain text (128 bits)
- round key (128 bits)

output:
- round cipher text
**************************/
module round(
	input clk,
	input clk_en,
	input load_text,
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
always @(posedge clk)
if (load_text == 1)
	state <= F_GAMMA;
else
	case(state)
		F_GAMMA: gamma s1(round_plain_text,step1);
				 if (clk_en)
					begin
						state <= F_TAU;
						gamma_out <= step1;
					end
		F_TAU:   tau s2(gamma_out,step2);
				 if (clk_en)
					begin
						state <= F_THETA;
						tau_out <= step2;
					end
		F_THETA: theta s3(tau_out,step3);
				 if (clk_en)
					begin
						state <= F_GAMMA;
						theta_out <= step3;
					end
		F_SIGMA: sigma s4(theta_out,step4);
				 if (clk_en)
					begin
						state <= F_TAU;
						cipher <= step4;
					end
	endcase

assign round_cipher_text = cipher;
		

/*gamma s1(round_plain_text,step1);
tau   s2(gamma_out,step2);
theta s3(tau_out,step3);
sigma s4(theta_out,step4);*/

endmodule