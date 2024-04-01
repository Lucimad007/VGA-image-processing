`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:31:37 03/29/2024 
// Design Name: 
// Module Name:    sobel_edge_detector 
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
module sobel_edge_detector(
    input clk,
   // input [7:0] pixel_value, // Input grayscale value
    output reg edge_detected, // Indicates whether an edge is detected
    output reg [7:0] out // Output for edge-detected pixel value
);
    reg [15:0] gradient_magnitude; 
	 reg [15:0] addr;   // Address for working with pixel values from ROM
    wire [7: 0] rom_data; 
	 
	 initial begin 
	 addr =0;
	 end
	 
	 //Image ROM instance for reading pixels

	Image_ROM image_rom (
		.clka(clk), // input clka
		.addra(addr), // input [15 : 0] addra
		.douta(rom_data) // output [7 : 0] douta
	);

    reg signed [2:0] sobel_X_kernel[0:2]; // Define an array with 3 elements
    reg signed [2:0] sobel_Y_kernel[0:2]; // Define an array with 3 elements
	 
    initial begin
        sobel_X_kernel[0] = 3'sb111;
        sobel_X_kernel[1] = 3'sb000;
        sobel_X_kernel[2] = -3;
        sobel_Y_kernel[0] = 3'sb111;
        sobel_Y_kernel[1] = 3'sb110;
        sobel_Y_kernel[2] = 3;
    end
	 
    // Convolution results
    wire signed [15:0] conv_x;
    wire signed [15:0] conv_y;
	 
  // Convolution with Sobel X kernel
    convolution sobel_conv_x (
        .clk(clk),
        .input_data(rom_data), // Use ROM data directly
		  .kernel({sobel_X_kernel[0],sobel_X_kernel[1],sobel_X_kernel[2]}),
        .output_data(conv_x)
    );
  
   // Convolution with Sobel Y kernel
    convolution sobel_conv_y (
        .clk(clk),
      //  .input_data(rom_data), // Use ROM data directly
			.input_data(rom_data), // Use ROM data directly
      
		 .kernel({sobel_Y_kernel[0],sobel_Y_kernel[1],sobel_Y_kernel[2]}),
        .output_data(conv_y)
    );
   
  	// Calculate gradient magnitude and determine edge detection
    always @(posedge clk) begin
        out <= rom_data;
        addr <= addr + 1;
        if (addr ==50176 ) addr <= 0; // Reset address when we reach the end of the image
        gradient_magnitude = conv_x + conv_y; // Calculate gradient magnitude
        // Thresholding
        if (gradient_magnitude > 100) // Threshold is 100
            edge_detected <= 1'b1; // Edge detected
        else
            edge_detected <= 1'b0;
        // Output pixel value based on edge detection
        if (edge_detected)
            out <= 8'b11111111; // White
        else
            out <= 8'b00000000; // Black
    end
endmodule