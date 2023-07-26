`timescale 1ns/10ps

`define CYCLE 25.0
// modify if need

module testbench;

reg clk = 0;
reg rst;
reg en;
reg [22:0] seed1, seed2;
wire [31:0] G1, G2;

wire [63:0] G1_double, G2_double;

assign G1_double = {G1[31], G1[30], {3{~G1[30]}}, G1[29:23], G1[22:0], {29{1'b0}}};
assign G2_double = {G2[31], G2[30], {3{~G2[30]}}, G2[29:23], G2[22:0], {29{1'b0}}};

integer f, i;

Id_Gaussian DUT( .clk(clk), .rst(rst), .en(en), .seed1(seed1), .seed2(seed2),  .G1(G1), .G2(G2) );

always #(`CYCLE/2) clk = ~clk;

initial begin
    f = $fopen("GRNG2.txt", "w");
end

initial begin
    $fsdbDumpfile("Id_Gaussian.fsdb");
 	$fsdbDumpvars();
 	$dumpfile("Id_Gaussian.vcd");
 	$dumpvars();
 	$display("Wave saved.");
end

initial begin
   `ifdef SDFSYN
    	$sdf_annotate("Id_Gaussian_syn.sdf", DUT);
   `endif
   `ifdef SDFAPR
     	$sdf_annotate("Id_Gaussian.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     	$fsdbDumpfile("Id_Gaussian.fsdb");
	 	$fsdbDumpvars();
   `endif
   `ifdef VCD
     	$dumpfile("Id_Gaussian.vcd");
	 	$dumpvars();
   `endif
end

initial begin
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
end

initial begin
	en = 0;
    rst = 0;
	seed1 = 0;
    seed2 = 0;
# `CYCLE;    
    en = 0;
	rst = 1;
    seed1 = 23'd0;
    seed2 = 23'd0;
#(`CYCLE*3);
	rst = 0;
    en = 1;
    seed1 = 23'd4357;
    seed2 = 23'd232;
#(`CYCLE*1);
    rst = 0;
    en = 0;
    seed1 = 0;
    seed2 = 0;

for (i = 1; i <= 50000; i = i + 1) begin
    #(`CYCLE);
    $fwrite(f, "%f\n", $bitstoreal(G2_double));
end

#(`CYCLE*1)
$fclose(f);
$finish;
end

endmodule
