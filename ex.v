`include"defines.v"

module ex(
    input wire rst,
    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,

    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [`RegBus] wdata_o

);

    reg [`RegBus] logicout;

    always @ (*) begin
    if(rst == `RstEnable) begin
        logicout <= `ZeroWord;
    end else begin
        case (aluop_i)
        `EXE_OR_OP: begin
            logicout <= reg1_i | reg2_i;
        end        
        default: begin
            logicout <= `ZeroWord;
        end   
        endcase
    end
    end

    always @(*) begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case ( alusel_i)
        `EXE_RES_LOGIC:begin
	 		wdata_o <= logicout;
	 	end
	 	default:					begin
        wdata_o <= `ZeroWord;
        end 
    endcase
    end
endmodule
// pt.1 依据输入的运算子类型进行运算，结果保存在logicout
// pt.2 给出最终的运算结果，包括是否要写目标寄存器，目标寄存器的地址，数据