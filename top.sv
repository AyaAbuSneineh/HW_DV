`timescale 1ns/1ps

module top;

    logic clk;

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    my_mem_if mem_bus(clk);

    my_mem dut(mem_bus);

    // Program block instance (via TB modport)
    test_program tb(mem_bus);

    // Waveform dump
    initial begin
    	$dumpfile("wave.vcd");
    	$dumpvars(0, top);
	end

endmodule

