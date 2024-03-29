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
	input [3:0] counter,
	input load_text,
	input [3:0] round_number, // in the 12th round, we don't do sigma
	input [127:0] plain_text,
	input [127:0] round_key,
	output [127:0] round_cipher_text
);

localparam F_GAMMA = 2'b00;
localparam F_TAU   = 2'b01;
localparam F_THETA = 2'b10;
localparam F_SIGMA = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out, tau_out, theta_out,cipher;
reg [1:0] state;
reg [127:0] round_plain_text;
/*
	clk_en will be driven by the ANUBIS top module
	it will rise up every 3 clocks, to let the slowest function,
	theta (which contain a call to ROM memory), time to recover 
	and end it's task
*/
gamma s1(round_plain_text,step1);
tau s2(gamma_out,step2);
theta s3(tau_out,step3);
sigma s4(round_key,theta_out,step4);


always @(negedge clk)
/* negedge to sample the right value of clk_en and load_text. sampling in negedge instead of posedg will let them time to
to go pu or down after the posedge clk*/
begin
	if (reset)
	begin
		state <= F_GAMMA;
		cipher <= 0;
	end	
	else
	begin
		if (load_text == 1)
		begin
			if (counter%4 == 3)
				case(state)
					F_GAMMA: 
								begin
									state <= F_TAU;
									gamma_out <= step1;
								end
					F_TAU:   
								begin
									state <= F_THETA;
									tau_out <= step2;
								end
					F_THETA: 
								begin						
									state <= F_SIGMA;
									if (round_number == 12)
										theta_out <= tau_out;
									else
										theta_out <= step3;
								end
					F_SIGMA: 
								begin
									state <= F_GAMMA;
									cipher <= step4;
								end
				endcase
		end
	end
end
assign round_cipher_text = cipher;
		
always@(negedge clk)
begin
	if (reset)
	begin 
		round_plain_text <= plain_text;
	end
	else
	begin
		if (load_text)
		begin
			if (counter == 4'h0)
				if (round_number == 1)
					round_plain_text <= plain_text;
				else
					round_plain_text <= cipher;
		end
	end
end


endmodule