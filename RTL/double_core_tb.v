`timescale 1ns/10ps

`define CYCLE 40.0    // 40 can pass APR
// modify if need

module testbench;

reg clk = 0;
reg rst;
reg en;
reg [22:0] seed1, seed2;
reg [22:0] seed3, seed4;
reg [31:0] rho, sqrt_rho_sqr;
reg [31:0] S_0, V_0;
reg [31:0] sqrt_delta_t, theta, epsilon_sqrt_delta_t, one_plus_mu_delta_t, kappa_delta_t;

wire [31:0] Price1;
wire [31:0] Price2;

wire [63:0] Price_double;

assign Price_double = {Price1[31], Price1[30], {3{~Price1[30]}}, Price1[29:23], Price1[22:0], {29{1'b0}}};

integer f, i;
integer j;

double_core DUT( .clk(clk), .rst(rst), .en(en), .seed1(seed1), .seed2(seed2), .seed3(seed3), .seed4(seed4),
          .rho(rho), .sqrt_rho_sqr(sqrt_rho_sqr), .S_0(S_0), .V_0(V_0),
          .sqrt_delta_t(sqrt_delta_t), .theta(theta), .epsilon_sqrt_delta_t(epsilon_sqrt_delta_t),
          .one_plus_mu_delta_t(one_plus_mu_delta_t), .kappa_delta_t(kappa_delta_t), .Price1(Price1), .Price2(Price2) );

always #(`CYCLE/2) clk = ~clk;

initial begin
    f = $fopen("double_core.txt", "w");
end

initial begin
    $fsdbDumpfile("double_core.fsdb");
 	$fsdbDumpvars();
 	$dumpfile("double_core.vcd");
 	$dumpvars();
 	$display("Wave saved.");
end

initial begin
   `ifdef SDFSYN
    	$sdf_annotate("double_core_syn.sdf", DUT);
   `endif
   `ifdef SDFAPR
     	$sdf_annotate("double_core_APR.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     	$fsdbDumpfile("double_core.fsdb");
	 	$fsdbDumpvars();
   `endif
   `ifdef VCD
     	$dumpfile("double_core.vcd");
	 	$dumpvars();
   `endif
end

initial begin
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
end

initial begin
	en = 0;
    rst = 1;
    seed1 = 23'd0;
    seed2 = 23'd0;
    seed3 = 23'd0;
    seed4 = 23'd0;
    rho = 32'd0;
    sqrt_rho_sqr = 32'd0;
    S_0 = 32'd0;
    V_0 = 32'd0;
    sqrt_delta_t = 32'd0;
    theta = 32'd0;
    epsilon_sqrt_delta_t = 32'd0;
    one_plus_mu_delta_t = 32'd0;
    kappa_delta_t = 32'd0;
#(`CYCLE);     
	rst = 1;
    en = 0;
    seed1 = 23'd0;
    seed2 = 23'd0;
    seed3 = 23'd0;
    seed4 = 23'd0;
    rho = 32'd0;
    sqrt_rho_sqr = 32'd0;
    S_0 = 32'd0;
    V_0 = 32'd0;
    sqrt_delta_t = 32'd0;
    theta = 32'd0;
    epsilon_sqrt_delta_t = 32'd0;
    one_plus_mu_delta_t = 32'd0;
    kappa_delta_t = 32'd0;
#(`CYCLE);     
	rst = 1;
    en = 1;
    seed1 = 23'd435777;        // can change seed here
    seed2 = 23'd23222;
    seed3 = 23'd1325024;
    seed4 = 23'd1022506;
    rho = 32'b10111111001100110011001100110011;         // parameters for heston model
    sqrt_rho_sqr = 32'b00111111001101101101001000010000;
    S_0 = 32'b01000010110010000000000000000000;
    V_0 = 32'b00111100001001110010001000011000;
    sqrt_delta_t = 32'b00111101010101100110010011111010;
    theta = 32'b00111100100110111010010111100011;
    epsilon_sqrt_delta_t = 32'b00111101000000101100011111010110;
    one_plus_mu_delta_t = 32'b00111111100000000000001011011101;
    kappa_delta_t = 32'b00111100100010110110000001010000;
#(`CYCLE*2);     
	rst = 0;
    en = 1;
    seed1 = 23'd435777;
    seed2 = 23'd23222;
    seed3 = 23'd1325024;
    seed4 = 23'd1022506;
    rho = 32'b10111111001100110011001100110011;
    sqrt_rho_sqr = 32'b00111111001101101101001000010000;
    S_0 = 32'b01000010110010000000000000000000;
    V_0 = 32'b00111100001001110010001000011000;
    sqrt_delta_t = 32'b00111101010101100110010011111010;
    theta = 32'b00111100100110111010010111100011;
    epsilon_sqrt_delta_t = 32'b00111101000000101100011111010110;
    one_plus_mu_delta_t = 32'b00111111100000000000001011011101;
    kappa_delta_t = 32'b00111100100010110110000001010000;
#(`CYCLE);     
	rst = 0;
    en = 0;
    seed1 = 23'd435777;
    seed2 = 23'd23222;
    seed3 = 23'd1325024;
    seed4 = 23'd1022506;
    rho = 32'b10111111001100110011001100110011;
    sqrt_rho_sqr = 32'b00111111001101101101001000010000;
    S_0 = 32'b01000010110010000000000000000000;
    V_0 = 32'b00111100001001110010001000011000;
    sqrt_delta_t = 32'b00111101010101100110010011111010;
    theta = 32'b00111100100110111010010111100011;
    epsilon_sqrt_delta_t = 32'b00111101000000101100011111010110;
    one_plus_mu_delta_t = 32'b00111111100000000000001011011101;
    kappa_delta_t = 32'b00111100100010110110000001010000;

    // rst = 1;
    // seed1 = 23'd4357;
    // seed2 = 23'd232;
    // rho = 32'b10111110100110011001100110011010;
    // sqrt_rho_sqr = 32'b00111111011101000011010101011100;
    // S_0 = 32'b01000010110010000000000000000000;
    // V_0 = 32'b00111101101110000101000111101100;
    // sqrt_delta_t = 32'b00111101010101100110010011111010;
    // theta = 32'b00111101101110000101000111101100;
    // epsilon_sqrt_delta_t = 32'b00111101010101100110010011111010;
    // one_plus_mu_delta_t = 32'b00111111100000000000010001111101;
    // kappa_delta_t = 32'b00111011101100111000110011111010;

// #(`CYCLE*3);
// 	rst = 0;
//     seed1 = 0;
//     seed2 = 0;
//     rho = 32'b10111111001100110011001100110011;
//     sqrt_rho_sqr = 32'b00111111001101101101001000010000;
//     S_0 = 32'b01000010110010000000000000000000;
//     V_0 = 32'b00111100001001110010001000011000;
//     sqrt_delta_t = 32'b00111101010101100110010011111010;
//     theta = 32'b00111100100110111010010111100011;
//     epsilon_sqrt_delta_t = 32'b00111101000000101100011111010110;
//     one_plus_mu_delta_t = 32'b00111111100000000000001011011101;
//     kappa_delta_t = 32'b00111100100010110110000001010000; 

    // rst = 0;
    // seed1 = 0;
    // seed2 = 0;
    // rho = 32'b10111110100110011001100110011010;
    // sqrt_rho_sqr = 32'b00111111011101000011010101011100;
    // S_0 = 32'b01000010110010000000000000000000;
    // V_0 = 32'b00111101101110000101000111101100;
    // sqrt_delta_t = 32'b00111101010101100110010011111010;
    // theta = 32'b00111101101110000101000111101100;
    // epsilon_sqrt_delta_t = 32'b00111101010101100110010011111010;
    // one_plus_mu_delta_t = 32'b00111111100000000000010001111101;
    // kappa_delta_t = 32'b00111011101100111000110011111010;
    
#(`CYCLE*6);
    for (i = 1; i <= (4*(365+1))*10; i = i + 1) begin   // (4*(365+1)*x) x is the simulation number
        #(`CYCLE);
        $fwrite(f, "%f\n", $bitstoreal(Price_double));
        if (i%(4*(365+1)) == 0) begin
            $display("--- [ Path %d finished !! ] ---", i/(4*(365+1)));
        end
    end

$fclose(f);
$finish;
end


endmodule
