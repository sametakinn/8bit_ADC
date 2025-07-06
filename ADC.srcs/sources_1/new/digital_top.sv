module digital_top(
    input        rst_n,
    input        clk,
    input        adc_comp,
    output [9:0] adc_channel_sel,
    output       adc_sample,
    output [7:0] adc_vref
    );
    
    logic       adc_data_en;
    logic [7:0] adc_data;
    logic [3:0] adc_data_addr;
    
    adc DUT1(
        .clk(clk),
        .rst_n(rst_n),
        .adc_comp(adc_comp),
        .adc_data(adc_data),
        .adc_vref(adc_vref),
        .adc_sample(adc_sample),
        .adc_data_en(adc_data_en),
        .adc_data_addr(adc_data_addr),
        .adc_channel_sel(adc_channel_sel)
        );
    
    regbank DUT2(
        .clk(clk),
        .rst_n(rst_n),
        .adc_data_en(adc_data_en),
        .adc_data(adc_data),
        .adc_data_addr(adc_data_addr)
        );
        

endmodule
