module regbank (
    input        clk,
    input        rst_n,
    input        adc_data_en,
    input  [7:0] adc_data,
    input  [3:0] adc_data_addr
    );
   
    logic [7:0] memory [0:9];  // bellek

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset durumunda bellek sýfýrlanýyor
            integer i;
            for (i = 0; i < 10; i = i + 1)
                memory[i] <= 8'd0;
        end else begin
            // Belleðe veri yazma
            if (adc_data_en && adc_data_addr < 10)
                memory[adc_data_addr] <= adc_data;
        end
    end
    
endmodule

