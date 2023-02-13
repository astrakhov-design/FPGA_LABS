//Генератор псевдослучайных чисел от 1 до 255
//Счёт начинается с 0x80 (128)

module LFSR (
	input clk,
	input rst,
	output wire [7:0] out_s
	);
    

    reg [7:0] shift;
    wire [7:0] shift_next;

    always @ (posedge clk, posedge rst) begin
        if (rst)
			begin
				shift <= 8'b1000_0000;
			end
        else
			begin
            shift <= shift_next;
			end
    end
	 
	assign in_s = shift[1] ^ shift[2] ^ shift[3] ^ shift[7];
    assign shift_next = {shift[6:0], in_s};
    assign out_s = shift;
endmodule   