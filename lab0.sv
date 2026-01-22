module lab0 (
    input  logic       clk,
    input  logic       enable,
    input  logic [7:0] address,  // one-hot encoded
    output logic [7:0] data
);

    // ROM storage - 8 locations, 8-bit values each
    // Initialize with random non-zero values
    logic [7:0] rom [0:7];
    
    initial begin
        rom[0] = 8'hA3;  
        rom[1] = 8'h5C;
        rom[2] = 8'hF1;
        rom[3] = 8'h2B;
        rom[4] = 8'h7E;
        rom[5] = 8'hD9;
        rom[6] = 8'h4A;
        rom[7] = 8'hB6;
    end
    
    // Decode one-hot address to binary index
    logic [2:0] addr_index;
    always_comb begin
        case (address)
            8'b00000001: addr_index = 3'd0;
            8'b00000010: addr_index = 3'd1;
            8'b00000100: addr_index = 3'd2;
            8'b00001000: addr_index = 3'd3;
            8'b00010000: addr_index = 3'd4;
            8'b00100000: addr_index = 3'd5;
            8'b01000000: addr_index = 3'd6;
            8'b10000000: addr_index = 3'd7;
            default:     addr_index = 3'd0; 
        endcase
    end
    
    // Registered output - data appears on next cycle when enable is HIGH
    always_ff @(posedge clk) begin
        if (enable)
            data <= rom[addr_index];
        else
            data <= 8'h00;
    end

endmodule