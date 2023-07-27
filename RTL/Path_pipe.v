// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_ln.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_sqrt.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/"

module  Path_pipe( clk, rst, en, seed1, seed2, rho, sqrt_rho_sqr, S_0, V_0, sqrt_delta_t, theta, epsilon_sqrt_delta_t, one_plus_mu_delta_t, kappa_delta_t, Price);

// --- I/O Declaration ---
input clk, rst;
input en;
input [22:0] seed1, seed2;
input [31:0] rho, sqrt_rho_sqr;
input [31:0] S_0, V_0;
input [31:0] sqrt_delta_t, theta, epsilon_sqrt_delta_t, one_plus_mu_delta_t, kappa_delta_t;
output [31:0] Price;

// --- Wire/Register Parameter Declaration ---
reg [31:0] S_i, V_i;
reg [31:0] next_S_i, next_V_i;
reg [31:0] S1;
wire [31:0] next_S1;
reg [31:0] sqrt_V;
wire [31:0] next_sqrt_V;
reg [31:0] V1;
wire [31:0] next_V1;
reg [31:0] minus_V;
reg [31:0] V2;
wire [31:0] next_V2;
reg [31:0] V3;
wire [31:0] next_V3;
reg [31:0] S2;
wire [31:0] next_S2;
reg [31:0] V4;
wire [31:0] next_V4;
reg [31:0] V5;
wire [31:0] next_V5;
// reg [31:0] V6;
wire [31:0] V6;
reg [31:0] S3;
wire [31:0] next_S3;
// reg [31:0] S4;
wire [31:0] S4;

wire [31:0] Price;
wire [31:0] G1_out, G2_out, W1_out, W2_out;

reg [3:0] start, next_start;
reg [2:0] path_pair, next_path_pair;
reg [10:0] new_path, next_new_path;

// ---  Pipe  --- ***

reg [31: 0] S_pipe2;
reg [31: 0] S_pipe3;
reg [31: 0] S_pipe4;
reg [31: 0] next_S_pipe2;
reg [31: 0] next_S_pipe3;
reg [31: 0] next_S_pipe4;

reg [31: 0] V_pipe2;
reg [31: 0] V_pipe3;
reg [31: 0] V_pipe4;
reg [31: 0] next_V_pipe2;
reg [31: 0] next_V_pipe3;
reg [31: 0] next_V_pipe4;

reg [ 1: 0] pipe_count, next_pipe_count;

reg [31: 0] V_buffer;
reg [31: 0] next_V_buffer;

// reg [31: 0] sqrt_V_pipe2;
// reg [31: 0] sqrt_V_pipe3;
// reg [31: 0] sqrt_V_pipe4;
// reg [31: 0] next_sqrt_V_pipe2;
// reg [31: 0] next_sqrt_V_pipe3;
// reg [31: 0] next_sqrt_V_pipe4;


always@(*) begin
    next_S_pipe2 = S_i;
    next_S_pipe3 = S_pipe2;
    next_S_pipe4 = S_pipe3;
    next_V_pipe2 = V_i;
    next_V_pipe3 = V_pipe2;
    next_V_pipe4 = V_pipe3;
    next_V_buffer = V4; 
end



// -----------------------------------------
// Sequential Part
// -----------------------------------------
always@ (posedge clk or posedge rst) begin
    if (rst) begin
        S_i <= S_0;
        V_i <= V_0;
        S1 <= 32'd0;
        V1 <= 32'd0;
        sqrt_V <= 32'd0;
        V2 <= 32'd0;
        V3 <= 32'd0;
        S2 <= 32'd0;
        V4 <= 32'd0;
        V5 <= 32'd0;
        // V6 <= 32'd0;
        S3 <= 32'd0;
        // S4 <= 32'd0;
        start <= 4'd0;
        path_pair <= 3'd0;
        new_path <= 11'd0;

        S_pipe2 <= 32'd0;
        S_pipe3 <= 32'd0;
        S_pipe4 <= 32'd0;
        V_pipe2 <= 32'd0;      // ***
        V_pipe3 <= 32'd0;
        V_pipe4 <= 32'd0;
        pipe_count <= 2'd0;

        V_buffer <= 32'd0;

    end
    else begin
        S_i <= next_S_i;
        V_i <= next_V_i;
        S1 <= next_S1;
        V1 <= next_V1;
        sqrt_V <= next_sqrt_V;
        V2 <= next_V2;
        V3 <= next_V3;
        S2 <= next_S2;
        V4 <= next_V4;
        V5 <= next_V5;
        // V6 <= next_V6;
        S3 <= next_S3;
        // S4 <= next_S4;
        start <= next_start;
        path_pair <= next_path_pair;
        new_path <= next_new_path;

        S_pipe2 <= next_S_pipe2;
        S_pipe3 <= next_S_pipe3;
        S_pipe4 <= next_S_pipe4;
        V_pipe2 <= next_V_pipe2;      // ***
        V_pipe3 <= next_V_pipe3;
        V_pipe4 <= next_V_pipe4;
        pipe_count <= next_pipe_count;

        V_buffer <= next_V_buffer;


    end
