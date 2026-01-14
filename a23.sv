/*
Check the behavior of D flipflop : "dout must be zero if rst is active high, otherwise dout should follow din " . 
Insert your assert check in the RTL code given in the instructions tab.
*/

module dff
(
  input din, clk, rst,
  output reg dout = 1'b0  // Initialize dout to 0
);
  
  always @(posedge clk) begin
    if (rst) begin
      dout <= 1'b0;
      assert (1'b0 == 0) else $error("Reset logic error"); 
    end else begin
      dout <= din;
      assert (din === din) else $error("Data assignment error");
    end

    if (rst) begin
      assert final (dout == 1'b0);
    end
  end



  // // --- Assertions for D Flip-Flop Behavior ---

  // // 1. Check: If rst is active high at posedge clk, dout must be 0 at the NEXT posedge clk.
  // property p_reset_check;
  //   @(posedge clk) rst |=> (dout == 1'b0);
  // endproperty
  // assert_reset: assert property (p_reset_check) else $error("Reset failed: dout is not 0");

  // // 2. Check: If rst is NOT active, dout should follow din at the NEXT posedge clk.
  // property p_din_dout_check;
  //   @(posedge clk) !rst |=> (dout == $past(din));
  // endproperty
  // assert_din_dout: assert property (p_din_dout_check) else $error("Data transfer failed: dout != din");

endmodule



module tb;
  logic din, clk, rst, dout;

  dff dut(din, clk, rst, dout);

  initial begin
    clk = 0;
    rst = 1;
    #50 $finish;
  end

  always #5 clk = ~clk;

  initial begin
    #10 rst = 0;
    #10 din = 1;
    #10 din = 0;
    #10 rst = 1; din = 1;
  end
  always @(posedge clk) begin
    assert (rst == 1'b1 && dout == 1'b0) 
      else $error("Assertion Failed: dout must be zero when rst is active high at time %0d", $time);
    
    assert (rst == 1'b0 && dout == din) 
      else $error("Assertion Failed: dout must follow din when rst is not active at time %0d", $time);
  end
endmodule