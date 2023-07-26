// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/"
 `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_ln.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_sqrt.v"
// `include "/usr/cad/synopsys/synthesis/cur/dw/sim_ver/DW_fp_addsub.v"

module  double_core( clk , rst , en,
             seed1, seed2,
             seed3, seed4,
             rho, sqrt_rho_sqr, S_0, V_0,
             sqrt_delta_t, theta, epsilon_sqrt_delta_t,
             one_plus_mu_delta_t, kappa_delta_t,
             Price1, Price2 );

// --- I/O Declaration ---
input clk, rst;
input en;
input [22:0] seed1, seed2;
input [22:0] seed3, seed4;
input [31:0] rho, sqrt_rho_sqr;
input [31:0] S_0, V_0;
input [31:0] sqrt_delta_t, theta, epsilon_sqrt_delta_t, one_plus_mu_delta_t, kappa_delta_t;
output [31:0] Price1;
output [31:0] Price2;

// --- Wire/Register Parameter Declaration ---
wire [31:0] Price1;
wire [31:0] Price2;
Path_pipe core1( .clk(clk), .rst(rst), .en(en), .seed1(seed1), .seed2(seed2),
                 .rho(rho), .sqrt_rho_sqr(sqrt_rho_sqr), .S_0(S_0), .V_0(V_0),
                 .sqrt_delta_t(sqrt_delta_t), .theta(theta), .epsilon_sqrt_delta_t(epsilon_sqrt_delta_t),
                 .one_plus_mu_delta_t(one_plus_mu_delta_t), .kappa_delta_t(kappa_delta_t), .Price(Price1)
                );

Path_pipe core2( .clk(clk), .rst(rst), .en(en), .seed1(seed3), .seed2(seed4),
                 .rho(rho), .sqrt_rho_sqr(sqrt_rho_sqr), .S_0(S_0), .V_0(V_0),
                 .sqrt_delta_t(sqrt_delta_t), .theta(theta), .epsilon_sqrt_delta_t(epsilon_sqrt_delta_t),
                 .one_plus_mu_delta_t(one_plus_mu_delta_t), .kappa_delta_t(kappa_delta_t), .Price(Price2)
                );

endmodule