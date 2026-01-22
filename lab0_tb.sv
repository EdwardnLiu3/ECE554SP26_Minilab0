module lab0_tb;
    logic       clk;
    logic       enable;
    logic [7:0] address;
    logic [7:0] data;
    
    lab0 test1(.clk(clk), .enable(enable), .address(address),.data(data));
    
    // Reference: matches ROM initialization in DUT
    logic [7:0] reference_rom [0:7] = '{8'hA3, 8'h5C, 8'hF1, 8'h2B, 8'h7E, 8'hD9, 8'h4A, 8'hB6};
    
    initial begin
        
        clk = 0;
        enable = 0;
        address = 8'b00000000;
        
        @(posedge clk);
        @(negedge clk);
        
        $display("TEST 1: Enable LOW - Expecting all zeros");
        enable = 0;
        address = 8'b00000001;
        @(posedge clk);
        @(negedge clk);
        if (data !== 8'h00) begin
            $display("ERROR: Enable LOW, Address 0 - Expected: 0x00, Got: 0x%h", data);
        end else begin
            $display("PASS: Enable LOW outputs zeros");
        end
        
        address = 8'b00001000;
        @(posedge clk);
        @(negedge clk);
        if (data !== 8'h00) begin
            $display("ERROR: Enable LOW, Address 3 - Expected: 0x00, Got: 0x%h", data);
        end 
        else begin
            $display("PASS: Enable LOW outputs zeros for different address");
        end
        
        $display("\nTEST 2: Reading all ROM locations with enable HIGH");
        enable = 1;
        
        for (int i = 0; i < 8; i++) begin
            address = 8'b00000001 << i;  // One-hot encoding
            @(posedge clk);
            @(negedge clk);
            if (data !== reference_rom[i]) begin
                $display("ERROR: Location %0d - Expected: 0x%h, Got: 0x%h", i, reference_rom[i], data);
            end
            else begin
                $display("PASS: Location %0d correctly read as 0x%h", i, data);
            end
        end

        $display("\nTEST 3: Testing enable toggling");
        
        address = 8'b00000010;  // Address 1
        enable = 1;
        @(posedge clk);
        @(negedge clk);
        if (data !== reference_rom[1]) begin
            $display("ERROR: Enable HIGH - Expected: 0x%h, Got: 0x%h", 
                     reference_rom[1], data);
        end
        else begin
            $display("PASS: Enable HIGH reads correct data");
        end
        
        enable = 0;
        @(posedge clk);
        @(negedge clk);
        if (data !== 8'h00) begin
            $display("ERROR: Enable toggled LOW - Expected: 0x00, Got: 0x%h", data);
        end
        else begin
            $display("PASS: Enable toggled LOW outputs zeros");
        end
        
        enable = 1;
        @(posedge clk);
        @(negedge clk);
        if (data !== reference_rom[1]) begin
            $display("ERROR: Enable toggled HIGH - Expected: 0x%h, Got: 0x%h", reference_rom[1], data);
        end
        else begin
            $display("PASS: Enable toggled HIGH reads correct data");
        end
        
        $stop;
    end
    always 
        #5 clk = ~clk;  
endmodule