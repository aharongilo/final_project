/*************************
Final project 2022 - ANUBIS algorithm on FPGA 
Authors: Yosef Berger, Aharon Gilo

Module name: omega

Description:
this moduel represent the omega function of the algorithm.
the omega function extract the round key for every round, 
from the key we inserted to the algorithm.
we can insert the algorithm key with size of Nx4 (4<=N<=10)
matrix with GF(2^8) elements.
the function do matrix multiplication between the inserted key 
and a based on [N^4,5,N] MDS code generator matrix:
	1   1   1   ... 1
	1   2   2^2 ... 2^(N-1)
	1   6   6^2 ... 6^(N-1)
	1   8   8^2 ... 8^(N-1)
in our case, N=4, therefor, the matrix will be:
	1 1  1  1
    1 2  4  8 
    1 6 24 d8
    1 8 40 200
the equation is:  extract key = V*key
extract key is a mtrix with size of 4x4.
in addition, the multiplying above GF(2^8) will be executed by block ROM module made using the 
VIVADO software of the Xilinx company.

input:
- clk
- key (128 bits)

output:
- extract_key (128 bits)
**************************/

module omega
(
	input clk,
	input [127:0] key,
	output [127:0] extract_key
);
reg [127:0] mult_result = 0;
// we will make wires to conect with the block rom modules. for example: mkey44 mean multply by 4, the 4 element in the matrix column.
wire [7:0] mkey21, mkey22, mkey23, mkey24, mkey41, mkey42, mkey43, mkey44, mkey81, mkey82, mkey83, mkey84, mkey61, mkey62, mkey63, mkey64, mkey361, mkey362, mkey363, mkey364, mkey2161, mkey2162, mkey2163, mkey2164, mkey85, mkey86, mkey87, mkey88, mkey641, mkey642, mkey643, mkey644, mkey5121, mkey5122, mkey5123, mkey5124;
// multiplication second row in V matrix (the first row is all 1) 
mult_rom C2R1M2 (clk,{3'b000,key[95:88]},mkey21); //column 2 of key matrix, multiply by 2
mult_rom C2R2M2 (clk,{3'b000,key[87:80]},mkey22);
mult_rom C2R3M2 (clk,{3'b000,key[79:72]},mkey23);
mult_rom C2R4M2 (clk,{3'b000,key[71:64]},mkey24);

mult_rom C3R1M4 (clk,{3'b001,key[63:56]},mkey41);
mult_rom C3R2M4 (clk,{3'b001,key[55:48]},mkey42);
mult_rom C3R3M4 (clk,{3'b001,key[47:40]},mkey43);
mult_rom C3R4M4 (clk,{3'b001,key[39:32]},mkey44);

mult_rom C4R1M8 (clk,{3'b011,key[31:24]},mkey81);
mult_rom C4R2M8 (clk,{3'b011,key[23:16]},mkey82);
mult_rom C4R3M8 (clk,{3'b011,key[15:8]},mkey83);
mult_rom C4R4M8 (clk,{3'b011,key[7:0]},mkey84);

// multiplication third row in V matrix 
mult_rom C2R1M6 (clk,{3'b010,key[95:88]},mkey61);
mult_rom C2R2M6 (clk,{3'b010,key[87:80]},mkey62);
mult_rom C2R3M6 (clk,{3'b010,key[79:72]},mkey63);
mult_rom C2R4M6 (clk,{3'b010,key[71:64]},mkey64);

mult_rom C3R1M36 (clk,{3'b100,key[63:56]},mkey361);
mult_rom C3R2M36 (clk,{3'b100,key[55:48]},mkey362);
mult_rom C3R3M36 (clk,{3'b100,key[47:40]},mkey363);
mult_rom C3R4M36 (clk,{3'b100,key[39:32]},mkey364);

mult_rom C4R1M216 (clk,{3'b110,key[31:24]},mkey2161);
mult_rom C4R2M216 (clk,{3'b110,key[23:16]},mkey2162);
mult_rom C4R3M216 (clk,{3'b110,key[15:8]},mkey2163);
mult_rom C4R4M216 (clk,{3'b110,key[7:0]},mkey2164);

// multiplication fourth row in V matrix 
mult_rom C2R1M8 (clk,{3'b011,key[95:88]},mkey85);
mult_rom C2R2M8 (clk,{3'b011,key[87:80]},mkey86);
mult_rom C2R3M8 (clk,{3'b011,key[79:72]},mkey87);
mult_rom C2R4M8 (clk,{3'b011,key[71:64]},mkey88);

mult_rom C3R1M64 (clk,{3'b101,key[63:56]},mkey641);
mult_rom C3R2M64 (clk,{3'b101,key[55:48]},mkey642);
mult_rom C3R3M64 (clk,{3'b101,key[47:40]},mkey643);
mult_rom C3R4M64 (clk,{3'b101,key[39:32]},mkey644);

mult_rom C4R1M512 (clk,{3'b111,key[31:24]},mkey5121);
mult_rom C4R2M512 (clk,{3'b111,key[23:16]},mkey5122);
mult_rom C4R3M512 (clk,{3'b111,key[15:8]},mkey5123);
mult_rom C4R4M512 (clk,{3'b111,key[7:0]},mkey5124);

always@(mkey21 or mkey22 or mkey23 or mkey24 or mkey41 or mkey42 or mkey43 or mkey44 or mkey81 or mkey82 or mkey83 or mkey84 or mkey61 or mkey62 or mkey63 or mkey64 or mkey361 or mkey362 or mkey363 or mkey364 or mkey2161 or mkey2162 or mkey2163 or mkey2164 or mkey85 or mkey86 or mkey87 or mkey88 or mkey641 or mkey642 or mkey643 or mkey644 or mkey5121 or mkey5122 or mkey5123 or mkey5124)
begin
	mult_result[127:120] = (key[127:120] ^ key[95:88] ^ key[63:56] ^ key[31:24]);
	mult_result[119:112] = (key[119:112] ^ key[87:80] ^ key[55:48] ^ key[23:16]);
	mult_result[111:104] = (key[111:104] ^ key[79:72] ^ key[47:40] ^ key[15:8]);
	mult_result[103:96]  = (key[103:96] ^ key[71:64] ^ key[39:32] ^ key[7:0]);

	mult_result[95:88]   = (key[127:120] ^ mkey21 ^ mkey41 ^ mkey81);
	mult_result[87:80]   = (key[119:112] ^ mkey22 ^ mkey42 ^ mkey82);
	mult_result[79:72]   = (key[111:104] ^ mkey23 ^ mkey43 ^ mkey83);
	mult_result[71:64]   = (key[103:96] ^ mkey24 ^ mkey44 ^ mkey84);

	mult_result[63:56]   = (key[127:120] ^ mkey61 ^ mkey361 ^ mkey2161);
	mult_result[55:48]   = (key[119:112] ^ mkey62 ^ mkey362 ^ mkey2162);
	mult_result[47:40]   = (key[111:104] ^ mkey63 ^ mkey363 ^ mkey2163);
	mult_result[39:32]   = (key[103:96] ^ mkey64 ^ mkey364 ^ mkey2164);

	mult_result[31:24]   = (key[127:120] ^ mkey85 ^ mkey641 ^ mkey5121);
	mult_result[23:16]   = (key[119:112] ^ mkey86 ^ mkey642 ^ mkey5122);
	mult_result[15:8]    = (key[111:104] ^ mkey87 ^ mkey643 ^ mkey5123);
	mult_result[7:0]     = (key[103:96] ^ mkey88 ^ mkey644 ^ mkey5124);
end

assign extract_key = mult_result;

endmodule