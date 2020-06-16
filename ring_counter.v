/**
 * Ring counter
 * Generates the T-States for the Control Unit (Controller)
 *
 * Input :
 * CLK   = Clock
 * nCLR  = Clear (0 :clear)
 *
 * Output :
 * stste = T-States for the Control Unit
 */
module ring_counter (
						output reg [5:0] state,
						input            CLK,
						input            nCLR );

    // T-States
    parameter T1    = 6'b000001;
    parameter T2    = 6'b000010;
    parameter T3    = 6'b000100;
    parameter T4    = 6'b001000;
    parameter T5    = 6'b010000;
    parameter T6    = 6'b100000;

    initial begin
        state <= T1;
    end
    
    always @(posedge CLK) begin
	
        if(!nCLR) state <= T1;
		
        else
            case(state)
			
                T1:      state <= T2;
                T2:      state <= T3;
                T3:      state <= T4;
                T4:      state <= T5;
                T5:      state <= T6;

                default: state <= T1;
            endcase
    end
endmodule
