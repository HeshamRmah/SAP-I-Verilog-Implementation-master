/*
* Accumulator
*
* Input :
* WBUS   = Data from WBUS
* CLK    = Clock
* nLa    = Load Register A (Write). 0 - Write
* Ea     = Write to WBUS.
*
* Output :
* out    = To the WBUS
* ALU    = Data to ALU
*/
module accumulator(
					output [7:0] ALU,
					output [7:0] out,
					input  [7:0] WBUS,
					input        CLK,
					input        nLa,
					input        Ea );
  
	parameter High_Impedance = 8'bzzzz_zzzz;
	parameter Zero_State     = 8'b0000_0000;
	
    reg  [7:0] accreg;
    
    initial begin
        accreg <= Zero_State;
    end
    
    assign out = (Ea) ? accreg : High_Impedance;
    assign ALU = accreg;
    
    always @(posedge CLK) begin

        if (!nLa) accreg <= WBUS;    // Load from WBUS
		
        else      accreg <= accreg;  // Do Nothing
    end

endmodule
/***************************************************************************/
module t_accumulator ;

wire [7:0] ALU;
wire [7:0] out;
reg  [7:0] WBUS;
reg        CLK;
reg        nLa,Ea ;

accumulator Accumulator (ALU,out,WBUS,CLK,nLa,Ea);

initial begin 
CLK = 0 ;
forever #50 CLK = ~CLK ;
end

initial begin 

     nLa = 1 ; Ea = 0 ; WBUS = 8'd5;
#100 nLa = 0 ; Ea = 0 ; WBUS = 8'd5;
#100 nLa = 0 ; Ea = 0 ; WBUS = 8'd5;
#100 nLa = 0 ; Ea = 0 ; WBUS = 8'd7;
#100 nLa = 0 ; Ea = 1 ; WBUS = 8'd9;
#100 nLa = 0 ; Ea = 1 ; WBUS = 8'd9;

end

endmodule
