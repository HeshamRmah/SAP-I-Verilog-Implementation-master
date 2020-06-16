/**
 * 8-bit ALU (ADD,SUBTRACT)
 *
 * Input :
 * a_accumulator  = data From Accumulator
 * b_register     = data From Register B.
 * Su             = Operation: 0 = Add, 1 = Sub
 * Eu             = Enable output to WBUS
 *
 * Output :
 * out_alu_result = Data to BUS.
 */
module alu (
			output [7:0]  out_alu_result,
			input  [7:0]  a_accumulator,
			input  [7:0]  b_register,
			input         Su,         // 0: ADD, 1: SUBTRACT
			input         Eu );

	parameter High_Impedance = 8'bzzzz_zzzz;
	parameter Zero_State     = 8'b0000_0000;
			
   reg [7:0] result ;

   initial begin
		result <= Zero_State;
   end

   assign out_alu_result = (Eu) ? result : High_Impedance;
   
   always @(*) begin
   
		result = Su ? (a_accumulator - b_register) : (a_accumulator + b_register);

   end
   
endmodule
/***************************************************************************/
module t_alu ;

wire [7:0] out_alu_result;
reg  [7:0] a_accumulator;
reg  [7:0] b_register;
reg        Su;
reg        Eu;

alu ALU (out_alu_result,a_accumulator,b_register,Su,Eu);

initial begin 

     a_accumulator = 8'd10 ; b_register = 8'd2 ; Su = 1'b0; Eu = 1'b0;
#100 a_accumulator = 8'd10 ; b_register = 8'd5 ; Su = 1'b0; Eu = 1'b0;
#100 a_accumulator = 8'd10 ; b_register = 8'd5 ; Su = 1'b0; Eu = 1'b1;
#100 a_accumulator = 8'd12 ; b_register = 8'd1 ; Su = 1'b0; Eu = 1'b1;
#100 a_accumulator = 8'd12 ; b_register = 8'd2 ; Su = 1'b0; Eu = 1'b0;
#100 a_accumulator = 8'd10 ; b_register = 8'd5 ; Su = 1'b1; Eu = 1'b0;
#100 a_accumulator = 8'd10 ; b_register = 8'd5 ; Su = 1'b1; Eu = 1'b1;
#100 a_accumulator = 8'd10 ; b_register = 8'd2 ; Su = 1'b1; Eu = 1'b1;
#100 a_accumulator = 8'd7  ; b_register = 8'd2 ; Su = 1'b1; Eu = 1'b1;
#100 a_accumulator = 8'd6  ; b_register = 8'd7 ; Su = 1'b1; Eu = 1'b1;
#100 a_accumulator = 8'd8  ; b_register = 8'd8 ; Su = 1'b1; Eu = 1'b1;

end

endmodule
