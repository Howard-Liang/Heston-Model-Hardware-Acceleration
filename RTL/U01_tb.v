`timescale 1ns/10ps

`define CYCLE 10.0
// modify if need

module testbench;

reg clk = 0;
reg rst;
reg en;
reg [22:0] seed;
wire [31:0] Uniform0_1;

wire [63:0] U01_double;

assign U01_double = {Uniform0_1[31], Uniform0_1[30], {3{~Uniform0_1[30]}}, Uniform0_1[29:23], Uniform0_1[22:0], {29{1'b0}}};

integer f, i;

U01 DUT( .clk(clk), .rst(rst), .en(en), .seed(seed), .Uniform0_1(Uniform0_1) );

always #(`CYCLE/2) clk = ~clk;

initial begin
    f = $fopen("U01.txt", "w");
end

initial begin
    $fsdbDumpfile("U01.fsdb");
 	$fsdbDumpvars();
 	$dumpfile("U01.vcd");
 	$dumpvars();
 	$display("Wave saved.");
end

initial begin
   `ifdef SDFSYN
    	$sdf_annotate("U01_syn.sdf", DUT);
   `endif
   `ifdef SDFAPR
     	$sdf_annotate("U01_APR.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     	$fsdbDumpfile("U01.fsdb");
	 	$fsdbDumpvars();
   `endif
   `ifdef VCD
     	$dumpfile("U01.vcd");
	 	$dumpvars();
   `endif
end

initial begin
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
end

initial begin
	en = 0;
    rst = 0;
	seed = 0;
# `CYCLE;     
	rst = 1;
    en = 0;
    seed = 23'd0;
#(`CYCLE*3);
	rst = 0;
    en = 1;
    seed = 23'd232;
#`CYCLE;
    rst = 0;
    en = 0;
    seed = 0;

for (i = 1; i <= 10000; i = i + 1) begin
    #(`CYCLE);
    $fwrite(f, "%f\n", $bitstoreal(U01_double));
end

#`CYCLE
$fclose(f);
$finish;
end


endmodule
