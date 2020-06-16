/**
* Ouput Register
*
* Input :
* CLK  = Clock
* nLo  = Load data from WBUS . (0 = Load)
* WBUS = To Data bus
*
* Output :
* out_data = Output data
*/
module out_register (
					output [7:0] out_data,
					input        CLK,
					input        nLo,
					input  [7:0] WBUS );

	parameter Zero_State = 8'b0000_0000;

	reg [7:0] out_reg;
  
	assign out_data = out_reg;

	initial begin
		out_reg <= Zero_State;
	end

	always @(posedge CLK) begin
	
		if(!nLo) out_reg <= WBUS;  // Load from WBUS
		
		else ; // Do Nothing
	end
endmodule
