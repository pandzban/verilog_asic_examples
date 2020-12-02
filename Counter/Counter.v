  	    //												//
  	  //			 	 Adam Gawlik			  	  //
    //	AGH University of Science and Technology	//
  //              Synchronous Counter 			  //
//												//

module Counter #(parameter CNT_WIDTH=4) (	// counter register's width param
		   	input wire Clk,
		   	input wire Reset_n,
			input wire CounterOp,
			output wire [CNT_WIDTH-1:0] CounterOut
			);

reg [CNT_WIDTH-1:0] cnt_value = 0;		// counter's reg instantiation
reg last_mode = 0;

always@(posedge(Clk)) begin
	if (CounterOp == 1'b1) begin
		if (!(last_mode && Reset_n))		// reset if switched mode
			cnt_value <= 1;
		else 
			cnt_value <= cnt_value + 2;
	end
	else begin
		if (last_mode || !Reset_n)
			cnt_value <= 0;
		else 
			cnt_value <= cnt_value + 2;
	end
	last_mode <= CounterOp;
end

assign CounterOut = cnt_value;

endmodule

