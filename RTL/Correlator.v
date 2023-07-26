// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_mult.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_ln.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_sqrt.v"

module  Correlator( clk , rst , G1, G2, rho, sqrt_rho_sqr, W1, W2);


// --- I/O Declaration ---
input clk, rst;
input [31:0] rho, sqrt_rho_sqr;
input [31:0] G1, G2;
output [31:0] W1, W2;

// --- Wire/Register Parameter Declaration ---
reg [31:0] W1, W2;
reg [31:0] next_W1;
reg [31:0] next_W2;
reg [31:0] m1, m2;
wire [31:0] next_m1, next_m2;
reg [31:0] buff, next_buff;
wire [31:0] next_W2_wire;

// -----------------------------------------
// Sequential Part
// -----------------------------------------
always@ (posedge clk or posedge rst) begin
    if (rst) begin
        W1[31:0] <= 32'd0;
        W2[31:0] <= 32'd0;
        m1[31:0] <= 32'd0;
        m2[31:0] <= 32'd0;
        buff[31:0] <= 32'd0;
    end
    else begin
        W1 <= next_W1;
        W2 <= next_W2;
        m1 <= next_m1;
        m2 <= next_m2;
        buff <= next_buff;
    end
end

// -----------------------------------------
// Combinational Part
// -----------------------------------------
DW_fp_mult sub_module_2 ( 
    .a(G1),
    .b(rho),
    .rnd(3'b000),
    .z(next_m1),
    .status()
);

DW_fp_mult sub_module_3 ( 
    .a(G2),
    .b(sqrt_rho_sqr),
    .rnd(3'b000),
    .z(next_m2),
    .status()
);

DW_fp_add sub_module_4 ( 
    .a(m1),
    .b(m2),
    .rnd(3'b000),
    .z(next_W2_wire),
    .status()
);

always @(*) begin
    next_W2 = next_W2_wire;
end

always @(*) begin
    next_buff = G1;
    next_W1 = buff;
end


endmodule
