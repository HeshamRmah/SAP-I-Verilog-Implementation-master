/**
* Random Access Memory (RAM) - 16 Bytes (8 bits x 16 address)
*
* Input :
* nCE      = Enabled the output (0 = Read from RAM)
* address  = Address from the MAR
* data     = data from the MAR
*
* Output :
* ram_data = Ram output to WBUS.
*/
module ram (
			output reg [7:0] ram_data,
			input            nCE,
			input      [3:0] address,
			input      [3:0] data );
  
	parameter High_Impedance = 8'bzzzz_zzzz;
  
    reg [7:0] ram [0:15]; // Memory array
    
    initial begin
        ram[0]  = 8'b0000_1001; // LDA 9H
        ram[1]  = 8'b0001_1010; // ADD AH
        ram[2]  = 8'b0001_1011; // ADD BH
        ram[3]  = 8'b0010_1100; // SUB CH
        ram[4]  = 8'b1110_0000; // OUT
        ram[5]  = 8'b1111_xxxx; // HLT
        ram[6]  = 8'bxxxx_xxxx; // XX
        ram[7]  = 8'bxxxx_xxxx; // XX
        ram[8]  = 8'bxxxx_xxxx; // XX
        ram[9]  = 8'b0001_0000; // 10H (16)
        ram[10] = 8'b0001_0100; // 14H (20)
        ram[11] = 8'b0001_1000; // 18H (24)
        ram[12] = 8'b0010_0000; // 20H (32)
        ram[13] = 8'b0000_0000; // 00H 
        ram[14] = 8'b0000_0000; // 00H
        ram[15] = 8'b0000_0000; // 00H
    end
	
    always @(*) begin

		//ram[address] = data ;

		if(!nCE) ram_data <= ram[address] ;  // Ouput the data at address from WBUS
		
		else     ram_data <= High_Impedance ;
    end
	
endmodule
