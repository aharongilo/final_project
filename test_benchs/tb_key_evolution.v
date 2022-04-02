`timescale 1 ns / 1 ps

module tb_key_evolution();

reg clk = 0;
reg clk_en;
reg reset;
reg load_key;
reg [127:0] key,round_constant,expected;
wire [127:0] evolutioned_key_out;
reg [3:0] counter = 4'b0000;

integer test_vector;

always
	#10 clk = ~clk;

initial
	reset = 1;
	#30 reset = 0;

always@(posedge clk)
begin 
	/*if (counter == 13)
		counter = 0;
	else*/ 
		counter = counter+1;
end

always@(posedge clk)
begin
		if (counter%4 == 0)
			clk_en = 1;
		else
			clk_en = 0;
end

always@(posedge clk)
begin
	if (counter == 15)
		load_text = 1;
	else
		load_text = 0;
end

initial
	test_vector = $fopen("<enter file name here>","rb");

endmodule