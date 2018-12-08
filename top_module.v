`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: shahbaaz lokhandwala
// 
// Create Date: 12/05/2018 06:50:36 PM
// Design Name: uart with hello world
// Module Name: top_module
// Project Name: hello with uart
// Target Devices: xilinx artix-7 35t
// Tool Versions: 
// Description: this is the RTL design with top module to transmit "hello" to host,
//  the global clock frequency 100mhz is converted to 50mhz, baudrate = 9600
// Dependencies: uart.v file 
// 
// Revision: v1.0
// Revision 0.01 - File Created
// Additional Comments: look at he block level design
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,      // 50Mhz clock recieved by external clocking wizard
    input nrst,     // reset for arty artix-7 is active low, check schematic
    output tx,      // uart tx
    input rx,       // uart rx
    output reg [3:0] led //just to see glowing, nothing to do with logic
    );
    
       // COntrol signals for uart module
       reg transmit_signal = 0;
       wire recieved_signal;
       wire is_receiving;
       wire is_transmitting;
       
       // data reg for uart
       reg[7:0] tx_data=0;
       wire[7:0] rx_data;
     
       //-- Characters counter
       //-- It only counts when the cena control signal is enabled
       reg [2:0] char_count =0;
       reg cena =0;                //-- Counter enable
          
     always @(posedge clk)begin
        if (!nrst)
           char_count <= 0;
        else begin 
            if (transmit_signal_reg)
            char_count <= char_count + 1;
        end
     end
         
          //-- Multiplexer with the 8-character string to transmit
          
      reg[7:0] data =0;
      always @(posedge clk)begin
        case (char_count)
          8'd0: data <= "H";
          8'd1: data <= "e";
          8'd2: data <= "l";
          8'd3: data <= "l";
          8'd4: data <= "o";
          8'd5: data <= "!";
          8'd6: data <= ".";
          8'd7: data <= ".";
          default: data <= ".";
        endcase
      end
      
      reg transmit_signal_reg = 0;
    // logic for uart to send data to host
    always@(posedge clk) begin
        if(!nrst) begin
            tx_data <= 0;
        //    address <= 0;
        end
        else begin
            tx_data <=  data;//"A";//arr_mem[address];
            transmit_signal <= 1'b1;
            if(is_transmitting) begin
                 transmit_signal <= 1'b0;
                 transmit_signal_reg <= transmit_signal;
                 led <= ~led;
            end
        end
    end
    
    // if you want to recieve data, here is the pseudo code for loopback
        // if(recieved_signal)
            //store in temp reg
       // then transmit again
       
   //TODO:- check for 115200 baud rate with 100MHz frequency
    uart UART(
        .clk(clk), // The master clock for this module
        .rst(~nrst), // Synchronous reset.
        .rx(rx), // Incoming serial line
        .tx(tx), // Outgoing serial line
        .transmit(transmit_signal), // Signal to transmit
        .tx_byte(tx_data), // Byte to transmit
        .received(recieved_signal), // Indicated that a byte has been received.
        .rx_byte(rx_data), // Byte received
        .is_receiving(is_receiving), // Low when receive line is idle.
        .is_transmitting(is_transmitting), // Low when transmit line is idle.
        .recv_error() // Indicates error in receiving packet.
        );
endmodule

