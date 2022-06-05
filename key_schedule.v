module key_schedule(
	input clk,
	input reset,
	input encrypt,
	input load,
	input [3:0] counter,
	input [127:0] key,
	input [127:0] round_constant,
	output [127:0] round_key,
	output [3:0] key_number
);

reg state;
reg [3:0] cycle_number;// number of the "round" when creating the round keys
reg [127:0] evolutioned_key,selected_key;
wire [127:0] step1,step2;
localparam F_KEY_EVOLUTION = 0;
localparam F_KEY_SELECTION = 1;

key_evolution first(clk,reset,counter,~state,cycle_number,key,round_constant,step1);
key_selection second(clk,reset,encrypt,cycle_number,counter,state,evolutioned_key,step2);

always@(negedge clk)
begin
	if (reset)
		state <= 1;
	else //if (reset == 0)
		if (counter == 4'hf)
			state <= state + 1;
	//else
	//	state <= 1'bZ;
end

always@(negedge reset)
begin
	evolutioned_key <= key;
end

always@(negedge clk)//negedge
begin
	if (reset)
		cycle_number <= 0;
	else //if (reset == 0)
	begin	
		if (load)
		begin
			if (counter == 4'hf)
				case(state)
					F_KEY_EVOLUTION:begin
										evolutioned_key <= step1;
										//state <= F_KEY_SELECTION;
									end
					F_KEY_SELECTION: begin
										selected_key <= step2;
										if (cycle_number < 12)
											cycle_number <= cycle_number + 1;
										else
											cycle_number <= 13;
										//state <= F_KEY_EVOLUTION;
									 end
				endcase
		end
	end
	//else
	//	cycle_number <= 1'bZ;
end

assign round_key = selected_key;
//assign round_key = evolutioned_key;
assign key_number = cycle_number;
endmodule