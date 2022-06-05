/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: key selection 

Description: this module represent the key selection function in the ANUBIS algorithm
this function is the second part of the key schedule

input:
- clk
- reset
- clk_en
- load_key
- evolutioned_key (128 bits)

output:
- round_key
**************************/

module key_selection(
	input clk,
	input reset,
	input encrypt,
	input [3:0] round_num,
	input [3:0] counter,
	input load_key,
	input [127:0] evolutioned_key,
	output [127:0] round_key
);

localparam F_GAMMA = 2'b00;
localparam F_OMEGA = 2'b01;
localparam F_TAU   = 2'b10;
localparam DECRYPT = 2'b11;

wire [127:0] step1,step2,step3,step4;
reg [127:0] gamma_out,omega_out,tau_out,theta_out,selected_key;
reg [1:0] state;
reg clk_en;

always@(posedge clk)
begin
	if (reset)
		clk_en <= 0;
	else
		//if (load_key)
		//	clk_en <= 1;
		//else
			if (counter%4 == 1)
				clk_en <= 1;
			else
				clk_en <= 0;
end

gamma sk1(evolutioned_key,step1);
omega sk2(clk,gamma_out,step2);
tau sk3(omega_out,step3);
theta decrypt (clk,tau_out,step4);

always@(posedge clk)
/* negedge to sample the right value of clk_en and load_text. sampling in negedge instead of posedg will let them time to
to go pu or down after the posedge clk*/
begin
	if (reset)
	begin
		state <= F_GAMMA;
		selected_key <= 0;
	end
	else
	begin
		if (load_key == 1)
		//	state <= F_GAMMA;
		//else
			case(state)
				F_GAMMA: if (clk_en)
							begin
								state <= F_OMEGA;
								gamma_out <= step1;
							end
				F_OMEGA: if (clk_en)
							begin
								state <= F_TAU;
								omega_out <= step2;
							end
				F_TAU: if (clk_en)
						begin
							state <= DECRYPT;
							if (encrypt)
							begin
								selected_key <= step3;
							end
							else
							begin
								if (round_num == 0)
									selected_key <= step3;
								//else if (round_num == 11)
								//	selected_key <= step3;
								else if (round_num == 12)
									selected_key <= step3;
								else
									selected_key <= selected_key;
								tau_out <= step3;
							end
						end
				DECRYPT: if (clk_en)
							begin
								state <= F_GAMMA;
								if (encrypt == 0)
									if (round_num == 0)
										selected_key <= tau_out;
									//else if (round_num == 11)
									//	selected_key <= tau_out;
									else if (round_num < 12)
										selected_key <= step4;
									else if (round_num == 12)
										selected_key <= tau_out;
									else
										selected_key <= selected_key;
							end
			
				/*reserve isn't part of the algorithm. but since there are 3 states in the state machine, and 2 bits needed
				to represent them anyway, we rather control the 4th option then leave it hanging*/
			endcase
	end
end

/*
always@(negedge clk)
begin
	if (reset)
		selected_key <= 0;
	else
	begin
		if (load_key)
			if (encrypt)
				selected_key <= tau_out;
			else
				if (round_num == 0)
					selected_key <= tau_out;
				else if (round_num == 1)
					selected_key <= tau_out;
				else if (round_num < 12)
					selected_key <= step4;//theta_out
				else if (round_num == 12)
					selected_key <= tau_out;
				else
					selected_key <= selected_key;
		else
			selected_key <= selected_key;
	end
end
*/
assign round_key = selected_key;

endmodule