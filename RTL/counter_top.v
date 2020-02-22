module counter_top(
	input clk, rst,
	input enable_count,
	input enable_clock,
	input enable_LFSR,
	
	output PLL_locked_led,
	output [6:0] sseg,
	output [3:0] anode );
	
	wire nrst;
	assign nrst = ~rst;
	
	wire enable_count_negative;
	assign enable_count_negative = ~enable_count;
	
	wire enable_clock_negative;
	assign enable_clock_negative = ~enable_clock;
	
	wire enable_LFSR_negative;
	assign enable_LFSR_negative = ~enable_LFSR;
	
	wire trigger_clock_output;
	wire PLL_clock_output;
	
	wire PLL_locked;
	assign PLL_locked_led = ~PLL_locked;
	
	clock_divider divider_uut(
		.clk(clk),
		.rst(nrst),
		.new_clk(trigger_clock_output)
	);
	
	PLL_clock PLL_uut(
		.clk(clk),
		.rst(nrst),
		.clk_PLL(PLL_clock_output),
		.PLL_locked(PLL_locked)
		);
		
	reg [1:0] clock_selected;
	
	always @ (posedge clk, posedge nrst)
		begin
			if (nrst)
				begin
					clock_selected <= 1'b0;
				end
			else
				begin
					if(enable_clock_negative)
						clock_selected <= {trigger_clock_output, clock_selected[1]};
					else
						clock_selected <= {PLL_clock_output, clock_selected[1]};
				end
		end		
	
	
	
	reg [7:0] mode_wire;
	wire [7:0] LFSR_wire;
	wire [7:0] counter_wire;
	
	reg LFSR_clk, counter_clk;
	
	always @ (posedge clk, posedge nrst)
		begin
			if (nrst)
				begin
					LFSR_clk <= 1'b0;
					counter_clk <= 1'b0;
				end
			else
				begin
					if(enable_LFSR_negative)
						begin
							LFSR_clk <= clock_selected[0];
							counter_clk <= 1'b0;
						end
					else
						begin
							LFSR_clk <= 1'b0;
							counter_clk <= clock_selected[0];
						end
				end
		end
	
	
	
	easy_counter cntr_uut(
			.clk(counter_clk),
			.rst(nrst),
			.enable(enable_count_negative),
			.out_cntr(counter_wire)
		);
		
	LFSR LFSR_uut(
		.clk(LFSR_clk),
		.rst(nrst),
		.out_s(LFSR_wire)
		);
		
	always @ (posedge clk, posedge nrst)
		begin
			if (nrst)
				mode_wire <= 8'd0;
			else
				begin
					if(enable_LFSR_negative)
						mode_wire <= LFSR_wire;
					else
						mode_wire <= counter_wire;
				end
		end

	wire [3:0] ones, tens;
	wire [1:0] hundreds;
	
	binary_to_BCD binary(
		.A(mode_wire),
		.ONES(ones),
		.TENS(tens),
		.HUNDREDS(hundreds)
	);

	
	
	led_controller led_uut(
		.clk(clk), .rst(nrst),
		.first(4'd0),
		.second({2'd0, hundreds}),
		.third(tens),
		.fourth(ones),
		.sseg(sseg),
		.anode(anode));
		
endmodule
	
	
	