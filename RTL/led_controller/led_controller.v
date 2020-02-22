//LED controller for PS2 controller
//date: 01.10.2020
module led_controller(
	input clk, rst,
	input [3:0] first,
	input [3:0] second,
	input [3:0] third,
	input [3:0] fourth,
	
	output [6:0] sseg,
	output [3:0] anode );
	
	localparam N = 18;
	reg [N-1:0] reg_q;
	wire [N-1:0] q_next;
	
	reg [3:0] x1_axis, x2_axis, y1_axis, y2_axis;
		
	always @ (posedge clk, posedge rst) begin
		if (rst)
			reg_q <= 0;
		else
			reg_q <= q_next;
	end
	
	assign q_next = reg_q + 1'b1;
	
	always @ (negedge reg_q[N-1], posedge rst) begin
		if (rst)
			begin
				x1_axis <= 0;
				x2_axis <= 0;
				y1_axis <= 0;
				y2_axis <= 0;
			end
		else
			begin
				x1_axis <= first;
				x2_axis <= second;
				y1_axis <= third;
				y2_axis <= fourth;
			end
	end
	
	reg [3:0] anode_reg;
	reg [3:0] hex_in;
	
	always @ * begin
        case (reg_q[N-1:N-2])
            2'b00:
				begin
					anode_reg = 4'b01_11;
					hex_in = x1_axis;
				end
            2'b01: 
				begin
					anode_reg = 4'b10_11;
					hex_in = x2_axis;
				end
            2'b10:
				begin
					anode_reg = 4'b11_01;
					hex_in = y1_axis;
				end
            default: 
				begin
					anode_reg = 4'b11_10;
					hex_in = y2_axis;
				end
        endcase
    end
	
	reg [6:0] sseg_reg;
	
	always @ * begin
        case (hex_in)
            4'h0: sseg_reg = 7'b0000_001; //0
            4'h1: sseg_reg = 7'b1001_111; //1
            4'h2: sseg_reg = 7'b0010_010; //2
            4'h3: sseg_reg = 7'b0000_110; //3
            4'h4: sseg_reg = 7'b1001_100; //4
            4'h5: sseg_reg = 7'b0100_100; //5
            4'h6: sseg_reg = 7'b0100_000; //6
            4'h7: sseg_reg = 7'b0001_111; //7
            4'h8: sseg_reg = 7'b0000_000; //8
            4'h9: sseg_reg = 7'b0000_100; //9
        //латиница
            4'hA: sseg_reg = 7'b0001_000; //A
            4'hB: sseg_reg = 7'b1100_000; //B
            4'hC: sseg_reg = 7'b0110_001; //C
            4'hD: sseg_reg = 7'b1000_010; //D
            4'hE: sseg_reg = 7'b0110_000; //E
            4'hF: sseg_reg = 7'b0111_000; //F
			default: sseg_reg = 7'b1111_110;
		endcase
	end
	
	assign sseg = sseg_reg;
	assign anode = anode_reg;

endmodule
	