module super_alu(in , out);
input  [40 : 0]  in;
output [15 : 0] out;
reg [15 : 0] num1, num2, num3, num4;
// [40| op1 |38] - [37| op2 |35] - [34| op3 |32] - [31|  num1  |24] - [23|  num2  |16] - [15|  num3  |8] - [7|  num4  |0]
// (#1 op1 #2) op2 (#3 op3 #4)
wire [15 : 0] middle_one, middle_two;

alu a0 (.numa(num1), .numb(num2), .op(in[40 : 38]), .out(middle_one));
alu a1 (.numa(num3), .numb(num4), .op(in[34 : 32]), .out(middle_two));
alu a2 (.numa(middle_one),  .numb(middle_two),  .op(in[37 : 35]), .out(out));

always@(*)
begin
	case (in[31])
		0 : num1 = {8'b00000000, in[31 : 24]};
		1 : num1 = {8'b11111111, in[31 : 24]};
	endcase
	case (in[23])
		0 : num2 = {8'b00000000, in[23 : 16]};
		1 : num2 = {8'b11111111, in[23 : 16]};
	endcase
	case (in[15])
		0 : num3 = {8'b00000000, in[15 : 8 ]};
		1 : num3 = {8'b11111111, in[15 : 8 ]};
	endcase
	case (in[7])
		0 : num4 = {8'b00000000, in[ 7 : 0 ]};
		1 : num4 = {8'b11111111, in[ 7 : 0 ]};
	endcase

end
endmodule


// alu unit
module alu(numa, numb, op, out);
input [15 : 0] numa, numb;
input [2 : 0] op;
output reg [15 : 0] out;
wire [15 : 0] log, sqrt, power_out;

log2 a1 (numa, log);
sqroot a2 (numa, sqrt);
power a3 (numa, numb, power_out);
always@(*)
begin
	case(op)
    3'b000    : out = numa + numb;        
    3'b001    : out = numa - numb;  
    3'b010    : out = numa * numb; 
    3'b011    : out = numa - numb; 
    3'b100    : out = power_out; 
	3'b101    : out = log;
	3'b110    : out = sqrt;
	endcase
end
endmodule

//square root unit
module sqroot (num, sqrt);
input [15 : 0] num;
output reg [15 : 0] sqrt;
integer i;
reg [15 : 0] power;
always@(*)
begin
	if (num[15] == 1)
		sqrt = 16'b0;
	else
	begin
		for(i = 0; i < 1024; i = i + 1)
		begin
			power = i * i;
			if (power > num)
			begin
				sqrt = i - 1;	
				i = 1025;
			end	
			else if (power == num)
			begin
				sqrt = i;
				i = 1025;
			end	
		end
	end		
end
endmodule


//log2 unit
module log2(num, out);
input [15 : 0] num;
output reg[15 : 0] out;
reg [15 : 0] log2, i;
reg do_for;
always@(*)
begin	
do_for = 1;
	if(num[15] == 1)
		out = 16'b0;
	
	else
	begin	
		for(i = 0; i < 15; i = i + 1)
		begin
		 	log2 = 2 ** i;
			if(log2 == num)
				begin
				out = i;
				i = 16;
				end
			else if(log2 > num)
				begin
				out = i - 1;
				i = 16;
				end	
		end
	end
end
endmodule

module power(a, b, c);
input [15 : 0] a ,b;
output reg [15 : 0]c;
reg [15 : 0] mem, i;

always@ (a or b)
begin
	mem = 16'd1;
	for(i = 1; i < 14; i = i + 1)
		begin
		mem = mem * a;
		if(i == b)
			i = 15;
		end
	c = mem;
end
endmodule
