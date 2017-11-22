`include"defines.v"
module regfile(
    input wire clk,
    input wire rst,

    // write Port
    input wire we,
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus] wdata,

    //Read Port 1
    input wire re1,
    input wire [`RegAddrBus] raddr1,
    output reg [`RegBus] rdata1,

    //Read Port2
    input wire re2,
    input wire [`RegAddrBus] raddr2,
    output reg[`RegBus] rdata2
);

// pt.1 define reg

reg[`RegBus] regs[0:`RegNum -1];

//Pt.2 wirte

    always @ (posedge clk) begin
        if(rst == `RstDisable) begin
            if((we == `WriteEnable) && (waddr != `RegNumLog2'h0) )begin
                regs[waddr] <= wdata;
            end
        end
    end

//Pt.3 Read PORT1

    always @ (*) begin
        if(rst ==`RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if(raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end else if((raddr1 == waddr) && (we == `WriteEnable)&&(re1 == `ReadEnable)) begin
            rdata1 <= wdata;
        end else if(re1 ==`ReadEnable) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

// Pt.4 Port2
    always @ (*) begin
        if(rst ==`RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if(raddr1 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end else if((raddr2 == waddr) && (we == `WriteEnable)&&(re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end else if(re2 ==`ReadEnable) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
    
endmodule

//Pt.1 定义32个通用寄存器
//Pt.2 复位信号无效、写使能有效、目标寄存器不等于0，将数据保存到目标寄存器
//Pt.3 1.复位信息有效，始终输出0
//     2.复位信号无效，读取$0 输出0
//     3.如果第一个读寄存器端口要读取的目标寄存器与要写入的目的寄存器相同，将要写入的值作为第一个读寄存器端口的输出
//     4.如果第一个端口不使用， 输出0
//Pt.4 同上