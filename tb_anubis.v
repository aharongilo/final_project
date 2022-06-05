`timescale 1 ns / 1 ps
module tb_anubis();
reg clk=0;
reg reset;
reg start;
reg [127:0] plain_text;
reg [127:0] key;
reg [127:0] expected_cipher;
wire [127:0] cipher_text;
wire end_flag;

integer test_vector;

always
	#10 clk = ~clk;	

initial
begin
	reset = 1;
	#40 reset = 0;
end

initial
	test_vector = $fopen("anubis_test_vector.txt","rb");

always@(posedge clk)
begin
	if (reset)
		start = 0;
	else
		if (end_flag)
			start = 1;
		else
			start = 0;
end
	
always@(posedge end_flag)
begin
	if(!$feof(test_vector))
	begin
		$fscanf(test_vector,"%032h %032h %032h",key,plain_text,expected_cipher);
	end
	else
		$fclose(test_vector);
end

always@(negedge end_flag)
begin
	$display("time = %03t | plain text = %032h | key = %032h | expected next cipher = %032h | last cipher = %032h",
				$time, plain_text,key,expected_cipher,cipher_text);
end

anubis DUT(
.clk(clk),
.reset(reset),
.start(start),
.plain_text(plain_text),
.key(key),
.cipher_text(cipher_text),
.end_flag(end_flag)
);

endmodule