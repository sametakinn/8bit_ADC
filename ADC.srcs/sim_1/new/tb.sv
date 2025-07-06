`timescale 1ns / 1ps
module tb ();

  logic        clk   = 0              ;
  logic        rst_n = 0              ;
  logic        adc_comp               ;
  logic [7:0]  adc_vref               ;
  logic [7:0]  ana_volt               ;
  logic        adc_sample             ;
  logic [9:0]  adc_channel_sel        ;
  logic [7:0]  analog_values [9:0]    ;
  logic [31:0] current_time_us = 0    ;     
  logic [7:0]  ana_volt               ;     
  logic [31:0] next_update_time [9:0] ;     
  logic [7:0]  expected               ;
  int          ch_id                  ;
  
 
  always #500ns clk = ~clk;

  // Reset atýmý
  initial begin
    rst_n = 0;
    #50us;
    rst_n = 1;
  end

 
  digital_top top(
    .rst_n(rst_n),
    .clk(clk),
    .adc_comp(adc_comp),
    .adc_channel_sel(adc_channel_sel),
    .adc_sample(adc_sample ),
    .adc_vref(adc_vref)
  );
    

  // Basit ADC modeli
  adc_model DUT2(
    .rst_n(rst_n),
    .adc_sample(adc_sample),
    .vref_i(adc_vref),
    .ana_volt(ana_volt),
    .comp_out_o(adc_comp)
  );

  
  // Test senaryosu
  initial begin
    #50us;
    $display("test started!");
    #1360us;
    rst_n = 0;  // tekrar resetleme
    $display("system was reseted again");
    #100us;    
    rst_n = 1;
    #1360us;
    $display("All tests done!");
    $finish;
  end
  

// rastgele atama her channel için
initial begin
    #50us;
    forever begin
        analog_values[0] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[1] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[2] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[3] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[4] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[5] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end
initial begin
    #50us;
    forever begin
        analog_values[6] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[7] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[8] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end

initial begin
    #50us;
    forever begin
        analog_values[9] = $urandom_range(0, 255);
        #($urandom_range(50, 100)*1us);
    end
end


always @(posedge clk) begin
    if (rst_n && top.DUT1.adc_data_en) begin
        
        ch_id = top.DUT1.adc_data_addr;
        expected = DUT2.sampled_volt;
        #1us;
        // Assert ile karþýlaþtýrma
        assert (top.DUT2.memory[ch_id] === expected)
            else $error("t=%0t us: CH%0d için expected=%02h, memory=%02h",
                        $time/1us, ch_id, expected, top.DUT2.memory[ch_id]);

        // Doðruysa bilgi mesajý yazdýr
        if (top.DUT2.memory[ch_id] === expected)
            $display("t=%0t us: CH%0d expected=%02h, memory=%02h Successful",
                     $time/1us, ch_id, expected, top.DUT2.memory[ch_id]);
    end
end

 
always @(*) begin
  case (adc_channel_sel)
    10'b0000000001: ana_volt = analog_values[0];
    10'b0000000010: ana_volt = analog_values[1];
    10'b0000000100: ana_volt = analog_values[2];
    10'b0000001000: ana_volt = analog_values[3];
    10'b0000010000: ana_volt = analog_values[4];
    10'b0000100000: ana_volt = analog_values[5];
    10'b0001000000: ana_volt = analog_values[6];
    10'b0010000000: ana_volt = analog_values[7];
    10'b0100000000: ana_volt = analog_values[8];
    10'b1000000000: ana_volt = analog_values[9];
    default:        ana_volt = 8'd0;
  endcase
end


endmodule
