`timescale 1ns/1ps

package OOP;
	class Transaction ;
		rand logic [7:0] data_in ;
		rand logic [15:0] address;
		logic [8:0] data_out ;
		logic [8:0] exp ;
		static int error = 0; 
		

		function new () ;
			address = $urandom_range(0,65535);
			data_in = $urandom_range(0,255);
			exp = {^data_in, data_in};
            		data_out = 9'b0;
		endfunction 

		function void print_data_out ();
			$display("[Transaction] t=%0t | data_out=0x%03h",$time, data_out);
		endfunction

		static function void print_error ();
			$display("[Transaction] t=%0t | Total errors = %0d",$time,error);

		endfunction

		function void check ();
                        if (data_out !== exp) begin 
                                error = error + 1 ;
			end

                endfunction


		function Transaction deep_copy();
      			Transaction t = new();
      			t.address       = this.address;
      			t.data_in       = this.data_in;
      			t.data_out      = this.data_out;
      			t.exp = this.exp;
      			return t;
    		endfunction 
		
	endclass 
endpackage 
