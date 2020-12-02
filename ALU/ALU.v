  	//						//
      //		Adam Gawlik		      //
    //	AGH University of Science and Technology    //
  //             Arithmetic-Logic Unit		  //
//						//

module ALU( input [31:0] A, B,
			input [3:0] ALUControl,
			output [31:0] Result,
			output [3:0] ALUFlags
			);

reg [31:0] result;
reg [31:0] ovfl;
reg [3:0] carry;
reg N, Z, C, V;
reg [7:0] temp[3:0];

always@(*) begin
	case(ALUControl)
		4'b0000: {carry[0], result} = A + B;	// add
		4'b0001: {carry[0], result} = A - B;	// sub
		4'b0010: {ovfl, result} = A * B;	// mul
		4'b0011: result = A / B;	// div
		4'b0100: result = A | B;	// or
		4'b0101: result = A & B;	// and
		4'b0110: result = ~A;		// not
		4'b0111: result = A ~| B;	// nor
		4'b1000: result = A ~& B;	// nand
		4'b1001: result = A ^ B;	// xor
		4'b1010: result = A ~^ B;	// xnor
		4'b1011: result = $signed(A) >>> B; 	// asr // needs to be signed to perform asr instead of lsr
		4'b1100: result = (A << (B % 32)) | (A >> (32 - (B % 32)));	// rotl
		4'b1101: result = (A >> (B % 32)) | (A << (32 - (B % 32)));	// rotr
		4'b1110: begin		// uadd
			{carry[0], temp[0]} = A[7:0] + B[7:0];
			{carry[1], temp[1]} = A[15:8] + B[15:8];
			{carry[2], temp[2]} = A[23:16] + B[23:16];
			{carry[3], temp[3]} = A[31:24] + B[31:24];
			result = {temp[3], temp[2], temp[1], temp[0]};
		end
		4'b1111: begin		// umul
			{ovfl[7:0], temp[0]} = A[7:0] * B[7:0];
			{ovfl[15:8], temp[1]} = A[15:8] * B[15:8];
			{ovfl[23:16], temp[2]} = A[23:16] * B[23:16];
			{ovfl[31:24], temp[3]} = A[31:24] * B[31:24];
			result = {temp[3], temp[2], temp[1], temp[0]};
		end 
	endcase
end

always@(*) begin
	case(ALUControl)
		4'b0000, 4'b0001: begin 	// add sub
			N = result[31];
			C = carry[0];
			V = C;
		end
		4'b0010: begin		// mul
			N = result[31];
			C = 1'b0;
			V = |ovfl;
		end
		4'b1110: begin		// uadd
			N = |{temp[3][7], temp[2][7], temp[1][7], temp[0][7]};
			C = |carry; // reduction operator
			V = C;
		end
		4'b1111: begin		// umul
			N = |{temp[3][7], temp[2][7], temp[1][7], temp[0][7]};
			C = 1'b0;
			V = |ovfl;
		end
		default: begin		// rest
			N = result[31];
			C = 1'b0;
			V = 1'b0;
		end
	endcase
	Z = !(|result); 
end

assign ALUFlags = {N, Z, C, V};
assign Result = result;

endmodule

