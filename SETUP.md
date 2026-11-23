# Simulator Setup

This course uses **Questa** as the main simulator. Every lesson includes a `run.do` script for Questa and a `Makefile` that also supports other simulators.

| Option | Cost | Notes |
|---|---|---|
| **Questa** (recommended) | Commercial licence | Full SystemVerilog, SVA, coverage, and UVM. Used by most companies. |
| **EDA Playground** (browser) | Free account | No installation. Useful when you are away from your Questa machine. |
| **Verilator** (local) | Free, open source | Phase 0 lessons only; partial UVM support |

---

## Option 1: Questa

### Licence

- **Work licence:** if you use your company's Questa installation, check that your company allows personal training use.
- **Free option:** Intel offers a free *Questa*-Intel FPGA Starter Edition licence through the Intel FPGA software download pages. Check that the edition you get supports the SystemVerilog features this course needs (classes, randomization, coverage, and UVM).

### Run a lesson in the Questa GUI

1. Open Questa.
2. In the **Transcript** window, go to the lesson folder:

   ```tcl
   cd <path-to-repo>/phase0_foundations/day01_intro_to_dv
   ```

3. Run the lesson script:

   ```tcl
   do run.do
   ```

4. To compile with a define, such as a planted bug, pass it as an argument:

   ```tcl
   do run.do BUG
   ```

The script creates a fresh `work` library, compiles `design.sv` and `testbench.sv`, loads the simulation, adds all signals to the **Wave** window, and runs to the end.

### Run a lesson from a terminal (batch mode)

From the lesson folder:

```bash
vsim -c -do "do run.do; quit -f"
```

On Linux, you can also use the Makefile. Questa is the default simulator:

```bash
make
```

```bash
make DEFINES=BUG
```

Make sure the Questa `bin` directory is on your `PATH` (`vsim`, `vlog`, and `vlib` must be found).

---

## Option 2: EDA Playground

1. Open EDA Playground and create a free account. Some commercial simulators require a verified account.
2. Copy the lesson's `testbench.sv` into the **Testbench** pane (left) and `design.sv` into the **Design** pane (right).
3. Under **Tools & Simulators**, select a SystemVerilog simulator such as Siemens Questa or Aldec Riviera-PRO.
4. For UVM lessons (Day 11 onwards), select **UVM 1.2** under **Libraries**.
5. To pass a define (for example, the planted bugs), add `+define+BUG` to **Compile Options**.
6. Click **Run**.

The simulators offered depend on your account.

---

## Option 3: Verilator (Linux or WSL)

Verilator 5 or later is required (the lessons use `--timing`). On Ubuntu/Debian:

```bash
sudo apt install verilator make g++
```

Run a lesson:

```bash
make SIM=verilator
```

Some prebuilt Verilator packages need the coroutine flag passed to the C++ compiler. If you see `the <coroutine> header requires -fcoroutines`, run:

```bash
make SIM=verilator VERILATOR_FLAGS="-CFLAGS -fcoroutines"
```

---

## Other Commercial Simulators

The Makefile also supports `xcelium`, `vcs`, and `riviera`:

```bash
make SIM=xcelium
```

The commands are in [scripts/common.mk](scripts/common.mk).
