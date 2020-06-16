/*
 * Control Unit (Controller)
 *
 * Input :
 * CLK    = Clock
 * nCLR   = Clear (0 :clear)
 * opcode = From Instruction Register
 *
 * Total Output of (12) Control Signals:
 * Cp     = Increment PC
 * Ep     = Enable PC ouput to WBUS (1 = Enable)
 * nLm    = Enable MAR to Load WBUS data (0 = enable)
 * nCE    = Enable output of RAM data to WBUS (0 = enable)
 * nLi    = Load Instruction Register from WBUS (0 = load)
 * nEi    = Enable ouput of address from Instruction Register to lower 4 bits of WBUS (0 = enable)
 * nLa    = Load data into the accumulator from WBUS (0 = load)
 * Ea     = Enable ouput of accumulator to WBUS (1 = enable)
 * Su     = ALU operation (0 = Add, 1 = Subtract)
 * Eu     = Enable output of ALU to WBUS (1 = enable)
 * nLb    = Load data into Register B from WBUS (0 = load)
 * nLo    = Load data into Output Register (0 = load) 
 */
module controller (
					output      Cp,
					output      Ep,
					output      nLm,
					output      nCE,
					output      nLi,
					output      nEi,
					output      nLa,
					output      Ea,
					output      Su,
					output      Eu,
					output      nLb,
					output      nLo,
					input       CLK,
					input       nCLR,
					input [3:0] opcode );

    // T-States
    parameter T1    = 6'b000001;
    parameter T2    = 6'b000010;
    parameter T3    = 6'b000100;
    parameter T4    = 6'b001000;
    parameter T5    = 6'b010000;
    parameter T6    = 6'b100000;
	
    // Instruction OP_Code
    parameter LDA    = 4'b0000;
    parameter ADD    = 4'b0001;
    parameter SUB    = 4'b0010;
    parameter OUT    = 4'b1110;
    parameter HLT    = 4'b1111;

    // Ring Counter
    wire [5:0] state; 
    ring_counter RC (state,CLK,nCLR); 
	
	// Control Signals
	reg [11:0] CON ;
	assign {Cp,Ep,nLm,nCE,nLi,nEi,nLa,Ea,Su,Eu,nLb,nLo} = CON;

    initial begin
    /*  Cp    <= 0;  nLi   <= 1;  Su    <= 0;
        Ep    <= 1;  nEi   <= 1;  Eu    <= 0;
        nLm   <= 0;  nLa   <= 1;  nLb   <= 1;
		nCE   <= 1;  Ea    <= 0;  nLo   <= 1;  */
		CON <= 12'h5E3 ;
      end
      
      always @(state,opcode,nCLR) begin

        if(!nCLR) begin
            // Reset all the Control Signal
	    /*  Cp    <= 0;  nLi   <= 1;  Su    <= 0;
            Ep    <= 1;  nEi   <= 1;  Eu    <= 0;
        	nLm   <= 0;  nLa   <= 1;  nLb   <= 1;
			nCE   <= 1;  Ea    <= 0;  nLo   <= 1;  */
			CON <= 12'h5E3 ;
        end
        else begin
            // Running Mode (Active)
            case (state)
			
                T1: begin
					// Ouput the PC, pull data from memory and store in IR.
					CON <= 12'h5E3 ;
                end
                  
                T2: begin
                    // Clear previous signals
					CON <= 12'hBE3 ;
                end
				
				T3: begin
                    // Clear previous signals
					CON <= 12'h263 ;
                end
				
                T4: begin
                    // the Control Signals Differs depending on opcode
                    case(opcode)
					
                        LDA: begin
                            // LDA (Load the Output of RAM to Accumulator)
							CON <= 12'h1A3 ;
                        end
                        
                        ADD: begin
                            // ADD (Add the Output of RAM to Accumulator)
							CON <= 12'h1A3 ;
                        end
                        
                        SUB: begin
                            // SUB (Subtract the Output of RAM from Accumulator)
							CON <= 12'h1A3 ;
                        end
                        OUT: begin
                            // OUT (Output data from Accumulator)
							CON <= 12'h3F2 ;
                        end
                        HLT: begin
                            // HTL (Do Nothing)
							CON <= 12'h3E3 ;
                        end
                        default: CON <= 12'h3E3 ;
                    endcase
                end
                
				T5: begin
                    // the Control Signals Differs depending on opcode
                    case(opcode)
					
                        LDA: begin
                            // LDA (Load the Output of RAM to Accumulator)
							CON <= 12'h2C3 ;
                        end
                        
                        ADD: begin
                            // ADD (Add the Output of RAM to Accumulator)
							CON <= 12'h2E1 ;
                        end
                        
                        SUB: begin
                            // SUB (Subtract the Output of RAM from Accumulator)
							CON <= 12'h2E1 ;
                        end
                        OUT: begin
                            // OUT (Output data from Accumulator)
							CON <= 12'h3E3 ;
                        end
                        HLT: begin
                            // HTL (Do Nothing)
							CON<= 12'h3E3 ;
                        end
                        default: CON <= 12'h3E3 ;
                    endcase
                end
				
                T6: begin
                    // the Control Signals Differs depending on opcode
                    case(opcode)
					
                        LDA: begin
                            // LDA (Load the Output of RAM to Accumulator)
							CON <= 12'h3E3 ;
                        end
                        
                        ADD: begin
                            // ADD (Add the Output of RAM to Accumulator)
							CON <= 12'h3C7 ;
                        end
                        
                        SUB: begin
                            // SUB (Subtract the Output of RAM from Accumulator)
							CON <= 12'h3CF ;
                        end
                        OUT: begin
                            // OUT (Output data from Accumulator)
							CON <= 12'h3E3 ;
                        end
                        HLT: begin
                            // HTL (Do Nothing)
							CON <= 12'h3E3 ;
                        end
						
                        default: CON <= 12'h3E3 ;
                    endcase
                end
                default: CON <= 12'h3E3 ;
            endcase
        end
    end
endmodule
/***************************************************************************/
module t_controller ;

wire       Cp,Ep,nLm,nCE,nLi,nEi,nLa,Ea,Su,Eu,nLb,nLo;					
reg [3:0]  opcode;
reg        CLK,nCLR;


controller Control_Unit (Cp,Ep,nLm,nCE,nLi,nEi,nLa,Ea,Su,Eu,nLb,nLo,CLK,nCLR,opcode);

initial begin 
CLK = 0 ;
forever #50 CLK = ~CLK ;
end

initial begin 

     nCLR = 0 ; opcode = 4'b0000 ;
#100 nCLR = 0 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0000 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0001 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b0010 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;
#100 nCLR = 1 ; opcode = 4'b1110 ;

end

endmodule
