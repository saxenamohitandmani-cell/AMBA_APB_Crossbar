// =============================================================================
// Day 1 DUT: 4-bit adder with carry-in and carry-out
//
// Specification:
//   {cout, sum} = a + b + cin
//
// Compile with +define+BUG (make DEFINES=BUG) to plant a bug that your
// testbench should catch.
// =============================================================================
`timescale 1ns/1ps

module adder4 (
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic       cin,
  output logic [3:0] sum,
  output logic       cout
);

`ifdef BUG
  // Planted bug: the carry-in is ignored when a is 4'hF.
  assign {cout, sum} = (a == 4'hF) ? a + b : a + b + cin;
`else
  assign {cout, sum} = a + b + cin;
`endif

endmodule
