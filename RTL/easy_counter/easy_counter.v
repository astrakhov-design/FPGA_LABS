//Author: Aleksander Strakhov
//Date: 01.28.2020
//Description: counter module for FPGA labs 1-4

module easy_counter(
	input clk, rst,
	input enable,
	output reg [7:0] out_cntr);
	
	always @ (posedge clk, posedge rst)
		begin
			if (rst)
				out_cntr <= 0;
			else
				begin
					if (enable)
						out_cntr <= out_cntr + 1'b1;
					else
						out_cntr <= out_cntr - 1'b1;
				end
		end
endmodule