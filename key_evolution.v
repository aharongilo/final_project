/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: key evolution (Psi)

Description: this module represent the key evolution function in the ANUBIS algorithm
this function is the first part of the key schedule

input:
- clk
- reset
- clk_en
- load key
- round counstant
- key (128 bits)

output:
- evolutioned_key
**************************/
module key_evolution(
	input clk,
	input reset,
	input clk_en,
	input load_key,
	input [127:0] key,
	input [127:0] round_constant,
	output [127:0] evolutioned_key
);

localparam F_GAMMA = 2'b00;
localparam F_PI   = 2'b01;
localparam F_THETA = 2'b10;
localparam F_SIGMA = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out, pi_out, theta_out,out_psi,key_in;
reg [1:0] state;

gamma ps1(key_in,step1);
pi ps2(gamma_out,step2);
theta ps3(clk,pi_out,step3);
sigma ps4(psi,theta_out,step4);

always@(negedge clk)
/* negedge to sample the right value of clk_en and load_text. sampling in negedge instead of posedg will let them time to
to go pu or down after the posedge clk*/
if (reset)
begin
	state <= F_GAMMA;
	evolutioned_key <= 0;
end
else
begin
	if (load_key == 1)
		state <= F_GAMMA;
	else
		case(state)
			F_GAMMA: if (clk_en)
						begin
							state <= F_PI;
							gamma_out <= step1;
						end
			F_PI: if (clk_en)
					begin
						state <= F_THETA;
						pi_out <= step2;
					end
			F_THETA: if (clk_en)
						begin
							state <= F_SIGMA;
							theta_out <= step3
						end
			F_SIGMA: if (clk_en)
						begin
							state <= F_GAMMA
							out_psi <= step4
						end
		endcase
end

assign evolutioned_key = out_psi;

endmodule