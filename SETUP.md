# Simulator Setup

You need a SystemVerilog simulator to run the lessons. Pick one option.

| Option | Cost | Best for | UVM support |
|---|---|---|---|
| **EDA Playground** (browser) | Free account | Getting started quickly, any operating system | Yes, with commercial simulators |
| **Verilator** (local) | Free, open source | Phase 0 lessons on Linux or WSL | Partial; use EDA Playground or a commercial simulator from Day 11 |
| **Questa / Xcelium / VCS / Riviera-PRO** (local) | Commercial licence | Full SystemVerilog and UVM | Yes |

---

## Option 1: EDA Playground

1. Open EDA Playground and create a free account. Some commercial simulators require a verified account.
2. Copy the lesson's `testbench.sv` into the **Testbench** pane (left) and `design.sv` into the **Design** pane (right).
3. Under **Tools & Simulators**, select a SystemVerilog simulator such as Aldec Riviera-PRO or Siemens Questa.
4. For UVM lessons (Day 11 onwards), select **UVM 1.2** under **Libraries**.
5. To pass a define (for example, the planted bugs), add `+define+BUG` to **Compile Options**.
6. Click **Run**.

The simulators offered depend on your account.

---

## Option 2: Verilator (Linux or WSL)

Verilator 5 or later is required (the lessons use `--timing`).

**Ubuntu/Debian:**

```bash
sudo apt install verilator make g++
```

Check the version:

```bash
verilator --version
```

If your distribution ships Verilator 4.x, install a newer version from source by following the official Verilator installation guide.

**Windows:** install WSL (Ubuntu) first, then follow the Ubuntu steps inside WSL.

Run a lesson:

```bash
make SIM=verilator
```

Some prebuilt Verilator packages need the coroutine flag passed to the C++ compiler. If you see `the <coroutine> header requires -fcoroutines`, run:

```bash
make VERILATOR_FLAGS="-CFLAGS -fcoroutines"
```

---

## Option 3: Commercial Simulator

If you have a licence (for example, at work, if your company allows personal training use), run:

```bash
make SIM=questa
```

Other values: `xcelium`, `vcs`, `riviera`. The commands are in [scripts/common.mk](scripts/common.mk).
