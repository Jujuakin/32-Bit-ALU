# 32-Bit ALU — Full RTL-to-GDS VLSI Implementation

A fully verified **32-bit Arithmetic Logic Unit (ALU)** designed in SystemVerilog and implemented through a complete **RTL-to-GDS flow** using the Cadence toolchain on a **45nm CMOS process**. Two architectural implementations are benchmarked against each other for area and timing performance.

---

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Supported Operations](#supported-operations)
- [Repository Structure](#repository-structure)
- [Implementation Details](#implementation-details)
- [Synthesis & Physical Design Results](#synthesis--physical-design-results)
- [How to Simulate](#how-to-simulate)
- [Tools Used](#tools-used)

---

## Overview

This project implements a 32-bit ALU supporting **14 arithmetic and logic operations** using a hierarchical bit-slice architecture. The design was taken through the full professional VLSI design flow:

**RTL Design → Functional Simulation → Logic Synthesis → Place & Route → DRC Signoff → GDS Tape-out**

Two implementations were developed and compared:
- **Design A** — Structural: 32 instantiated 1-bit ALU slices chained together
- **Design B** — Behavioral: Single 32-bit always block with case statement

Both designs pass full functional verification and DRC/connectivity checks. Design A was selected for final chip integration due to its smaller silicon area.

---

## Architecture

### System-Level Interface

```
Inputs:
  A[31:0]   — 32-bit operand A
  B[31:0]   — 32-bit operand B
  Cin       — Carry-in
  S[3:0]    — 4-bit operation select
  Din_L     — Serial input for shift left
  Din_R     — Serial input for shift right

Outputs:
  F[31:0]   — 32-bit result
  Cout      — Carry-out
```

### 1-Bit ALU Slice (Building Block)

Each bit-slice consists of three sub-modules:

```
┌──────────────────────────────────────────────┐
│                  1-Bit ALU Slice              │
│                                               │
│  Ai, Bi ──► Arithmetic Unit ──► Di ──► ┐     │
│                                         4:1  ──► Fi
│  Ai, Bi ──► Logic Unit      ──► Ei ──► │MUX  │
│                                         │     │
│  Shift_R ───────────────────────────►  ┘     │
│  Shift_L ───────────────────────────►        │
│                                               │
│  S[3:2] controls MUX selection               │
│  S[1:0] controls Arithmetic & Logic ops      │
└──────────────────────────────────────────────┘
```

The **Arithmetic Unit** implements a full adder with a 4:1 MUX on input B, selecting between `0`, `B`, `~B`, and `1` based on S[1:0].

The **Logic Unit** selects between AND, OR, XOR, and NOT using a 4:1 MUX on S[1:0].

The **Multiplexer Unit** selects the final output from arithmetic result, logic result, shift-right input, or shift-left input based on S[3:2].

### 32-Bit Structural Design (Design A)

32 instances of the 1-bit slice are chained with carry propagation:

```
Bit 0    Bit 1    Bit 2         Bit 31
┌────┐  ┌────┐  ┌────┐        ┌────┐
│ALU │─►│ALU │─►│ALU │─► ... ─►│ALU │─► Cout
│[0] │  │[1] │  │[2] │        │[31]│
└────┘  └────┘  └────┘        └────┘
  ▲       ▲       ▲               ▲
Cin    carry[1] carry[2]      carry[31]
```

Shift inputs are wired as: `Shift_R[i] = A[i+1]` (MSB from Din_R), `Shift_L[i] = A[i-1]` (LSB from Din_L).

---

## Supported Operations

| S3 | S2 | S1 | S0 | Cin | Operation | Function |
|:--:|:--:|:--:|:--:|:---:|-----------|----------|
| 0 | 0 | 0 | 0 | 0 | Transfer A | F = A |
| 0 | 0 | 0 | 0 | 1 | Increment A | F = A + 1 |
| 0 | 0 | 0 | 1 | 0 | Addition | F = A + B |
| 0 | 0 | 0 | 1 | 1 | Add with Carry | F = A + B + 1 |
| 0 | 0 | 1 | 0 | 0 | Subtract with Borrow | F = A + B' |
| 0 | 0 | 1 | 0 | 1 | Subtraction | F = A - B |
| 0 | 0 | 1 | 1 | 0 | Decrement A | F = A - 1 |
| 0 | 0 | 1 | 1 | 1 | Transfer A | F = A |
| 0 | 1 | 0 | 0 | X | AND | F = A & B |
| 0 | 1 | 0 | 1 | X | OR | F = A \| B |
| 0 | 1 | 1 | 0 | X | XOR | F = A ^ B |
| 0 | 1 | 1 | 1 | X | Complement | F = ~A |
| 1 | 0 | X | X | X | Shift Right | F = A >> 1 |
| 1 | 1 | X | X | X | Shift Left | F = A << 1 |

---

## Repository Structure

```
32-bit-ALU/
├── README.md
├── HDL Code/
│   ├── arithmetic_unit.v       # Full adder with B-input MUX
│   ├── logic_unit.v            # AND/OR/XOR/NOT with output MUX
│   ├── multiplexer_unit.v      # Final output selector + carry logic
│   ├── alu_1bit.v              # 1-bit ALU slice (structural)
│   ├── alu_32bit_A.v           # 32-bit ALU: 32x instantiated slices (structural)
│   ├── alu_32bit_B.v           # 32-bit ALU: behavioral always block
│   ├── arithmetic_unit_tb.v    # Arithmetic unit testbench
│   ├── logic_unit_tb.v         # Logic unit testbench (self-checking)
│   ├── multiplexer_unit_tb.v   # MUX unit testbench
│   ├── alu_1bit_tb.v           # 1-bit ALU full operation testbench
│   ├── alu_32bit_A_tb.v        # 32-bit Design A testbench
│   └── alu_32bit_B_tb.v        # 32-bit Design B testbench
├── Synthesis Netlists/
│   ├── genus_alu_1bit.v        # Gate-level netlist — 1-bit ALU
│   ├── genus_alu_32bit_A.v     # Gate-level netlist — Design A
│   ├── genus_alu_32bit_B.v     # Gate-level netlist — Design B
│   ├── genus_alu_*.sdc         # Synthesis design constraints
│   └── genus_alu_*.sdf         # Standard delay format (back-annotation)
├── Synthesis Reports/
│   ├── genus_alu_*_area.rep    # Genus area reports (gate counts, area breakdown)
│   ├── genus_alu_*_timing.rep  # Genus timing reports (critical path, slack)
│   └── genus_alu_*_power.rep   # Genus power reports
├── Innovus Timing Reports/
│   ├── alu1bit_postRoute_all.tarpt.gz     # Post-route timing — 1-bit ALU
│   ├── alu32bitA_postRoute_all.tarpt.gz   # Post-route timing — Design A
│   └── alu32bitB_postRoute_all.tarpt.gz   # Post-route timing — Design B
└── GDS Files/
    ├── alu_1bit.gds            # GDS — 1-bit ALU cell
    ├── alu_32bit_A.gds         # GDS — Design A (selected for chip)
    ├── alu_32bit_B.gds         # GDS — Design B
    └── padframe.gds            # Final chip with I/O pad frame
```

---

## Implementation Details

### Design A — Structural (Bit-Slice)
- 32 instances of `alu_1bit` connected via ripple carry chain
- Shift routing handled via `generate` block with boundary conditions
- Special-case overrides for operations where slice-level ripple carry produces incorrect results (decrement, transfer-A variant, shift-right)

### Design B — Behavioral
- Single `always @(*)` block with `case` statement on `{S3,S2,S1,S0}`
- Direct 33-bit arithmetic for carry generation: `temp = A + B` captures carry-out in `temp[32]`
- Synthesizer optimizes gate-level implementation independently

### Verification Strategy
All testbenches use `$display` truth tables and `$dumpvars` for waveform export. The logic unit testbench is **self-checking** — it uses `if/else` assertions with `$display("ERROR")` and `$finish` on failure, ensuring all 4 test cases across all input combinations pass before exiting.

32-bit testbenches verify all 14 operations using carefully selected hex operands that expose carry and borrow edge cases (e.g., `0xFFFFFFFF` for increment overflow, `0x12345678 + 0x87654321` for carry detection).

---

## Synthesis & Physical Design Results

All synthesis performed using **Cadence Genus 21.17** on the **45nm GPDK CMOS slow process corner (PVT: 0P9V, 125°C)**.
Place & Route performed using **Cadence Innovus 21.17**.

### 1-Bit ALU Slice
| Metric | Value |
|--------|-------|
| Total Gates | 17 |
| Total Area | 48.906 units² |
| Logic Area | 31.806 units² (65.0%) |
| Buffer Area | 16.416 units² (33.6%) |
| Critical Path (post-route) | 101.997 ps |

### 32-Bit ALU — Design Comparison

| Metric | Design A (Structural) | Design B (Behavioral) |
|--------|----------------------|----------------------|
| Total Gates | 555 | 622 |
| Total Area | **1412.118 units²** | 1524.362 units² |
| Critical Path (post-route) | 70.760 ns | **60.955 ns** |
| Critical Path Startpoint | S3 | A[0] |
| Critical Path Endpoint | F[31] | F[31] |
| DRC Violations | 0 | 0 |
| Connectivity Errors | 0 | 0 |

**Design A** is **7.3% smaller in area** (saves ~112 units²).
**Design B** is **13.8% faster** (9.8 ns timing advantage).

**Design A selected for chip integration** based on area efficiency. The timing difference is acceptable for the target operating frequency.

**Critical Path Analysis:**
Both designs are dominated by the **ripple carry chain** through 32 cascaded ADDFX1 full adders. Design A's critical path runs S3 → NOR2 gate (carry select) → 32× ADDFX1 CI→CO ripple → F[31] output, with the CLKBUFX20 high-drive output buffer accounting for ~3.1 ns of the total 70.76 ns. Design B's critical path runs A[0] → 32× ADDFX1 CI→CO adder chain → F[31], with the same output buffer. The behavioral synthesis produced a slightly shorter ripple chain due to the synthesizer's freedom to reorder logic, explaining its timing advantage.

### Final Chip (Design A with Pad Frame)
| Metric | Value |
|--------|-------|
| Process | 45nm GPDK CMOS |
| Core Area | 1412.118 units² |
| Pad Frame | Included (I/O configured) |
| DRC | ✅ Clean (0 violations) |
| Connectivity | ✅ Clean (0 errors) |
| GDS | Exported |

---

## How to Simulate

### With Icarus Verilog (Free — No License Required)

**Install:**
```bash
sudo apt install iverilog gtkwave   # Linux/WSL
brew install icarus-verilog gtkwave # macOS
```

**Simulate the 32-bit ALU (Design A):**
```bash
# Compile all source files with testbench
iverilog -o sim_32A \
  "HDL Code/arithmetic_unit.v" \
  "HDL Code/logic_unit.v" \
  "HDL Code/multiplexer_unit.v" \
  "HDL Code/alu_1bit.v" \
  "HDL Code/alu_32bit_A.v" \
  "HDL Code/alu_32bit_A_tb.v"

# Run simulation and view truth table output
vvp sim_32A

# View waveforms
gtkwave alu_32bit_A_tb.vcd
```

**Simulate the 1-bit ALU:**
```bash
iverilog -o sim_1bit \
  "HDL Code/arithmetic_unit.v" \
  "HDL Code/logic_unit.v" \
  "HDL Code/multiplexer_unit.v" \
  "HDL Code/alu_1bit.v" \
  "HDL Code/alu_1bit_tb.v" && vvp sim_1bit
```

**Run self-checking logic unit test:**
```bash
iverilog -o sim_logic "HDL Code/logic_unit.v" "HDL Code/logic_unit_tb.v" && vvp sim_logic
# Expected output: "All logic unit tests passed!"
```

### Expected Simulation Output (Design A)
```
|-----------------------------------------------------------------------------------------|
| Operation               | S3 S2 S1 S0 | Cin | A Value    | B Value    | F Value    | Cout |
|-----------------------------------------------------------------------------------------|
| Transfer A              | 0  0  0  0  | 0   | 0xa5a5a5a5 | 0x5a5a5a5a | 0xa5a5a5a5 | 0    |
| Increment A             | 0  0  0  0  | 1   | 0xffffffff | 0x00000000 | 0x00000000 | 1    |
| Addition A+B            | 0  0  0  1  | 0   | 0x12345678 | 0x87654321 | 0x99999999 | 0    |
...
|-----------------------------------------------------------------------------------------|
```

---

## Tools Used

| Tool | Purpose | Version |
|------|---------|---------|
| Cadence Genus | Logic Synthesis | 21.17 |
| Cadence Innovus | Place & Route, DRC, Connectivity | 21.17 |
| Cadence SimVision | Waveform Viewing | — |
| SystemVerilog / Verilog | HDL | IEEE 1800-2012 |
| Icarus Verilog | Open-source Simulation | 11.0+ |
| GTKWave | Open-source Waveform Viewer | 3.3+ |
| 45nm GPDK CMOS | Process Design Kit | Cadence Generic |

---

## Key Learnings & Design Decisions

**Bit-slice vs. Behavioral tradeoff:** The structural bit-slice design (A) achieved smaller area because the synthesizer could map repeated identical instances to optimized standard cells efficiently. The behavioral design (B) gave the synthesizer more optimization freedom for timing, resulting in a faster but larger implementation — a classic area-speed tradeoff.

**Special-case handling in Design A:** Certain operations (decrement, subtract-with-borrow, shift-right) required top-level override logic in the 32-bit wrapper because the ripple-carry behavior of chained 1-bit slices doesn't naturally produce the correct carry-out for these edge cases. This was identified during testbench verification and corrected with conditional output muxing.

**Self-checking testbenches:** Assertion-based verification in the logic unit testbench follows industry practice for catching regressions early. Expanding this pattern to all modules with UVM would be the next step in a professional environment.

---

*Designed as part of EECS 4612 — Digital VLSI, York University, Winter 2025.*
*Tools: Cadence Genus & Innovus. Process: 45nm GPDK CMOS.*
