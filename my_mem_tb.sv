`timescale 1ns/1ps

program test_program(my_mem_if.TB mem_bus);

    import OOP::*;

    // Queues
    Transaction gen_q[$];
    Transaction obs_q[$];

    int number_of_transactions = 10;

    // TASK 1: generate transactions
    task generate_transactions();
        Transaction tr;
        for (int i = 0; i < number_of_transactions; i++) begin
            tr = new();
            if (!tr.randomize()) begin
                $display("Randomization failed at time %0t", $time);
            end
            tr.exp = {^tr.data_in, tr.data_in};
            gen_q.push_back(tr.deep_copy());
            $display("GENERATED | time = %0t | address = %h | data_in = %h | expected = %b",
                     $time, tr.address, tr.data_in, tr.exp);
        end
    endtask

    // TASK 2: drive transactions (write then read)
    task drive_transactions();
        Transaction tr;

        // Initial values
        mem_bus.cb.write   <= 0;
        mem_bus.cb.read    <= 0;
        mem_bus.cb.data_in <= 0;
        mem_bus.cb.address <= 0;

        repeat(2) @(mem_bus.cb);

        for (int i = 0; i < number_of_transactions; i++) begin
            wait(gen_q.size() > 0);
            tr = gen_q.pop_front();

            // WRITE
            mem_bus.cb.address <= tr.address;
            mem_bus.cb.data_in <= tr.data_in;
            mem_bus.cb.write   <= 1;
            mem_bus.cb.read    <= 0;
            @(mem_bus.cb);

            mem_bus.cb.write <= 0;
            mem_bus.cb.read  <= 0;
            @(mem_bus.cb);

            // READ
            mem_bus.cb.address <= tr.address;
            mem_bus.cb.write   <= 0;
            mem_bus.cb.read    <= 1;
            @(mem_bus.cb);

            // Capture data_out
            tr.data_out = mem_bus.cb.data_out;
            obs_q.push_back(tr.deep_copy());

            mem_bus.cb.read <= 0;
            @(mem_bus.cb);
        end
    endtask

    // TASK 3: collect and check
    task checker();
        Transaction tr;
        for (int i = 0; i < number_of_transactions; i++) begin
            wait(obs_q.size() > 0);
            tr = obs_q.pop_front();
            tr.print_data_out();
            tr.check();
        end
        Transaction::print_error();
        if (Transaction::error == 0) begin
            $display("=================================");
            $display("TEST PASSED: No errors found.");
            $display("=================================");
        end
        else begin
            $display("=================================");
            $display("TEST FAILED: errors = %0d", Transaction::error);
            $display("=================================");
        end
    endtask

    initial begin
        fork
            generate_transactions();
            drive_transactions();
            checker();
        join
        #200;
        $finish;
    end

endprogram
