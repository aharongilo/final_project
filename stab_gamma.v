module stab(
	input [127:0] data_in,
	output reg [127:0] data_out,
	input clk
);

always@(posedge clk)
	case(data_in)
		128'h0000000000000000: data_out = 128'ha7a7a7a7a7a7a7a7;
		128'h1111111111111111: data_out = 128'hd3d3d3d3d3d3d3d3;
		128'h2222222222222222: data_out = 128'he6e6e6e6e6e6e6e6;
		128'h3333333333333333: data_out = 128'h7171717171717171;
		128'h4444444444444444: data_out = 128'hd0d0d0d0d0d0d0d0;
		128'h5555555555555555: data_out = 128'hacacacacacacacac;
		128'h6666666666666666: data_out = 128'h4d4d4d4d4d4d4d4d;
		128'h7777777777777777: data_out = 128'h7979797979797979;
		128'h8888888888888888: data_out = 128'h3a3a3a3a3a3a3a3a;
		128'h9999999999999999: data_out = 128'hc9c9c9c9c9c9c9c9;
		128'haaaaaaaaaaaaaaaa: data_out = 128'h9191919191919191;
	endcase
endmodule