end

// -----------------------------------------
// Combinational Part
// -----------------------------------------
Id_Gaussian Gauss(
    .clk(clk),
    .rst(rst),
    .en(en),
    .seed1(seed1),
    .G1(G1_out),
    .seed2(seed2),
    .G2(G2_out)
);

Correlator Walk(
    .clk(clk),
    .rst(rst),
    .G1(G1_out),
    .G2(G2_out),
    .rho(rho),
    .sqrt_rho_sqr(sqrt_rho_sqr),
    .W1(W1_out),
    .W2(W2_out)
);

DW_fp_mult sub_module_1( 
    .a(W1_out),
    .b(sqrt_delta_t),
    .rnd(3'b000),
    .z(next_S1),
    .status()
);

DW_fp_sqrt sub_module_2(
    .a(V_i),
    .rnd(3'b000),
    .z(next_sqrt_V),
    .status()
);

always@(*) begin
    minus_V[31:31] = 1'b1;
    minus_V[30:0] = V_i[30:0];
end

DW_fp_add sub_module_3( 
    .a(theta),
    .b(minus_V),
    .rnd(3'b000),
    .z(next_V1),
    .status()
);

DW_fp_mult sub_module_4( 
    .a(W2_out),
    .b(epsilon_sqrt_delta_t),
    .rnd(3'b000),
    .z(next_V2),
    .status()
);

DW_fp_mult sub_module_5( 
    .a(V1),
    .b(kappa_delta_t),
    .rnd(3'b000),
    .z(next_V3),
    .status()
);

DW_fp_mult sub_module_6( 
    .a(S1),
    .b(sqrt_V),
    .rnd(3'b000),
    .z(next_S2),
    .status()
);

DW_fp_mult sub_module_7( 
    .a(V2),
    .b(sqrt_V),
    .rnd(3'b000),
    .z(next_V4),
    .status()
);

DW_fp_add sub_module_8( 
    .a(V3),
    .b(V_pipe3),        // ***
    .rnd(3'b000),
    .z(next_V5),
    .status()
);

DW_fp_add sub_module_9( 
    .a(V_buffer),
    .b(V5),
    .rnd(3'b000),
    // .z(next_V6),
    .z(V6),
    .status()
);

DW_fp_add sub_module_10( 
    .a(S2),
    .b(one_plus_mu_delta_t),
    .rnd(3'b000),
    .z(next_S3),
    .status()
);

DW_fp_mult sub_module_11( 
    .a(S3),
    .b(S_pipe4),
    .rnd(3'b000),
    // .z(next_S4),
    .z(S4),
    .status()
);

always@(*) begin
    if (start == 4'd11) begin
        if (new_path < 11'd366) begin // (5*365)+1 ***
            if (path_pair == 3'd3) begin
                // next_S_i = next_S4;
                next_S_i = S4;
                // next_V_i = (next_V6[31:31] == 0) ? next_V6 : 32'd0;
                next_V_i = (V6[31:31] == 0) ? V6 : 32'd0;
                next_start = start;
                next_path_pair = 3'd0;
                next_new_path = new_path + 25'd1;
                next_pipe_count = pipe_count;
            end
            else begin
                // next_S_i = S_i;      // ***
                // next_S_i = next_S4;
                next_S_i = S4;
                // next_V_i = V_i;      // ***
                // next_V_i = (next_V6[31:31] == 0) ? next_V6 : 32'd0;
                next_V_i = (V6[31:31] == 0) ? V6 : 32'd0;
                next_start = start;
                next_path_pair = path_pair + 3'd1;
                next_new_path = new_path;
                next_pipe_count = pipe_count;
            end
        end
        else begin
            // if (path_pair == 3'd3) begin   // ***
            if (path_pair == 3'd3) begin
                // next_S_i = next_S4;
                next_S_i = S4;
                // next_V_i = (next_V6[31:31] == 0) ? next_V6 : 32'd0;
                next_V_i = (V6[31:31] == 0) ? V6 : 32'd0;
                next_start = start;
                next_path_pair = 3'd0;
                next_new_path = 25'd0;
                next_pipe_count = pipe_count;
            end
            else begin
                next_S_i = S_0;
                next_V_i = V_0;
                next_start = start;
                // next_path_pair = path_pair + 3'd1;
                // next_new_path = 25'd0;
                // ***
                if (pipe_count == 2'd3) begin
                    next_path_pair = path_pair + 3'd1;
                    next_new_path = 25'd0;
                    next_pipe_count = 2'd0;
                end
                else begin
                    next_path_pair = path_pair;
                    next_new_path = new_path;
                    next_pipe_count = pipe_count + 1;
                end
                // ***
            end
        end
    end
    else begin
        next_S_i = S_0;
        next_V_i = V_0;
        next_start = start + 4'd1;
        next_path_pair = 3'd0;
        next_pipe_count = pipe_count;
        next_new_path = new_path;
    end
end

assign Price = S_i;

endmodule
