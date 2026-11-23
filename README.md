# DV Zero to Hero

A hands-on path from zero to job-ready **Design Verification (DV)** engineer, using SystemVerilog, SVA, functional coverage, and UVM.

Every lesson has its own folder with:

- **`notes.md`**: concepts, code walkthrough, exercises, quiz, and interview questions
- **`design.sv`** and **`testbench.sv`**: runnable code (the same file names EDA Playground uses, so you can paste them directly)
- **`Makefile`**: one command to run the lesson on your simulator

Progress is tracked in [PROGRESS.md](PROGRESS.md).

---

## Quick Start

```bash
git clone <this-repo-url>
```

```bash
cd dv-zero-to-hero/phase0_foundations/day01_intro_to_dv
```

```bash
make
```

Choose a simulator with `SIM=` (`verilator`, `icarus`, `questa`, `xcelium`, `vcs`, `riviera`), for example `make SIM=questa`. To use a browser instead, see [SETUP.md](SETUP.md).

---

## Roadmap

### Phase 0: Foundations (SystemVerilog for verification)

| Day | Topic | Status |
|---|---|---|
| 1 | [Introduction to DV and your first self-checking testbench](phase0_foundations/day01_intro_to_dv/notes.md) | Ready |
| 2 | RTL basics for verification engineers: modules, `always_comb`/`always_ff`, blocking vs non-blocking, FSMs, clocked testbenches | Planned |
| 3 | SystemVerilog data types: 2-state/4-state, packed/unpacked/dynamic arrays, queues, associative arrays, structs, enums | Planned |
| 4 | Procedural code: tasks, functions, `fork`/`join`, events, scheduling regions, race conditions | Planned |
| 5 | Interfaces, modports, clocking blocks, virtual interfaces | Planned |
| 6 | OOP 1: classes, objects, handles, constructors, copying | Planned |
| 7 | OOP 2: inheritance, polymorphism, virtual methods, parameterized classes | Planned |
| 8 | Randomization and constraints | Planned |
| 9 | Mailboxes, semaphores, and a layered (non-UVM) testbench for an APB slave | Planned |
| 10 | Functional coverage and SVA basics | Planned |
| 11 | UVM 101: components, phases, factory, `config_db`, your first UVM test | Planned |

### Phases 1–5: APB Crossbar Project (22-day roadmap)

| Phase | Days | Focus |
|---|---|---|
| 1. Design understanding | 1–4 | APB protocol, crossbar architecture, RTL walkthrough |
| 2. UVM environment | 5–9 | Verification plan, UVM architecture, sequences, driver, monitor, scoreboard |
| 3. Functional verification | 10–15 | Directed, multi-master, arbitration, wait-state, reset/negative, constrained-random tests |
| 4. Assertions, coverage, debug | 16–19 | SVA library, functional coverage, debugging, regression and closure |
| 5. Independent work | 20–22 | Independent assignment, code review, final presentation |

The crossbar RTL contains **hidden bugs**. Finding them with your testbench is part of the project.

### Phase 6: Hero Track

UVM register models (RAL), virtual sequences, an AXI agent, an AXI-to-APB bridge capstone, formal verification basics, a scripted regression flow, and interview preparation.

---

## Repository Layout

```text
dv-zero-to-hero/
├── README.md               This file
├── SETUP.md                Simulator setup
├── PROGRESS.md             Progress tracker
├── scripts/
│   └── common.mk           Shared simulation rules used by every lesson
└── phase0_foundations/
    └── day01_intro_to_dv/
        ├── notes.md
        ├── design.sv
        ├── testbench.sv
        └── Makefile
```
