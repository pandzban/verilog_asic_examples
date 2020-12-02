  	    //												//
  	  //			 	 Adam Gawlik			  	  //
    //	AGH University of Science and Technology	//
  //			Arithmetic-Logic Unit tb	 	  //
//												//

`include "ALU.v"		// include front-end/rtl

`timescale 1ns/10ps		// set time scale to 1ns with precision to 10ps


module ALU_tb;

	parameter num_of_iterations = 1000000; // change number of iteration

	reg [31:0] A, B;
	reg [3:0] ALUControl;
	wire [31:0] Result;
	wire [3:0] ALUFlags;

	reg [31:0] refResult; 
	reg [3:0] refALUFlags;

	integer iteration;
	integer err_cnt;
	reg clk;


	ALU DUT(.A(A), .B(B), .ALUControl(ALUControl), .ALUFlags(ALUFlags), .Result(Result));

	initial begin 		// input signals initialization
			A=0; B=0; ALUControl=4'b0000;
			err_cnt = 0;
			iteration = 0;
			$display("Beginnig simulation for %0d cases", num_of_iterations);
	end

	always begin 	 	// the main clock with period 10ns
		#5 clk = 1'b0;
		#5 clk = 1'b1;
	end

	always@(posedge(clk)) begin
		A=$random; B=$random; ALUControl=$random%16;
		iteration++;
		#5;				// on falling edge
		alu_model(A, B, ALUControl, refResult, refALUFlags); // predict output values

		if ((ALUFlags !== refALUFlags) || (Result !== refResult))begin  // checker
			$display("A=%b, \n     B=%b, ALUControl=%b", A, B, ALUControl);
			if (ALUFlags !== refALUFlags) begin 
				$display("at iter=%d, flags mismatch, ALUFlags=%b, refALUFlags=%b", iteration, ALUFlags, refALUFlags);
				$display("at iter=%d, flags mismatch, Result=%b, refResult=%b", iteration, Result, refResult);
			end
			if (Result !== refResult) begin
				$display("at iter=%d, result mismatch, Result=%b, refResult=%b", iteration, Result, refResult);
				$display("at iter=%d, result mismatch, ALUFlags=%b, refALUFlags=%b", iteration, ALUFlags, refALUFlags);
			end
			err_cnt++;
		end

		if ((iteration%100000) == 0)
			$display("iteration: %d",iteration);

		if (iteration == num_of_iterations) begin
			$display("finished with %0d errors for %0d cases",err_cnt ,iteration);
			$finish;
		end
	end

	task automatic alu_model(		// reference model (gold model)
				input [31:0] A, B,
				input [3:0] ALUControl,
				output reg [31:0] Result,
				output reg [3:0] ALUFlags
				);
		reg [63:0] result;
		reg N, Z, C, V;
		reg [7:0] temp[3:0];
		integer tempx;
		begin
			result = 0;
			case(ALUControl)
				4'b0000: begin
					result = A + B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					if (result > (2**32 - 1))
						V = 1'b1;
					else 
						V = 1'b0;
					C = V;
				end 
				4'b0001: begin	// sub
					result = A - B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					if (result > (2**32 - 1))
						V = 1'b1;
					else 
						V = 1'b0;
					C = V;
				end
				4'b0010: begin 		// mul
					result = A * B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					if (result > (2**32 - 1))
						V = 1'b1;
					else 
						V = 1'b0;
					C = 1'b0;
				end
				4'b0011: begin	// div
					result = A / B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b0100: begin	// or
					result[31:0] = A | B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b0101: begin	// and
					result[31:0] = A & B;
					if (result[31] != 0)
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b0110: begin		// not
					result[31:0] = ~A;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b0111: begin	// nor
					result[31:0] = A ~| B;
					if (result[31] != 0)
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1000: begin	// nand
					result[31:0] = A ~& B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1001: begin	// xor
					result[31:0] = A ^ B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1010: begin	// xnor
					result[31:0] = A ~^ B;
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1011: begin
					result[31:0] = $signed(A) >>> B; 	// asr // needs to be signed to perform asr instead of lsr
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1100: begin		     	// rotl
					 result[31:0] = (A << (B % 32)) | (A >> (32 - (B % 32)));
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1101: begin
					result[31:0] = (A >> (B % 32)) | (A << (32 - (B % 32)));	// rotr
					if (result[31] != 0) 
						N = 1'b1;
					else 
						N = 1'b0;
					if (result == 0)
						Z = 1'b1;
					else 
						Z = 1'b0;
					V = 1'b0;
					C = 1'b0;
				end
				4'b1110: begin		// uadd
					C = 1'b0;
					Z = 1'b1;
					N = 1'b0;
					tempx = A[7:0] + B[7:0];
					if (tempx > (2**8 - 1)) 
						C = 1'b1;
					temp[0] = tempx;
					if (temp[0][7] != 0)
						N = 1'b1;
					if (temp[0] != 0)
						Z = 1'b0;
					tempx = A[15:8] + B[15:8];
					if (tempx > (2**8 - 1)) 
						C = 1'b1;
					temp[1] = tempx;
					if (temp[1][7] != 0)
						N = 1'b1;
					if (temp[1] != 0)
						Z = 1'b0;
					tempx = A[23:16] + B[23:16];
					if (tempx > (2**8 - 1)) 
						C = 1'b1;
					temp[2] = tempx;
					if (temp[2][7] != 0)
						N = 1'b1;
					if (temp[2] != 0)
						Z = 1'b0;
					tempx = A[31:24] + B[31:24];
					if (tempx > (2**8 - 1)) 
						C = 1'b1;
					temp[3] = tempx;
					if (temp[3][7] != 0)
						N = 1'b1;
					if (temp[3] != 0)
						Z = 1'b0;
					V = C;
					result = temp[0] + (temp[1] << 8) + (temp[2] << 16) + (temp[3] << 24);
				end
				4'b1111: begin		// umul
					V = 1'b0;
					Z = 1'b1;
					N = 1'b0;
					tempx = A[7:0] * B[7:0];
					if (tempx > (2**8 - 1)) 
						V = 1'b1;
					temp[0] = tempx;
					if (temp[0][7] != 0)
						N = 1'b1;
					if (temp[0] != 0)
						Z = 1'b0;
					tempx = A[15:8] * B[15:8];
					if (tempx > (2**8 - 1)) 
						V = 1'b1;
					temp[1] = tempx;
					if (temp[1][7] != 0)
						N = 1'b1;
					if (temp[1] != 0)
						Z = 1'b0;
					tempx = A[23:16] * B[23:16];
					if (tempx > (2**8 - 1)) 
						V = 1'b1;
					temp[2] = tempx;
					if (temp[2][7] != 0)
						N = 1'b1;
					if (temp[2] != 0)
						Z = 1'b0;
					tempx = A[31:24] * B[31:24];
					if (tempx > (2**8 - 1)) 
						V = 1'b1;
					temp[3] = tempx;
					if (temp[3][7] != 0)
						N = 1'b1;
					if (temp[3] != 0)
						Z = 1'b0;
					C = 1'b0;
					result = temp[0] + (temp[1] << 8) + (temp[2] << 16) + (temp[3] << 24);
				end 
			endcase
			Result = result[31:0];	
			ALUFlags = {N, Z, C, V};	// concatenation
		end
	endtask

endmodule 


