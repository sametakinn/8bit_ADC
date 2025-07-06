module adc(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       adc_comp,
    output logic [7:0] adc_data,
    output logic [7:0] adc_vref,
    output logic       adc_sample,
    output logic       adc_data_en,
    output logic [3:0] adc_data_addr,
    output logic [9:0] adc_channel_sel
    );
    
    logic [2:0] cntr;
    logic [2:0] adc_bit_cntr;
    logic [2:0] adc_bit_cntr_d;
    logic [7:0] adc_data_d;
    logic [7:0] adc_vref_d;
    logic [7:0] adc_data_o; 
    logic [9:0] adc_channel_sel_o_d;
    logic       adc_sample_d;
    
    // counter
    always_ff @(posedge clk or negedge rst_n) begin 
        if(!rst_n) begin
            cntr <= 3'b000;
        end else begin
            cntr <= cntr + 1'b1;
        end
    end
    
   // adc_bit_cntr and adc_bit_cntr_d
    assign adc_bit_cntr_d = (cntr == 7) ? adc_bit_cntr + 3'd1 : adc_bit_cntr;

    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) 
            adc_bit_cntr <= 3'b000;
        else 
            adc_bit_cntr <= adc_bit_cntr_d;
    end

  
    always_comb begin
        if(cntr == 3'b111) begin
            case (adc_bit_cntr_d) 
                3'b000: adc_vref_d =                             8'b1000_0000;
                3'b001: adc_vref_d = {                adc_comp,7'b100_0000};
                3'b010: adc_vref_d = {adc_vref[7  ],adc_comp,6'b10_0000};
                3'b011: adc_vref_d = {adc_vref[7:6],adc_comp,5'b1_0000};
                3'b100: adc_vref_d = {adc_vref[7:5],adc_comp,4'b1000};
                3'b101: adc_vref_d = {adc_vref[7:4],adc_comp,3'b100};
                3'b110: adc_vref_d = {adc_vref[7:3],adc_comp,2'b10};
                3'b111: adc_vref_d = {adc_vref[7:2],adc_comp,1'b1};
                default: adc_vref_d = adc_vref; 
            endcase 
        end else 
            adc_vref_d = adc_vref;
    end
    
    assign adc_data_d = (adc_bit_cntr == 7) ? {adc_vref[7:1], adc_comp} : // Store
                                                             adc_data_o ; // Keep
                                                                                                                 
     // adc_vref out
    always_ff @ (posedge  clk or negedge rst_n) begin
          if (!rst_n) 
              adc_vref <= 8'h80;
          else      
              adc_vref <= adc_vref_d;
    end
    
    // adc_data out
    always_ff @ (posedge clk or negedge rst_n) begin
        if (!rst_n) 
            adc_data_o <= 8'd0;
        else
            adc_data_o <= adc_data_d;
    end
    
    assign adc_data = adc_data_o;
    
 
    // adc_sample generation
    assign adc_sample_d = (adc_bit_cntr_d == 7) ? 1'b1 : 1'b0;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            adc_sample <= 1'b1;
        else
            adc_sample <= adc_sample_d;
    end
    
    // adc_data_en generation
    assign adc_data_en = (cntr==7) && (adc_sample == 1); 
    
    // adc_channel_sel_o_d generation
    always_ff @(posedge clk or negedge rst_n)begin 
        if (!rst_n)
            adc_channel_sel_o_d <= 10'b00_0000_0001;
        else if (adc_sample & cntr == 7 )       
                adc_channel_sel_o_d <= {adc_channel_sel[8:0],adc_channel_sel[9]}; // rotating left  
    end
    
    // adc_channel_sel out
    assign adc_channel_sel = adc_channel_sel_o_d;
    
    // adc_data_addr generation according to adc_channel_sel
    assign adc_data_addr = (adc_channel_sel == 10'b0000000001) ? 4'd0 :
                           (adc_channel_sel == 10'b0000000010) ? 4'd1 :
                           (adc_channel_sel == 10'b0000000100) ? 4'd2 :
                           (adc_channel_sel == 10'b0000001000) ? 4'd3 :
                           (adc_channel_sel == 10'b0000010000) ? 4'd4 :
                           (adc_channel_sel == 10'b0000100000) ? 4'd5 :
                           (adc_channel_sel == 10'b0001000000) ? 4'd6 :
                           (adc_channel_sel == 10'b0010000000) ? 4'd7 :
                           (adc_channel_sel == 10'b0100000000) ? 4'd8 :
                           (adc_channel_sel == 10'b1000000000) ? 4'd9 : 4'd0;
                           
                           
endmodule

