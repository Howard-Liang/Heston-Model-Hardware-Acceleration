// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_ln.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_mult.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_sqrt.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/"

module  Id_Gaussian( clk, rst, en, seed1, G1, seed2, G2);


// --- I/O Declaration ---
input clk, rst;
input en;
input [22:0] seed1, seed2;
output [31:0] G1, G2;

// --- Wire/Register Parameter Declaration ---
reg [31:0] G1, G2;
reg [31:0] lnU1;
reg [31:0] minus2_lnU1;
reg [31:0] sqrt_minus2_lnU1;
reg [31:0] two_U2;
reg [31:0] sin_2pi_U2;
reg [31:0] cos_2pi_U2;

wire [31:0] Unif_out1, Unif_out2;
wire [31:0] ln_out;
wire [31:0] sqrt_out;
wire [31:0] sin_out;
wire [31:0] cos_out;
wire [31:0] next_G1, next_G2;

// -----------------------------------------
// Sequential Part
// -----------------------------------------
always@ (posedge clk or posedge rst) begin
    if (rst) begin
        G1[31:0] <= 32'd0;
        G2[31:0] <= 32'd0;
    end
    else begin
        G1 <= next_G1;
        G2 <= next_G2;
        lnU1 <= ln_out;
        sqrt_minus2_lnU1 <= sqrt_out;
        sin_2pi_U2 <= sin_out;
        cos_2pi_U2 <= cos_out;
    end
end

// -----------------------------------------
// Combinational Part
// -----------------------------------------
U01 sub_module_1(
    .clk(clk),
    .rst(rst),
    .en(en),
    .seed(seed1),
    .Uniform0_1(Unif_out1)
);

U01 sub_module_2(
    .clk(clk),
    .rst(rst),
    .en(en),
    .seed(seed2),
    .Uniform0_1(Unif_out2)
);

DW_fp_ln #(23, 8, 0, 0, 0) sub_module_3(
    .a(Unif_out1),
    .z(ln_out),
    .status() 
);

always@(*) begin
    minus2_lnU1[31:31] = 1'b0;
    minus2_lnU1[30:23] = lnU1[30:23] + 8'd1;
    minus2_lnU1[22:0] = lnU1[22:0];
end

DW_fp_sqrt sub_module_5 (
    .a(minus2_lnU1),
    .rnd(3'b000),
    .z(sqrt_out),
    .status() 
);

always@(*) begin
    two_U2[31:31] = Unif_out2[31:31];
    two_U2[30:23] = Unif_out2[30:23] + 8'd1;
    two_U2[22:0] = Unif_out2[22:0];
end

DW_fp_sincos #(23, 8, 0, 1, 0, 1) sub_module_6 (   // pi inside module
    .a(two_U2), 
    // .a(Unif_out2),
    .sin_cos(1'b0),   // 0 for sine, 1 for cosine
    .z(sin_out),
    .status()
);

DW_fp_sincos #(23, 8, 0, 1, 0, 1) sub_module_7 (   // pi inside modele
    .a(two_U2), 
    // .a(Unif_out2),
    .sin_cos(1'b1),   // 0 for sine, 1 for cosine
    .z(cos_out),
    .status()
);

DW_fp_mult sub_module_8 (
    .a(sqrt_minus2_lnU1),
    .b(sin_2pi_U2),
    .rnd(3'b000),
    .z(next_G1),
    .status()
);

DW_fp_mult sub_module_9 (
    .a(sqrt_minus2_lnU1),
    .b(cos_2pi_U2),
    .rnd(3'b000),
    .z(next_G2),
    .status()
);

endmodule
