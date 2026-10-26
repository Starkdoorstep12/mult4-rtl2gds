# 4-bit Array Multiplier: RTL to GDSII

Team: Vedant Tejas (2023112018) and Aarav Singla (2024122004).

## Commands log

### Setup (Vedant)
~~~
git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git
cd iic-osic-tools && ./start_vnc.sh
docker exec -it -w /foss/designs/mult4-rtl2gds iic-osic-tools_xvnc_uid_1000 bash
sak-pdk sky130A
~~~

### Part A (Aarav)
Inside the container, after sak-pdk sky130A:
~~~
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v
vvp sim
~~~
Result: PASS: 256 vectors checked, 0 errors

FAIL test (temporary change, undone, never committed):
~~~
sed -i 's/assign sum  = a ^ b ^ cin;/assign sum  = a ^ b;/' rtl/full_adder.v
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v && vvp sim
git checkout rtl/full_adder.v
~~~
Result: FAIL: 256 vectors checked, 95 errors (last mismatch: a=15 b=15 expected=225 got=181)

Waveform (hand example A = 13, B = 7 from Vedant's roll number 2023112018, last digit 8 + 5 = 13):
~~~
gtkwave mult.vcd
~~~

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
Inside the container, after sak-pdk sky130A:
~~~
sta sta/sta.tcl            # T = 10 ns: worst slack max 7.21 -> Tmin = 10 - 7.21 = 2.79 ns
T=2.79 sta sta/sta.tcl     # rerun at Tmin: worst slack max 0.00 (0.003 in the report)
cat sta/mult_array_timing.rpt
~~~
Result: Tmin = 2.79 ns, Fmax = 358.4 MHz. sta/mult_array_timing.rpt is from the T = 2.79 ns run.

### Part D (Vedant)
Inside the container, after sak-pdk sky130A. config.json started with CLOCK_PERIOD 10 (trial run):
~~~
cd pnr
librelane --pdk sky130A --pdk-root /foss/pdks config.json
# attempt 1 (3.5 ns)
sed -i 's/"CLOCK_PERIOD": 10/"CLOCK_PERIOD": 3.5/' config.json
librelane --pdk sky130A --pdk-root /foss/pdks config.json
# attempts 2 to 10: retry loop, +0.5 ns after each failure, stops at the first pass (8.0 ns)
for p in 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0; do
  sed -i -E "s/\"CLOCK_PERIOD\": [0-9.]+/\"CLOCK_PERIOD\": $p/" config.json
  if librelane --pdk sky130A --pdk-root /foss/pdks config.json > /foss/designs/scratch_sta/run_$p.log 2>&1; then
    echo "$p PASS" >> /foss/designs/scratch_sta/attempts.log; break
  else
    echo "$p FAIL" >> /foss/designs/scratch_sta/attempts.log
  fi
done
# copy the passing run's deliverables
LAST=$(ls -d runs/RUN_* | tail -1)
cp $LAST/final/metrics.json .
cp $LAST/final/gds/mult_array.gds .
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

### Cross-check (Vedant ran Part C)
Inside the container, after sak-pdk sky130A: `T=10 sta sta/sta.tcl` gave worst slack max 7.21 (matches Aarav's Part C, Tmin = 2.79 ns).

### Part D screenshots and report (Vedant)
~~~
sudo apt install -y klayout
cd ~/eda/designs/mult4-rtl2gds
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v && vvp sim
gtkwave mult.vcd
klayout pnr/mult_array.gds
~~~
The first iverilog command regenerates mult.vcd for the waveform; the waveform window was set to 4300 to 4350 ns. In KLayout, all layers were hidden except 65/20 to 72/20 (diffusion, poly, li1, met1 to met5), so the cell-name text labels are not drawn. The whole die and a zoomed view were captured with Win+Shift+S and cropped. The marker lines and labels on the waveform were added afterwards with an image-editing script, and the block diagram was generated with a Python (matplotlib) script. The report is written in LaTeX and compiled with pdflatex to report/report.pdf.
