module my_mem (my_mem_if.DUT abc);

    logic [8:0] mem_array[int];

    always @(posedge abc.clk) begin

        if (abc.write) begin
            mem_array[abc.address] = {^abc.data_in, abc.data_in};
	end

        else if (abc.read) begin 
            abc.data_out = mem_array[abc.address];
	end
    end

endmodule
