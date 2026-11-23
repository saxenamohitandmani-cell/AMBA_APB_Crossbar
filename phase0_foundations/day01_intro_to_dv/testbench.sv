// =============================================================================
// Day 1 testbench: a self-checking testbench for adder4
//
// It shows the three building blocks every testbench has:
//   1. Stimulus  - drive values into the DUT
//   2. Reference - compute what the spec says the output must be
//   3. Checker   - compare the DUT output with the reference and report
// =============================================================================
`timescale 1ns/1ps

module tb;

  // ---------------------------------------------------------------------------
  // Signals connected to the DUT
  // ---------------------------------------------------------------------------
  logic [3:0] a, b;
  logic       cin;
  logic [3:0] sum;
  logic       cout;

  int unsigned checks = 0;
  int unsigned errors = 0;

  // ---------------------------------------------------------------------------
  // DUT instance
  // ---------------------------------------------------------------------------
  adder4 dut (
    .a   (a),
    .b   (b),
    .cin (cin),
    .sum (sum),
    .cout(cout)
  );

  // ---------------------------------------------------------------------------
  // Reference model: what the specification says the adder must produce
  // ---------------------------------------------------------------------------
  function automatic logic [4:0] expected(input logic [3:0] x, y, input logic c);
    return x + y + c;   // 5-bit result: {cout, sum}
  endfunction

  // ---------------------------------------------------------------------------
  // Drive one set of inputs, wait for the logic to settle, and check the output
  // ---------------------------------------------------------------------------
  task automatic check(input logic [3:0] x, y, input logic c);
    logic [4:0] exp;

    a   = x;
    b   = y;
    cin = c;
    #1;                       // let the combinational logic settle

    exp = expected(x, y, c);
    checks++;

    // !== also catches X and Z values, which == would miss
    if ({cout, sum} !== exp) begin
      errors++;
      $display("[%0t] FAIL: a=%0d b=%0d cin=%0d -> got cout=%0b sum=%0d, expected cout=%0b sum=%0d",
               $time, x, y, c, cout, sum, exp[4], exp[3:0]);
    end
  endtask

  // ---------------------------------------------------------------------------
  // Test sequence
  // ---------------------------------------------------------------------------
  initial begin
    // Print %t values in nanoseconds: unit 10^-9, 0 decimals, " ns" suffix
    $timeformat(-9, 0, " ns", 0);
    $display("=== Day 1: adder4 self-checking testbench ===");

    // 1. Directed tests: hand-picked interesting cases
    check(4'd0,  4'd0,  1'b0);   // all zeros
    check(4'd3,  4'd4,  1'b0);   // simple addition
    check(4'd15, 4'd1,  1'b0);   // overflow -> carry out
    check(4'd15, 4'd15, 1'b1);   // maximum values

    // 2. Exhaustive test: every combination (16 x 16 x 2 = 512)
    for (int i = 0; i < 16; i++)
      for (int j = 0; j < 16; j++)
        for (int c = 0; c < 2; c++)
          check(4'(i), 4'(j), 1'(c));

    // 3. Final report
    if (errors == 0)
      $display("TEST PASSED: %0d checks, 0 errors", checks);
    else
      $display("TEST FAILED: %0d checks, %0d errors", checks, errors);

    $finish;
  end

endmodule
