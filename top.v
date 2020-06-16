/*
* Project       : Implementation of SAP 1
* Author's Name : Hesham Mohamed Adb El-Hamed Ali
* Date          : 10/2/2020
* File Name     : CPU Top
*
* Inputs of the Module :
* CLK   = Clock
* nCLR  = Clear (0 :clear)
*/
module top (input CLK ,nCLR);

	reg  [7:0] WBUS;
	wire [7:0] DBUS,ABUS,a_accumulator,b_register,out_data,out_alu_result,ram_data;
	wire [3:0] opcode,out_add,address,data;
	wire       Cp,Ep,nLm,nCE,nLi,nEi,nLa,Ea,Su,Eu,nLb,nLo ;

	parameter Zero_State = 8'b0000_0000;

	initial begin
		WBUS <= Zero_State;
	end

	always @(*) begin

		WBUS = (Ep)  ? ABUS : WBUS ;
		WBUS = (Ea)  ? DBUS : WBUS ;
		WBUS = (Eu)  ? out_alu_result : WBUS ;
		WBUS = (!nEi)? out_add : WBUS ;
		WBUS = (!nCE)? ram_data : WBUS ;

	end

	pc Program_Counter (ABUS,Cp,CLK,nCLR,Ep );

	accumulator Accumulator (a_accumulator,DBUS,WBUS,CLK,nLa,Ea );	

	alu ALU_Unit (out_alu_result,a_accumulator,b_register,Su,Eu );
	
	b_register B_Register (b_register,CLK,nLb,WBUS );

	controller Control_Unit (Cp,Ep,nLm,nCE,nLi,nEi,nLa,Ea,Su,Eu,nLb,nLo,CLK,nCLR,opcode );

	instruction_register IS (out_add,opcode,CLK,nLi,nEi,nCLR,WBUS);

	mar MAR (address,data,WBUS[3:0],nLm,CLK );

	out_register Output_Register (out_data,CLK,nLo,WBUS );

	ram RAM (ram_data,nCE,address,data );

endmodule
/***************************************************************************/
module t_top;

reg CLK , nCLR ;

top SAP (CLK ,nCLR);

initial begin 
CLK = 1 ;
forever #50 CLK = ~CLK ;
end

initial begin 

     nCLR = 0 ;
#100 nCLR = 1 ;

end

endmodule
