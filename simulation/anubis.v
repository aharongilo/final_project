module anubis(
	input clk,
	input reset,
	input start,
	input [127:0] plain_text,
	input [127:0] key,
	output [127:0] cipher_text,
	output end_flag
);

/*
need to control 3 state machines (modules), each one contain 4 states. each state take 
approximmatly 4 clock cycles.
the plan is:
create a counter, to count 0-3:
0- load new value to the proccess, get the old value and increment the round number
1- do the key evolutione
2- do the key selection
3- do the round

each of the 3 modules needs to get 2 signals:
- load (key\plain text)
- clock enable
*/

//reg [1:0] state = 0;
reg load = 0;
reg done;
reg [5:0] counter = 0;
reg [3:0] round_num;
reg clk_en_first;
reg clk_en_second;
reg clk_en_third;
reg load_key_evolution,load_key_selection,load_round;
reg [127:0] evolutioned_key,selected_key,cipher;
wire [127:0] step1,step2,step3;

//round constans:
reg [127:0] round_constant1 = 128'ha7d3e671000000000000000000000000;
reg [127:0] round_constant2 = 128'hd0ac4d79000000000000000000000000;
reg [127:0] round_constant3 = 128'h3ac991fc000000000000000000000000;
reg [127:0] round_constant4 = 128'h1e4754bd000000000000000000000000;
reg [127:0] round_constant5 = 128'h8ca57afb000000000000000000000000;
reg [127:0] round_constant6 = 128'h63b8ddd4000000000000000000000000;
reg [127:0] round_constant7 = 128'he5b3c5be000000000000000000000000;
reg [127:0] round_constant8 = 128'ha9880ca2000000000000000000000000;
reg [127:0] round_constant9 = 128'h39df29da000000000000000000000000;
reg [127:0] round_constant10 = 128'h2ba8cb4c000000000000000000000000;
reg [127:0] round_constant11 = 128'h4b22aa24000000000000000000000000;
reg [127:0] round_constant12 = 128'h4170a6f9000000000000000000000000;
reg [127:0] current_round_constant;

/*
localparam key_evolution = 2'b00;
localparam key_selection = 2'b01;
localparam round = 2'b10;
localparam reserve = 2'b11;
*/
localparam reserve = 2'b00;
localparam key_evolution = 2'b01;
localparam key_selection = 2'b10;
localparam round = 2'b11;


key_evolution first(clk,reset,clk_en_first,load_key_evolution,round_num,key,current_round_constant,step1);
key_selection second(clk,reset,clk_en_second,load_key_selection,evolutioned_key,step2);
round third(clk,reset,clk_en_third,load_round,round_num,plain_text,selected_key,step3);

always@(posedge clk)
begin
	if (reset)
	begin
		counter <= 0;
	end
	else
	begin
			if (done)
				counter <= 0;
			else
				counter <= counter + 1;
	end
end

