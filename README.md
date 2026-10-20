# 4-bit Array Multiplier: RTL to GDSII

Team: Vedant Tejas (2023112018) and Aarav Singla (2024122004). Roles and handoff rules are in TEAM_CONTRACT.pdf (shared between us).

## Commands log

### Setup (Vedant)
~~~
git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git
cd iic-osic-tools && ./start_vnc.sh
docker exec -it -w /foss/designs/mult4-rtl2gds iic-osic-tools_xvnc_uid_1000 bash
sak-pdk sky130A
~~~

### Part A (Aarav)
(paste exact commands here)

### Part B (Vedant)
~~~
iverilog -g2012 -o /dev/null rtl/full_adder.v rtl/mult_array.v
yosys -c synth/synth.tcl
~~~
RTL and gate-level simulation (inside the container, after sak-pdk sky130A):
~~~
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v && vvp sim
CELLS=$PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog
iverilog -g2012 -DFUNCTIONAL -DUNIT_DELAY=#1 -o gls tb/tb_mult.v $CELLS/primitives.v $CELLS/sky130_fd_sc_hd.v synth/mult_array_netlist.v
vvp gls
~~~
Result: PASS: 256 vectors checked, 0 errors (RTL and gate-level)

### Part C (Aarav)
(paste exact commands here)

### Part D (Vedant)
~~~
cd pnr
librelane --pdk sky130A --pdk-root /foss/pdks config.json
~~~

| Attempt | CLOCK_PERIOD (ns) | DRC | LVS | Setup slack (ns) | Result |
|---|---|---|---|---|---|
| trial | 10 | 0 | 0 | 2.396 | Pass; flow check only, not part of the 1.2 x Tmin sequence |
| 1 | 3.5 | 0 | 0 | -2.188 | Fail (setup, ss corner) |
| 2 | 4.0 | 0 | 0 | -1.688 | Fail |
| 3 | 4.5 | 0 | 0 | -1.188 | Fail |
| 4 | 5.0 | 0 | 0 | -0.686 | Fail |
| 5 | 5.5 | 0 | 0 | -0.208 | Fail |
| 6 | 6.0 | 0 | 0 | -0.154 | Fail |
| 7 | 6.5 | 0 | 0 | -0.220 | Fail |
| 8 | 7.0 | 0 | 0 | -0.134 | Fail |
| 9 | 7.5 | 0 | 0 | -0.104 | Fail |
| 10 | 8.0 | 0 | 0 | +0.396 | Pass: final run |

Setup slack is the worst across all corners (the ss_100C_1v60 corner). Attempts 1 to 10 start from 1.2 x Tmin (Tmin = 2.79 ns, rounded up to 3.5 ns) and add 0.5 ns after each failure.
