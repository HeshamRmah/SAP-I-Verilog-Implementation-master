/**
* Input and MAR (MAR)
*
* Input :
* WBUS    = the Data from the WBUS.
* nLm     = Enable MAR to Load WBUS data (0 = enable)
* CLK     = Clock
*
* Output :
* address = Address to the RAM
* data    = data to the RAM
*/
module mar (
			output reg [3:0] address,
			output reg [3:0] data,
			input      [3:0] WBUS,
			input            nLm ,
			input            CLK );		
	
	always @ (posedge CLK) begin
	
		if (!nLm) begin
		    address <= WBUS ;
	        data    <= WBUS ;
		end
		
	    else begin
			address <= address ;
			data    <= data ;
		end
	end
endmodule
