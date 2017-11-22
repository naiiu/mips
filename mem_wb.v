`include"defines.v"

module mem_wb(
    input wire clk,
    input wire rst,

    input wire[`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire mem_wdata,

    output reg[`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg wb_wdata

);

    always @ (posedge clk) begin
      if(rst == `RstEnable) begin
        wb_wd <= `NOPRegAddr;
        wb_wdata <= `ZeroWord;
        wb_wreg <= `WriteDisable;
      end else begin
        wb_wd <= mem_wd;
        wb_wdata <= mem_wdata;
        wb_wreg <= mem_wreg;
      end
    end
endmodule

//传至回写