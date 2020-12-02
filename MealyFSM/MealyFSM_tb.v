  	    //                                              //
  	  //                 Adam Gawlik                  //
    //  AGH University of Science and Technology    //
  //                 Mealy's FSM tb               //
//                                              //

`include "MealyFSM.v"		// include front-end/RTL

`timescale 1ns/10ps		// set time scale to 1ns with precision to 10ps


module MealyFSM_tb;
	// parameters
	parameter num_of_cycles = 500;  // change number of cycles
	parameter NUM_OF_BITS = 4;		// FSM's output's width
	// testbench signals and variables
	reg clk;
	reg fsm_in;
	reg Resetn;
	wire [NUM_OF_BITS-1:0] fsm_out;
	integer cycle; // for simulation purposes

	// DUT instantiation with given parameter(default is 4)
	MealyFSM #(.NUM_OF_BITS(NUM_OF_BITS)) DUT (.Clk(clk), .Reset_n(Resetn), .FSMIn(fsm_in), .FSMOut(fsm_out));

	initial begin 		// input signals initialization
			fsm_in = 1;
			Resetn = 1;
			cycle = 0;
			$display("Beginnig simulation for %0d cases", num_of_cycles); 
			$dumpfile("MealyFSM_tb.vcd");  		// waves filename 
	  		$dumpvars(0, fsm_in, Resetn, clk, fsm_out); // tracked signals
			#54 fsm_in = 0;
			#22 fsm_in = 1;
			#24 fsm_in = 0;
			#13 fsm_in = 1;
			#9  fsm_in = 0;
			#17 fsm_in = 1;
			#22 fsm_in = 0;
			#11 fsm_in = 1;
			#23 fsm_in = 0;
			#27 fsm_in = 1;
			#23 Resetn = 0;
			#24 Resetn = 1;
			#10 fsm_in = 0;
			#12 Resetn = 0;
			#15 Resetn = 1;
	end

	always begin 	 // the main clock with period 10ns
		cycle++;
		#5 clk = 1'b0;
		#5 clk = 1'b1;
		if (cycle == num_of_cycles) begin // count cycles
			$display("finished in %0d clock cycles", cycle);
			$finish;
		end
	end

endmodule 


