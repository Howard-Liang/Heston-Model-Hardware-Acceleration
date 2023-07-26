// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_addsub.v"

module  U01( clk, rst, en, seed, Uniform0_1);


// --- I/O Declaration ---
input clk, rst;
input en;
input [22:0] seed;
output [31:0] Uniform0_1;

// --- Wire/Register Parameter Declaration ---
reg [31:0] out;
wire [31:0] next_out;
wire [31:0] fp1;
assign fp1 = 32'b00111111100000000000000000000000;
wire [31:0] Uniform0_1;
assign Uniform0_1 = out;

// -----------------------------------------
// Sequential Part
// -----------------------------------------
always@ (posedge clk or posedge rst) begin
    if (rst) begin
        out[31:0] <= 32'd0;
    end
    else begin
        out <= next_out;
    end
end

// -----------------------------------------
// Combinational Part
// -----------------------------------------
wire [31:0] U1_2;

U12 sub_module_1(
    .clk(clk),
    .rst(rst),
    .en(en),
    .seed(seed),
    .Uniform1_2(U1_2)
);

wire [31:0] Uniform1_2;
assign Uniform1_2 = U1_2;

DW_fp_addsub sub_module_2(
    .a(Uniform1_2),
    .b(fp1),
    .rnd(3'b000),
    .op(1'b1),          // 0 for add, 1 for sub
    .z(next_out),
    .status()
);


endmodule


