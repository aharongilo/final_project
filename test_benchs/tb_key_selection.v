`timescale 1 ns / 1 ps
module tb_key_selection();

reg clk = 0;
reg clk_en;
reg reset=1;
reg load_key;
reg [127:0] in_key, expected_result;
wire [127:0] out;
reg [3:0] counter = 4'b0000;

integer test_vector;

always
	#10 clk = ~clk;
	
initial
	#30 reset = 0;
	
always@(posedge clk)
begin  
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
		load_key = 1;
	else
		load_key = 0;
end

initial
	test_vector = $fopen("key_selection_test_vector.txt","rb");

always@(posedge load_key)
begin
	 if (!$feof(test_vector))
		$fscanf(test_vector,"%032h %032h\n",in_key,expected_result);
	 else
		$fclose(test_vector);
end

always@(posedge load_key)
	$display("time = %03t | key = %32h | expected evolutioned_key = %32h | last evolutioned_key = %32h",
			   $time,in_key,expected_result,out);


key_selection DUT (
.clk(clk),
.clk_en(clk_en),
.reset(reset),
.load_key(load_key),
.evolutioned_key(in_key),
.round_key(out)
);
endmodule
