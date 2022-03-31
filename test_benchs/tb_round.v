`timescale 1ns / 1ps
module tb_round();
/*	input clk,
	input clk_en,
	input load_text,
	input [127:0] round_plain_text,
	input [127:0] round_key,
	output [127:0] round_cipher_text*/

reg clk = 1'b0;
reg clk_en = 1'b0;
reg load_text = 1'b0;
reg [127:0] in_text,in_key,expected_cipher;
wire cipher;
reg [3:0] counter = 4'b0000;

integer test_vector, file_read

always
	#10 clk = ~clk;
	
always@(posedge clk)
	begin
		counter = counter + 1;
		if (counter==13)
			begin
				counter = 0;
			end
		else if (counter%3==0)
			begin
				clk_en = 1;
				if (counter == 12)
					load_text == 1;
			end
		else
			begin
				clk_en = 0;
				load_text = 0;
			end
	end
	
initial
	test_vector = $fopen("round_test_vector.txt","r");
	
always@(posedge clk)
	begin
		 if (!$feof(test_vector))
			if (counter == 12)
					begin
						file_read = $fscanf(test_vector,"%032h %032h %032h\n",in_text,in_key,expected_cipher);
					end
		 else
			$fclose(test_vector);
	end

always@(posedge load_text)
	$display("time = %03t | text = %32h | key = %32h | expected new cipher = %32h | last cipher = %32h",
			   $time,in_text,in_key,expected_cipher,cipher)
	


round DUT(
.clk(clk),
.clk_en(clk_en),
.load_text(load_text),
.round_plain_text(in_text),
.round_key(in_key),
.round_cipher_text(cipher)
);

endmodule