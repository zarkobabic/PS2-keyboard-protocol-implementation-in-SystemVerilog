module ps2 (input PS2_KBCLK,
            input PS2_KBDAT,
            input rst_n,
            input computerClk,
            output [15:0]hexo);
    
    
    wire PS2_KBCLK_DEB;
    
    assign hexo = display_bin_code_reg;


    reg parity_reg, parity_next;
    reg [1:0] state_reg, state_next;
    reg [3:0] n_reg, n_next;
    reg [8:0] data_reg, data_next;
    reg [15:0] bin_code_reg, bin_code_next;
    reg [15:0] display_bin_code_reg, display_bin_code_next;
    reg  counter_reg, counter_next;
    
    deb deb0(computerClk, rst_n, PS2_KBCLK, PS2_KBCLK_DEB);
    
    localparam waitingForStart = 0;
    localparam sendingData     = 1;
    localparam endProcessing   = 2;
    localparam START           = 0;
    localparam STOP            = 1;
    
   
    
    always @(posedge computerClk, negedge rst_n) begin
        if (!rst_n) begin
            state_reg             <= 2'd0;
            n_reg                 <= 4'd0;
            data_reg              <= 9'd0;
            parity_reg            <= 1'd0;
            bin_code_reg          <= 16'd0;
            counter_reg           <= 1'd0;
            display_bin_code_reg <= 16'd0;
        end
        else begin
            state_reg            <= state_next;
            n_reg                <= n_next;
            data_reg             <= data_next;
            parity_reg           <= parity_next;
            bin_code_reg         <= bin_code_next;
            counter_reg          <= counter_next;
            display_bin_code_reg <= display_bin_code_next;
        end
    end
    //
    always @(negedge PS2_KBCLK_DEB) begin
        state_next            = state_reg;
        n_next                = n_reg;
        data_next             = data_reg;
        parity_next           = parity_reg;
        bin_code_next         = bin_code_reg;
        counter_next          = counter_reg;
        display_bin_code_next = display_bin_code_reg;


        case (state_reg)
            waitingForStart : begin
                if (PS2_KBDAT == START) begin
                    n_next     = 4'd9;
                    data_next  = 9'd0;
                    state_next = sendingData;
                    if(data_reg[7:0] != 8'he0 && data_reg[7:0] != 8'hf0) begin
                        bin_code_next = 16'd0;
                        //data_next = 9'd0;
                    end
                end
            end
            sendingData : begin
               
                    
                    if (n_reg == 4'd9) begin
                        parity_next = PS2_KBDAT;
                    end
                    else begin
                        parity_next = parity_reg ^ PS2_KBDAT;
                    end

                    data_next = (data_reg >> 1'b1) | ({PS2_KBDAT,{8{1'b0}}});
                    
                    if (n_reg == 4'd1) begin
                        state_next = endProcessing;
                    end
                    else begin
                        n_next = n_reg - 1'b1;
                    end
                
            end
            
            endProcessing : begin
                
                if ( PS2_KBDAT == STOP) begin
                    if (parity_reg) begin
                        
                        bin_code_next = (bin_code_reg << 8) | data_reg[7:0];
                        if(counter_reg == 0 || data_reg[7:0] == 8'he0 || data_reg[7:0] == 8'hf0) begin
                            counter_next = 1;
                        end
                        else begin
                            display_bin_code_next = bin_code_next;
                            counter_next = 0;
                        end
                    end
                    else begin
                        //greska u parity bitu
                        display_bin_code_next = 16'hFFFF;
                    end
                    state_next = waitingForStart;
                end
            end
            default: begin
            end
        endcase
    end
    
    
    
endmodule
