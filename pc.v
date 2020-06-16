/**
* 4-Bit Program Counter
*
* Input :
* Cp   = Increment Count (1= Increment)
* CLK  = Clock
* nCLR = Clear (0 = Clear)
* Ep   = Enable output to WBUS.
*
* Output :
* pc   = Program Counter
*/
module pc (
			output [7:0] pc,
			input        Cp,
			input        CLK,
			input        nCLR,
			input        Ep );
			
	parameter High_Impedance = 8'bzzzz_zzzz;
	parameter Zero_State     = 4'b0000;
  
    reg    [3:0] count;

	initial begin
		count <= Zero_State;
	end
      
	assign pc = (Ep) ? {Zero_State,count} : High_Impedance;
    
    always @(posedge CLK) begin
	
        if(!nCLR)   count <= Zero_State; // clear
		
        else if(Cp) count <= (count == 4'd15) ? Zero_State : count + 1'b1; // Increment Count till 15
		
        else        count <= count;     // Do Nothing
		
    end
endmodule