/* 6 bits counter:
1:0 - counter (clock)
(3:)2 - clock enable
5:4 - decide which step get the clock enable
*/
always@(negedge clk)
begin
	if (reset)
	begin
		clk_en_first <= 0;
		clk_en_second <= 0;
		clk_en_third <= 0;
	end
	else
	begin
		if (done)
		begin
			clk_en_first <= 0;
			clk_en_second <= 0;
			clk_en_third <= 0;		
		end
		else
		begin
			if (counter[1:0] == 2'b00)
			begin
				if (counter[5:4] == 2'b01)//00// clock enable for key evolution
				begin
					clk_en_first <= 1;
					clk_en_second <= 0;
					clk_en_third <= 0;
				
				end
				else if (counter[5:4] == 2'b10)//01// clock enable for key selection
				begin
					clk_en_first <= 0;
					clk_en_second <= 1;
					clk_en_third <= 0;
				
				end
				else if (counter[5:4] == 2'b11)//10// clock enable for round
				begin
					clk_en_first <= 0;
					clk_en_second <= 0;
					clk_en_third <= 1;
				
				end
				else
				begin
					clk_en_first <= 0;
					clk_en_second <= 0;
					clk_en_third <= 0;
				end
			end
			else
			begin
				clk_en_first <= 0;
				clk_en_second <= 0;
				clk_en_third <= 0;
			end
		end
	end
end

always@(negedge clk)
begin
	if (reset)
	begin
		load_key_evolution <= 0;
		load_key_selection <= 0;
		load_round <= 0;
		load <= 0;
	end
	else
	begin
		if (done)
		begin
			load_key_evolution <= 0;
			load_key_selection <= 0;
			load_round <= 0;
			load <= 0;		
		end
		else
		begin
			if (counter[3:0] == 2'b00)
			begin
				if (counter[5:4] == 2'b01)//00// load for key evolution
				begin
					load_key_evolution <= 1;
					load_key_selection <= 0;
					load_round <= 0;
					load <= 1;
				end
				else if (counter[5:4] == 2'b10)//01// load for key selection
				begin
					load_key_evolution <= 0;
					load_key_selection <= 1;
					load_round <= 1;
					load <= 1;
				end
				else if (counter[5:4] == 2'b11)//10// load for round
				begin
					load_key_evolution <= 0;
					load_key_selection <= 0;
					load_round <= 1;
					load <= 1;
				end
				else if (counter[5:4] == 2'b00)//11// load for reserve
				begin
					load_key_evolution <= 1;
					load_key_selection <= 0;
					load_round <= 0;
					load <= 1;
				end
				else
				begin
					load_key_evolution <= 0;
					load_key_selection <= 0;
					load_round <= 0;
					load <= 0;
				end
			end
			else
			begin
				load_key_evolution <= 0;
				load_key_selection <= 0;
				load_round <= 0;
				load <= 0;
			end
		end
	end
end


/*proccess for round constant*/
always@(negedge clk)
begin
	if (reset)
	begin
		
	end
	else
	begin
		case(round_num)
				4'd1: current_round_constant <= round_constant1;
				4'd2: current_round_constant <= round_constant2;
				4'd3: current_round_constant <= round_constant3;
				4'd4: current_round_constant <= round_constant4;
				4'd5: current_round_constant <= round_constant5;
				4'd6: current_round_constant <= round_constant6;
				4'd7: current_round_constant <= round_constant7;
				4'd8: current_round_constant <= round_constant8;
				4'd9: current_round_constant <= round_constant9;
				4'd10: current_round_constant <= round_constant10;
				4'd11: current_round_constant <= round_constant11;
				4'd12: current_round_constant <= round_constant12;
				default: current_round_constant <= round_constant1;
			endcase
	end
end

always@(posedge clk)
begin
	if (reset)
	begin
		done <= 1;
	end
	else if (done == 1)
	begin
		if (start)
			done <= 0;
		else
			done <= 1;
	end
	else 
	begin
		if (round_num > 12)
			done <= 1;
		else
			done <= 0;
	end
end
/*state machine for the algorithm*/

always@(posedge clk)
begin
	if (reset)
	begin
		/*reset all the values*/
		//state = 0;
		round_num <= 0;//0
		//done <= 1;
	end 
	else
	begin
		if (done)
		begin
			if (start)
				round_num <= 0;//0
		end
		else
		begin	
			if (load)
			begin
				case(counter[5:4])//state
					key_evolution: //if (load)
								   begin/*relevant register get's a value*/
									
								   end
					key_selection: //if (load)
								   begin/*relevant register get's a value*/
									evolutioned_key <= step1;
								   end
					round: //if (load)
						   begin/*relevant register get's a value*/
							selected_key <= step2;
						   end
					reserve: begin /*if 12th round, the output register get's a value, and done is up*/
								if (round_num == 12)
								begin
									cipher <= step3;
									//done <= 1;
								end
								//else
									//done <= 0;
								round_num = round_num + 1;
							 end
				endcase
			//state <= state + 1;
			end
		end
	end
end

assign end_flag = done;
assign cipher_text = cipher;

endmodule