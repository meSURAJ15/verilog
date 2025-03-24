`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 19:47:57
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;

parameter N1 = 8;
parameter N2 = 16;
parameter N3 = 32;

reg CLK;
reg RST;
reg ENABLE;
reg [N2-1 : 0] input_data;
reg [N2-1 : 0] data[99:0];
wire [N3-1: 0] output_data;
wire [N2-1 : 0] sampleT;

fir_filter uut(.input_data(input_data),
               .output_data(output_data),
               .CLK(CLK),
               .RST(RST),
               .ENABLE(ENABLE),
               .sampleT(sampleT)
               );
integer k;
integer FILE1;

always #10 CLK =~CLK;

initial
begin
k=0;
$readmemb("input.data",data);

FILE1 = $fopen("save.data","w");

CLK = 0;
#20
RST = 1'b0;
#40
RST = 1'b0;
ENABLE = 1'b1;
input_data < = data[k];
#10
for (k=1; k<100; k = k+1)
begin
 @(posedge CLK);
 $fdisplay(FILE1, "%b",output_data);



               
               



endmodule
