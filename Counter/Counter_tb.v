  	//						//
      //		Adam Gawlik		      //
    //	AGH University of Science and Technology    //
  //             Synchronous Counter tb 	  //
//						//

`include "Counter.v"		// include front-end/RTL

`timescale 1ns/10ps		// set time scale to 1ns with precision to 10ps


module Counter_tb;
	// parameters
	parameter num_of_cycles = 500; // change number of cycles
	parameter WIDTH = 4;
	// testbench signals and variables
	reg clk;
	reg CounterOp;
	reg Resetn;
	wire [WIDTH-1:0] CounterOut;
	integer cycle; // for simulation purposes

	// DUT instantiation with given parameter(default is 4)
	Counter #(.CNT_WIDTH(WIDTH)) DUT (.Clk(clk), .Reset_n(Resetn), .CounterOp(CounterOp), .CounterOut(CounterOut));

	initial begin 		// input signals initialization
			CounterOp = 0;
			Resetn = 1;
			cycle = 0;
			$display("Beginnig simulation for %0d cases", num_of_cycles); 
			$dumpfile("Counter_tb.vcd");  		// waves filename 
	  		$dumpvars(0, CounterOp, Resetn, clk, CounterOut); // tracked signals
			#120 CounterOp = 1;
			#45 CounterOp = 0;
			#100 CounterOp = 1;
			#100 Resetn = 0;
			#20 Resetn = 1;
 			#30 CounterOp = 0;
			#20 Resetn = 0;
			#20 Resetn = 1;
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


