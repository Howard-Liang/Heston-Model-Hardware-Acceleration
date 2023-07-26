`timescale 1ns/10ps

`define CYCLE 10.0
// modify if need

module testbench;

reg clk = 0;
reg rst;
reg en;
reg [22:0] seed;
wire [31:0] Uniform1_2;

wire [63:0] U12_double;
assign U12_double = {Uniform1_2[31], Uniform1_2[30], {3{~Uniform1_2[30]}}, Uniform1_2[29:23], Uniform1_2[22:0], {29{1'b0}}};

integer f, i;

U12 DUT( .clk(clk), .rst(rst), .en(en), .seed(seed), .Uniform1_2(Uniform1_2) );

always #(`CYCLE/2) clk = ~clk;

initial begin
    f = $fopen("U12.txt", "w");
end

initial begin
    $fsdbDumpfile("U12.fsdb");
 	$fsdbDumpvars();
 	$dumpfile("U12.vcd");
 	$dumpvars();
 	$display("Wave saved.");
end

initial begin
   `ifdef SDFSYN
    	$sdf_annotate("U12_syn.sdf", DUT);
   `endif
   `ifdef SDFAPR
     	$sdf_annotate("U12_APR.sdf", DUT);
   `endif	 	 
   `ifdef FSDB
     	$fsdbDumpfile("U12.fsdb");
	 	$fsdbDumpvars();
   `endif
   `ifdef VCD
     	$dumpfile("U12.vcd");
	 	$dumpvars();
   `endif
end

initial begin
	$display("--------------------------- [ Simulation Starts !! ] ---------------------------");
end

initial begin
    rst = 0;
	seed = 0;
    en = 0;
# `CYCLE;     
	rst = 1;
	seed = 23'd0;
    en = 0;
#(`CYCLE*3);
	rst = 0;
    en = 1;
	seed = 23'd123;
#(`CYCLE);
    rst = 0;
    en = 0;
    seed = 0;


for (i = 1; i <= 100; i = i + 1) begin
    #(`CYCLE);
    $fwrite(f, "%f\n", $bitstoreal(U12_double));
end
#(`CYCLE*1)
$fclose(f);
$finish;
end


endmodule
