`timescale 1ns/10ps

`define CYCLE 10.0
// modify if need

module testbench;

reg clk = 0;
reg rst;
reg [22:0] G1, G2;
reg [31:0] rho, sqrt_rho_sqr;
wire [31:0] W1, W2;

wire [63:0] W1_double, W2_double;

assign W1_double = {W1[31], W1[30], {3{~W1[30]}}, W1[29:23], W1[22:0], {29{1'b0}}};
assign W2_double = {W2[31], W2[30], {3{~W2[30]}}, W2[29:23], W2[22:0], {29{1'b0}}};

integer f, i;

Correlator DUT( .clk(clk), .rst(rst), .G1(G1), .G2(G2), .rho(rho), .sqrt_rho_sqr(sqrt_rho_sqr),  .W1(W1), .W2(W2) );

always #(`CYCLE/2) clk = ~clk;

initial begin
    f = $fopen("Corr1.txt", "w");
end

initial begin
    $fsdbDumpfile("Correlator.fsdb");
 	$fsdbDumpvars();
 	$dumpfile("Correlator.vcd");
 	$dumpvars();
 	$display("Wave saved.");
end

initial begin
   `ifdef SDFSYN
    	$sdf_annotate("Correlator_syn.sdf", DUT);
   `endif
   `ifdef SDFAPR
     	$sdf_annotate("Correlator.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     	$fsdbDumpfile("Correlator.fsdb");
	 	$fsdbDumpvars();
   `endif
   `ifdef VCD
     	$dumpfile("Correlator.vcd");
	 	$dumpvars();
   `endif
end

initial begin
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
end

initial begin
    rst = 0;
# `CYCLE;     
	rst = 1;
    rho = 32'b10111111001100110011001100110011;
    sqrt_rho_sqr = 32'b00111111001101101101001000010000;
#(`CYCLE*3);
	rst = 0;
    rho = 32'b10111111001100110011001100110011;
    sqrt_rho_sqr = 32'b00111111001101101101001000010000;
    G1 = 2'b01;
    G2 = 2'b10;
#(`CYCLE*2); 

for (i = 1; i <= 50000; i = i + 1) begin
    #(`CYCLE);
    $fwrite(f, "%f\n", $bitstoreal(W1_double));
end

#(`CYCLE*50)
$fclose(f);
$finish;
end

endmodule
