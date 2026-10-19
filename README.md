# 4-bit Array Multiplier: RTL to GDSII

Team: Vedant and Aarav. Roles and handoff rules are in TEAM_CONTRACT.pdf (shared between us).

## Commands log

### Setup (Vedant)
iverilog -g2012 -o /dev/null rtl/full_adder.v rtl/mult_array.v
yosys -c synth/synth.tcl
Gate-level simulation: pending (needs tb/tb_mult.v)

### Part C (Aarav)
(paste exact commands here)

### Part D (Vedant)
cd pnr
librelane --pdk sky130A --pdk-root /foss/pdks config.json

| Attempt | CLOCK_PERIOD (ns) | DRC | LVS | Setup slack (ns) | Result |
|---|---|---|---|---|---|
| 1 (trial) | 10 | 0 | 0 | 2.396 worst corner, 6.207 typical | Flow works end to end; not final |
