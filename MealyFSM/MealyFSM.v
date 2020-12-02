  	    //                                              //
  	  //                 Adam Gawlik                  //
    //  AGH University of Science and Technology    //
  //                 Mealy's FSM                  //
//                                              //

module MealyFSM #(parameter NUM_OF_BITS=4) (	// output's number of bits
		   	input wire Clk,
		   	input wire Reset_n,
			input wire FSMIn,
			output wire [NUM_OF_BITS-1:0] FSMOut
			);

parameter REG_WIDTH = $clog2(NUM_OF_BITS);	// calculate state reg width 
reg [REG_WIDTH-1:0] StateReg = 0;			// FSM's reg instantiation
reg [REG_WIDTH-1:0] NextState;
reg [NUM_OF_BITS:0] OneHotReg;
reg [REG_WIDTH-1:0] additive;

assign FSMOut = FSMIn ? OneHotReg : ~OneHotReg;

always@(posedge(Clk)) begin		// sequentional logic
	if (~Reset_n)
		StateReg <= 0;
	else
		StateReg <= NextState;
end

always@(FSMIn, StateReg) begin	// input comb. logic
	if (FSMIn)
		additive = 1;
	else
		additive = -1;
	NextState = StateReg + additive;
	if (NextState == {REG_WIDTH{1'b1}}) // underflow
		NextState = NUM_OF_BITS-1;
	if (NextState == NUM_OF_BITS) 		// overflow
		NextState = 0;
end

always@(StateReg)begin	// output comb. logic
	OneHotReg = {1'b1, {(NUM_OF_BITS-1){1'b0}}} >> StateReg;
end

endmodule
