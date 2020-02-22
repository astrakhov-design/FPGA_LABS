module clock_divider(
	input clk, rst,
	output new_clk
	);
	
	parameter N = 25;
	reg [N-1:0] reg_q;
	wire [N-1:0] q_next;
	
	always @ (posedge clk, posedge rst)
		begin
			if (rst)
				reg_q <= 0;
			else
				reg_q <= q_next;
		end
		
	assign q_next = reg_q + 1'b1;
	
	assign new_clk = reg_q[N-1];
	
endmodule