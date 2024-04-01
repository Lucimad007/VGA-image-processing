`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:59:14 03/31/2024
// Design Name:   sobel_edge_detector
// Module Name:   E:/IUT_FPGA_ImageProcessing/sobel_testbench.v
// Project Name:  IUT_FPGA_ImageProcessing
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sobel_edge_detector
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module sobel_testbench;
   // Inputs
    reg clk;
    integer file_handle, final_file_handle;
    // Outputs
    reg [7:0] pixel_value_input;
    wire edge_detected;
    wire [7:0] out;
    reg [7:0] temp;
    //reg temp;
	 // Memory to store pixel values
    reg [7:0] memory [0:65535];
    integer i =0;
	 integer j;
	 
	 Image_ROM image_rom (
		.clka(clka), // input clka
		.addra(addra), // input [15 : 0] addra
		.douta(douta) // output [7 : 0] douta
	 );
	 
    // Instantiate the sobel_edge_detector module
    sobel_edge_detector sobel_detector (
        .clk(clk),
        .pixel_value(pixel_value_input),
        .edge_detected(edge_detected),
        .out(out)
    );
  
    // Clock generation
		always #5 clk = ~clk;
    
    // Initial values
    initial begin
        // Open the binary file for reading
     
        file_handle = $fopen("E:/final_fgpa_proj/bn.txt", "r");
        final_file_handle = $fopen("E:/final_fgpa_proj/final3.txt", "w");
		  
		  if(file_handle == -1) begin
			$display("Error while opening the input file");
			$finish;
		  end 
        // Run the simulation
        #10;
        
        // Read binary data from the file and store it in memory
       // integer i = 0;
      
		  while (i < 65530) begin
            // Read one byte (8 bits) from the file
				
			$fscanf(file_handle, "%b", temp);
           memory[i] = temp;
           i = i + 1;
			 $display("Read Value : %b", temp);
        end
        
        // Close the file
        $fclose(file_handle);
        
        // Process each pixel through the Sobel edge detector
     //   integer j;
        for (j = 0; j < 65536; j = j + 1) begin
            // Set the pixel value input
            pixel_value_input = memory[j];
            
            // Wait for one clock cycle
            #1;
            
            // Write the edge detection result to the final file
            if (edge_detected) begin
                $fwrite(final_file_handle, "11111111");
            end else begin
                $fwrite(final_file_handle, "00000000");
            end
        end
        
        // Close the final file
        $fclose(final_file_handle);
        
        // Stop the simulation
        $finish;
    end
    
endmodule








