`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:41:39 03/29/2024 
// Design Name: 
// Module Name:    convolution 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module convolution (
    input clk,
    input signed [7:0] input_data,
    input signed [2:0] kernel,
    output reg signed [15:0] output_data
);
	integer i;
    reg signed [7:0] shift_reg [2:0]; // Shift register to store input_data
    reg signed [15:0] accumulator;    // Accumulator for convolution result
    // Shift register for input data
    always @(posedge clk) begin
        shift_reg[0] <= shift_reg[1];
        shift_reg[1] <= shift_reg[2];
        shift_reg[2] <= input_data;
    end
    // Convolution operation
    always @* begin
        accumulator = 0;
        for (i=0 ; i < 3; i = i + 1) begin
            accumulator = accumulator + (shift_reg[i] * kernel[i]);
        end
    end
    // Output convolution result
    always @(posedge clk) begin
        output_data <= accumulator;
    end
endmodule