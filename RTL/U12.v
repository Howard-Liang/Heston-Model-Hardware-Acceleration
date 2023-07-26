module  U12( clk, rst, en, seed, Uniform1_2);


// --- I/O Declaration ---
input clk, rst;
input en;
input [22:0] seed;
output [31:0] Uniform1_2;

// --- Wire/Register Parameter Declaration ---
reg [31:0] shreg, next_shreg;
wire [31:0] Uniform1_2;
assign Uniform1_2 = shreg;

// -----------------------------------------
// Sequential Part
// -----------------------------------------
always@ (posedge clk or posedge rst) begin
    if (rst) begin
        shreg[31:23] <= 9'b001111111;
        shreg[22:0] <= 23'd0;  // *** next? *** //
    end
    else begin
        shreg <= next_shreg;
    end
end

// -----------------------------------------
// Combinational Part
// -----------------------------------------
always@ (*) begin
    if (en) begin
        next_shreg[31:23] = 9'b001111111;
        next_shreg[22:0] = seed;
    end
    else begin
        next_shreg[31:23] = 9'b001111111;
        next_shreg[22:1] = shreg[21:0];
        next_shreg[0:0] = shreg[22:22] ^ shreg[17:17];
    end
end


endmodule


