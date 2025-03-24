/*
Name : Ghazi Haj Qassem
ID : 1210778
Section : 1
*/


module prime_fib_counter(clk, en, rst, up_down, prime_fib, Q); // the complete circuit
	input clk, en, rst, up_down, prime_fib; // input/output ports declarations
	output [5:0] Q;
	wire [3:0] x;
	
	mod11_counter stage0(clk, en, rst, up_down, x);	// first stage of the counter
	prime_fib_circuit stage1({prime_fib, x}, Q);	// second stage of the counter 
	
	
	
endmodule

// first stage of the counter: generates the sequence of terms, i.e. 0, 1, 2, 3...
module mod11_counter(clk, en, rst, up_down, Q);
	input clk, en, rst, up_down; // input/output ports declarations
	output reg [3:0] Q;
	
	// T flip flop input expressions derived from the state table.
	assign T1 = en&Q[0] | en&Q[2] | en&~up_down&Q[1] | en&Q[3]&~Q[1] | en&up_down&~Q[3];
	assign T2 = en&~up_down&~Q[0] | en&up_down&Q[0] | en&Q[3]&Q[1]; 
	assign T4 = en&~up_down&Q[2]&~Q[1]&~Q[0] | en&~up_down&Q[3]&~Q[1]&~Q[0] | en&up_down&Q[1]&Q[0];
	assign T8 = en&~up_down&~Q[2]&~Q[1]&~Q[0] | en&up_down&Q[2]&Q[1]&Q[0] | en&up_down&Q[3]&Q[1];
	
	// build the T flip flops
	T_flip_flop tff1(T1, Q[0], rst, clk);
	T_flip_flop tff2(T2, Q[1], rst, clk);
	T_flip_flop tff4(T4, Q[2], rst, clk);
	T_flip_flop tff8(T8, Q[3], rst, clk);
	
	
endmodule 

module T_flip_flop(T, Q, rst, clk);
	input T, clk, rst;	// input/output ports declarations
	output reg Q;
	
	always@(posedge clk or negedge rst) begin
		if(~rst) // the reset in active low and asynchronous
			Q <= 0; // reset the counter
		else
			Q <= T ^ Q;	// characteristic equation of the T flip flop
	end
	
endmodule	

// second stage of the counter: maps the term index sequence to fibonacci or prime sequences, based on the mode input.
module prime_fib_circuit(x, Q);
	input [4:0] x;	// the mode input is x[4], x[3] to x[0] is the index of the term
	output [5:0] Q; // the count value
	
	// Assigning the individual bits of the count output, a boolean expression.
	assign Q[5] = ~x[4]&x[3]&x[0] | ~x[4]&x[3]&x[1]; // 6th bit
	assign Q[4] = x[3]&~x[0] | x[4]&x[2]&x[1] | x[4]&x[3]; // 5th bit
	assign Q[3] = ~x[4]&x[2]&x[1] | x[4]&x[2]&~x[1] | x[4]&x[3]&x[0] | x[4]&x[3]&x[1]; // 4th bit
	assign Q[2] = ~x[4]&x[2]&x[0] |x[3]&~x[0] | x[4]&~x[2]&x[1] | x[2]&~x[1]&x[0] | x[4]&x[3]; // 3rd bit
	assign Q[1] = ~x[2]&x[1]&x[0] | x[2]&~x[1]&~x[0] | ~x[4]&x[3]&x[0] | x[3]&x[1] | x[4]&x[1]&x[0] | x[4]&~x[3]&~x[2]&~x[1] | x[4]&~x[1]&~x[0]; // 2nd bit
	assign Q[0] = ~x[3]&~x[1]&x[0] | ~x[2]&x[1]&~x[0] | x[2]&~x[1] | x[2]&x[0] | x[3]&~x[0] | x[4]&x[1] | x[4]&x[0]; // 1st bit
	
	
endmodule 

module test_generator(clk, en, rst, up_down, prime_fib, N);
	input clk, en, rst, up_down, prime_fib;
	output reg [5:0] N;	// expected output
	reg [5:0] primes [0:10] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31};
	reg [5:0] fib [0:10] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55};
	integer k = 0;
	
	
	// first stage of the counter
	always @(posedge clk or negedge rst) begin
		if(rst == 0) // reset the count
			k = 0;
		else if(en) begin  // if the circuit is enabled do the count, else the output remains the same.
			if(up_down)
				k = k == 10 ? 0 : k+1; // increment the count
			else
				k = k == 0 ? 10 : k-1; // decrement the count 
				
		end	 
	end	 
	
	// second stage of the counter
	always @(posedge clk or negedge rst or prime_fib)	// since the mode is asynchronous, it needs to be included in the sensitivity list
		if(prime_fib)  // count prime, else Fibonacci
			N <= primes[k];
		else
			N <= fib[k];
	
endmodule 

module result_analyzer(exp, out, E);
	input [5:0] exp, out; // expected result and actual output
	output reg E; // error flag
	
	always @(exp or out)
		#1ps E = exp != out; // error will be present when the expected result is not equal to the actual result.
		
	/* Note : The delay 1ps is added to overcome the delay in the change in both inputs, since it is undefined.
	for example if exp changes from 1 to 2 and out from 1 to 2 at the same time, then one might precede the other, and set E = 1 for a very little time.
	so the delay 1ps ensures the change in the output occurs */
endmodule
		



module prime_fib_counter_tb;
	// test inputs and outputs
	reg clk, en, rst, up_down, prime_fib;
	wire [5:0] exp, out;
	wire E;
	
	// generates the expected result
	test_generator tg(clk, en, rst, up_down, prime_fib, exp);
	// design under test
	prime_fib_counter ctr(clk, en, rst, up_down, prime_fib, out);
	// analyze the result
	result_analyzer ra(exp ,out, E);
	
	initial begin
		clk = 1'b0;	// start at 0 level
		rst = 0; // initialize the counter
		#1ns rst = 1;
		en = 1; // enable count
		
		// generate random test vectors
		{prime_fib, up_down} = 2'b11; // count prime up for 20 clock cycles
		#100ns {prime_fib, up_down} = 2'b00; // count Fibonacci down for 20 clock cycles
		rst = 0; // initialize the counter again
		#1ns rst = 1;
		#100ns {prime_fib, up_down} = 2'b10; // count prime down for 20 clock cycles
		#100ns {prime_fib, up_down} = 2'b01; // count Fibonacci up for 20 clock cycles
		
		#100ns en = 0; // disable the count
		#20ns {en, prime_fib, up_down} = 3'b111; // enable the count, then count prime up  
		
		// change inputs suddenly
		#2ns rst = 0;
		#1ns rst = 1;
		#2ns up_down = 0;
		#10ns prime_fib = 0;
		#10ns up_down = 1;
	end
	
	// clock generator
	always
		#5ns clk = ~clk;
		
	always@(E) begin
		if(E) // if there is error, print the wrong result
			$display("The actual result is %d, but the expected result is %d.\n", out, exp);
	end
 
endmodule