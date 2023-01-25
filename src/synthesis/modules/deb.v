module deb (input clk,
            input rst_n,
            input in,
            output out);
    reg out_next, out_reg;
    reg [1:0] ff_next, ff_reg;
    reg [7:0] cnt_next, cnt_reg;
    assign out        = out_reg;
    assign in_changed = ff_reg[0] ^ ff_reg[1];
    assign in_stable  = (cnt_reg == 3'b111) ? 1'b1 : 1'b0;
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            out_reg <= 1'b0;
            ff_reg  <= 2'b00;
            cnt_reg <= 8'h00;
        end
        else begin
            out_reg <= out_next;
            ff_reg  <= ff_next;
            cnt_reg <= cnt_next;
        end
        always @(*) begin
            ff_next[0] = in;
            ff_next[1] = ff_reg[0];
            cnt_next   = in_changed ? 0 : (cnt_reg + 1'b1);
            out_next   = in_stable ? ff_reg[1] : out_reg;
        end
endmodule
