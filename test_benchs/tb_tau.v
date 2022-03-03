
`timescale 1 ns / 1 ps
module tb_tau();

reg [127:0] matrix_in;
reg [127:0] matrix_out;
reg [127:0] expected;

// example for in matrix:  128'h01020304050607080910111213141516
// example for out matrix: 128'h01050913020610140307111504081216



tau DUT(
.matrix(matrix_in),
.T_matrix(matrix_out)
);

endmodule
