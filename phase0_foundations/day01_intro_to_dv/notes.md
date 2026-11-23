# Day 1: Introduction to Design Verification

**Goal:** understand what design verification (DV) is, and write and run your first self-checking testbench.

**Files in this folder**

| File | What it is |
|---|---|
| `design.sv` | The design under test (DUT): a 4-bit adder |
| `testbench.sv` | A self-checking testbench for the adder |
| `run.do` | Runs the simulation in Questa (see [How to Run](#5-how-to-run)) |
| `Makefile` | Runs the simulation from a Linux terminal with any supported simulator |
| `notes.md` | These notes |

---

## 1. What Is Design Verification?

A chip is designed from a **specification** (spec): a document that says what the design must do. Designers write **RTL** (Register Transfer Level code, in Verilog or SystemVerilog) that implements the spec.

**Design verification** answers one question: *does the RTL do what the spec says, in every situation that matters?*

Bugs found after a chip is manufactured are extremely expensive: a re-spin costs months and millions. That is why verification usually takes more engineering effort than the design itself, and why DV engineers are in demand.

**Two mindsets**

| Designer | Verification engineer |
|---|---|
| "How do I make this work?" | "How can I make this break?" |
| Builds the implementation | Builds an independent model of what *should* happen |
| Reads the spec to implement it | Reads the spec to find every scenario to test |

The key word is **independent**: if the verification engineer copies the designer's assumptions, both make the same mistake and the bug escapes.

---

## 2. The Verification Flow

```text
Specification
     │
     ▼
Verification plan  ──►  What features, scenarios, and corner cases must be tested?
     │
     ▼
Testbench          ──►  Stimulus + reference model + checkers
     │
     ▼
Tests              ──►  Directed tests and constrained-random tests
     │
     ▼
Simulate & debug   ──►  Find failures, decide: DUT bug or testbench bug?
     │
     ▼
Coverage           ──►  Did we actually test everything in the plan?
     │
     ▼
Regression         ──►  Run all tests (many seeds) every time the design changes
     │
     ▼
Sign-off           ──►  Plan complete, coverage closed, regressions clean
```

You will practise every one of these steps in this course.

---

## 3. Key Terms

| Term | Meaning |
|---|---|
| **DUT** | Design Under Test: the RTL being verified |
| **Testbench** | The code around the DUT that drives inputs and checks outputs. It is not synthesized into hardware. |
| **Stimulus** | The input values driven into the DUT |
| **Reference model** | Code that computes the *expected* output from the spec |
| **Checker / scoreboard** | Compares the DUT's actual output with the expected output |
| **Directed test** | Hand-picked input values for a specific scenario |
| **Constrained-random test** | Random inputs within legal limits (constraints), to hit cases you didn't think of |
| **Coverage** | A measure of what has been tested. *Code coverage* = which lines of RTL ran; *functional coverage* = which spec features and scenarios were exercised. |
| **Assertion** | A rule about signal behaviour that is checked automatically during simulation |
| **Regression** | Running the whole test suite, typically every night or on every change |
| **Seed** | The number that starts the random generator; the same seed reproduces the same random test |

---

## 4. Code Walkthrough

### 4.1 The DUT (`design.sv`)

The specification is one line: `{cout, sum} = a + b + cin`.

```systemverilog
assign {cout, sum} = a + b + cin;
```

`{cout, sum}` is a **concatenation**: a 5-bit value whose top bit is `cout` and lower 4 bits are `sum`. Because the left side is 5 bits wide, the addition is done in 5 bits, so the carry is not lost.

The file also contains a **planted bug** that is compiled only when you define `BUG`. You will use it in the exercises.

### 4.2 The testbench (`testbench.sv`)

Every testbench, from this 90-line example to a large UVM environment, has the same three parts:

| Part | In this testbench |
|---|---|
| **Stimulus** | The `check()` task drives `a`, `b`, and `cin` |
| **Reference model** | The `expected()` function computes `a + b + cin` independently of the DUT |
| **Checker** | `if ({cout, sum} !== exp)` compares and reports mismatches |

Important details:

- **`#1` delay:** after the inputs change, the testbench waits 1 ns before reading the outputs, so the DUT's logic has updated. Reading outputs in the same time step as driving inputs is a classic source of *race conditions* (Day 4 covers this in depth).
- **`!==` instead of `!=`:** `!==` is the *case inequality* operator. It compares X and Z bits literally. With `!=`, a comparison involving X gives X, which an `if` treats as false, so **an X on the output would silently pass**. Always use `===`/`!==` in checkers.
- **Self-checking:** the testbench decides PASS or FAIL by itself and prints a summary. You never have to inspect waveforms to know whether the test passed. Every test you write in this course will be self-checking.
- **Directed + exhaustive tests:** four hand-picked cases first, then every one of the 512 input combinations. Exhaustive testing works here only because the adder is tiny.
- **`$timeformat(-9, 0, " ns", 0)`** makes `%t` print times in nanoseconds. Without it, `%t` uses the simulation precision (picoseconds here), and 4 ns would print as `4000`.

---

## 5. How to Run

### Option A: Questa GUI (recommended)

1. Open Questa.
2. In the **Transcript** window, go to this lesson's folder and run the script:

   ```tcl
   cd <path-to-repo>/phase0_foundations/day01_intro_to_dv
   do run.do
   ```

3. The results appear in the Transcript, and all signals are added to the **Wave** window.

To run with the planted bug:

```tcl
do run.do BUG
```

### Option B: Questa from a terminal (batch mode)

From this folder:

```bash
vsim -c -do "do run.do; quit -f"
```

```bash
vsim -c -do "do run.do BUG; quit -f"
```

On Linux you can also use the Makefile:

```bash
make SIM=questa
```

```bash
make SIM=questa DEFINES=BUG
```

### Other simulators

The Makefile also supports `verilator`, `icarus`, `xcelium`, `vcs`, and `riviera` (for example, `make SIM=verilator`). You can also paste `design.sv` and `testbench.sv` into EDA Playground. See [SETUP.md](../../SETUP.md).

### Expected output

Without the bug:

```text
=== Day 1: adder4 self-checking testbench ===
TEST PASSED: 516 checks, 0 errors
```

With `DEFINES=BUG`, the first lines are:

```text
=== Day 1: adder4 self-checking testbench ===
[4 ns] FAIL: a=15 b=15 cin=1 -> got cout=1 sum=14, expected cout=1 sum=15
[486 ns] FAIL: a=15 b=0 cin=1 -> got cout=0 sum=15, expected cout=1 sum=0
...
TEST FAILED: 516 checks, 17 errors
```

---

## 6. Exercises

Do these in order. Write your answers in a file called `answers.md` in this folder.

1. **Run it.** Run the testbench without the bug. Why are there exactly 516 checks?
2. **Debug from the log.** Run with `DEFINES=BUG`. Using *only the failure messages* (don't look at `design.sv`), describe the bug in one sentence. What do all failing cases have in common?
3. **Directed vs exhaustive.** Only one of the four directed tests caught the bug. Write a different set of four directed tests that would have caught *nothing*. What does this tell you about relying only on directed tests?
4. **Remove the delay.** Comment out the `#1` in `check()` and run again (without the bug). What happens, and why?
5. **Break the checker.** Change `!==` to `!=`. Then, in `design.sv`, temporarily change the assignment to `assign {cout, sum} = 5'bx;`. Run with `!=` and with `!==`. Explain the difference in results.
6. **Go random.** Exhaustive testing is impossible for a 32-bit adder. Replace the exhaustive loop with 200 random vectors using `$urandom_range(0, 15)` for `a` and `b` and `$urandom_range(0, 1)` for `cin`. Does it still catch the bug? Run it several times; does it always catch it?
   Save your version as `testbench_random.sv` and run it with `make SRCS="design.sv testbench_random.sv"`.

---

## 7. Quiz

Answer first, then expand to check.

<details>
<summary>1. What is the difference between design and verification?</summary>

Design implements the specification in RTL. Verification independently checks that the RTL behaves as the specification requires, in all relevant scenarios, including corner cases and error conditions.
</details>

<details>
<summary>2. What are the three parts of a self-checking testbench?</summary>

Stimulus (drives inputs), a reference model (computes expected outputs from the spec), and a checker (compares actual and expected outputs and reports mismatches).
</details>

<details>
<summary>3. Why should a checker use <code>!==</code> instead of <code>!=</code>?</summary>

`!=` returns X when either operand has X or Z bits, and an `if` treats X as false, so an X output would pass silently. `!==` compares X and Z literally, so the mismatch is reported.
</details>

<details>
<summary>4. How many input combinations does a 32-bit adder with carry-in have? Why does it matter?</summary>

2^32 × 2^32 × 2 = 2^65, about 3.7 × 10^19. Even at a billion checks per second this takes over 1,000 years, so exhaustive testing is impossible. This is why real verification uses constrained-random stimulus plus functional coverage to measure what has been tested.
</details>

<details>
<summary>5. What is a regression, and why is it run repeatedly?</summary>

A regression runs the whole test suite, usually with many random seeds. It is re-run whenever the design or testbench changes, to make sure new changes did not break features that worked before.
</details>

---

## 8. Interview Corner

**Q: How do you know when verification is complete?**

A strong answer mentions several signals together, not just one:

- Every item in the verification plan has a passing test.
- Functional coverage and code coverage goals are met, and any remaining holes are reviewed and waived with a reason.
- Regressions pass consistently across many seeds.
- The bug discovery rate has dropped and stayed low.
- The verification plan, coverage, and waivers have been reviewed with the design team.

---

## 9. Deliverables for Day 1

- [ ] Ran the testbench with and without the bug
- [ ] `answers.md` with answers to exercises 1–6
- [ ] Exercise 6 code committed (keep the original testbench; save yours as `testbench_random.sv`)
- [ ] Quiz attempted

**Next:** [Day 2: RTL Basics for Verification Engineers](../day02_rtl_basics/notes.md)
