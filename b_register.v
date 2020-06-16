/**
 * Register B
 *
 * Input :
 * CLK    = Clock
 * nLb    = Load to Register B. (0 = Load)
 * WBUS   = The data BUS 
 *
 * Output :
 * ALU    = Data to ALU
 */
module b_register(
					output [7:0] ALU,
					input        CLK,
					input        nLb,
					input  [7:0] WBUS );

	parameter Zero_State = 8'b0000_0000;

    reg [7:0] breg;
  
    initial begin
        breg <= Zero_State;
    end

    assign ALU  = breg;
  
    always @(posedge CLK) begin 
	
		if(!nLb) breg <= WBUS;   // Load Reg B from WBUS
		
		else     breg <= breg;   // Do Nothing
    end
endmodule
