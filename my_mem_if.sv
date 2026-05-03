`timescale 1ns/1ps

interface my_mem_if(input logic clk);

    logic write   = 0;
    logic read    = 0;
    logic [7:0]  data_in  = 0;
    logic [15:0] address  = 0;
    logic [8:0]  data_out = 0;

	always @(posedge clk)begin
		if (read == 1 && write == 1 ) 
			$fatal("ERROR: read and write are both active at time %0t", $time);
	end

    clocking cb @(posedge clk);
        default input #0 output #1ns;
        output write;
        output read;
        output data_in;
        output address;
        input  data_out;
    endclocking

   
    modport DUT (input  clk,input  write,input  read,input  data_in,input  address,output data_out);

    modport TB (clocking cb);

endinterface

