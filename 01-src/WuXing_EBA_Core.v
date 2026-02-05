```verilog
// 文件名: WuXing_EBA_Core.v
// 世界首个中医辨证思维硬件驾驶模拟器核心
module WuXing_EBA_Core(
    input wire clk_6Hz, // 6Hz天地心跳 (167ms)
    input wire rst_n, // 复位信号
    output reg [4:0] state, // [金Jin,木Mu,水Shui,火Huo,土Tu]
    output wire [9:0] rel_act
);
always @(posedge clk_6Hz or negedge rst_n) begin
    if (!rst_n) state <= 5‘b00001; // 始于土
    else begin
        state[4] <= (state[0] & ~state[1]) ^ (state[2] & ~state[3]);
        state[3] <= (state[2] & ~state[4]) ^ (state[1] & ~state[0]);
        state[2] <= (state[4] & ~state[0]) ^ (state[3] & ~state[1]);
        state[1] <= (state[3] & ~state[2]) ^ (state[0] & ~state[4]);
        state[0] <= (state[1] & ~state[3]) ^ (state[4] & ~state[2]);
    end
end
assign rel_act[9] = state[4] & state[2]; // 金生水
assign rel_act[8] = state[2] & state[3]; // 水生木
assign rel_act[7] = state[3] & state[1]; // 木生火
assign rel_act[6] = state[1] & state[0]; // 火生土
assign rel_act[5] = state[0] & state[4]; // 土生金
assign rel_act[4] = state[4] & ~state[3]; // 金克木
assign rel_act[3] = state[3] & ~state[0]; // 木克土
assign rel_act[2] = state[0] & ~state[2]; // 土克水
assign rel_act[1] = state[2] & ~state[1]; // 水克火
assign rel_act[0] = state[1] & ~state[4]; // 火克金
endmodule
```
