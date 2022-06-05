`timescale 1 ns / 1 ps

module tb_key_evolution();

reg clk = 0;
reg clk_en;
reg reset=1;
reg load_key;
reg [3:0] round_num=1;
reg [127:0] key,round_constant,expected_result;
wire [127:0] evolutioned_key_out;
reg [3:0] counter = 4'b0000;

integer test_vector;

always
	#10 clk = ~clk;

initial
	//reset = 1;
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
		load_key = 1;
	else
		load_key = 0;
end

initial
	test_vector = $fopen("key_evolution_test_vector.txt","rb");
	
always@(posedge load_key)
	begin
		 if (!$feof(test_vector))
			$fscanf(test_vector,"%032h %032h %032h\n",key,round_constant,expected_result);
		 else
			$fclose(test_vector);
			//round_num <= 2;
	end

always@(posedge load_key)
	$display("time = %03t | key = %32h | round_constant = %32h | expected evolutioned_key = %32h | last evolutioned_key = %32h",
			   $time,key,round_constant,expected_result,evolutioned_key_out);
			   


key_evolution DUT(
.clk(clk),
.clk_en(clk_en),
.reset(reset),
.round_num(round_num),
.load_key(load_key),
.key(key),
.round_constant(round_constant),
.evolutioned_key(evolutioned_key_out)
);

endmodule