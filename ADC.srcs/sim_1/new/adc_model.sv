module adc_model(
    input   logic       rst_n,
    input   logic       adc_sample,    
    input   logic [7:0] vref_i,        
    input   logic [7:0] ana_volt,      
    output  logic       comp_out_o     
    );

    logic [7:0] sampled_volt;     

    always @ (negedge adc_sample) begin 
        #1;                                  //gecikme s�resi tam o anda ana  ana voltta de�i�im oldu�u i�in eski de�erini almas�n diye koyulmu�tur.
        sampled_volt <= ana_volt; 
    end
    always_comb begin
        comp_out_o = (sampled_volt >= vref_i) ? 1'b1 : 1'b0;
    end



endmodule

