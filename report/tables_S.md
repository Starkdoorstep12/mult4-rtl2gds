# Tables (Vedant): Part B and Part D

## Part B results

| Metric | Value |
|---|---|
| Total number of cells | 61 |
| Number of flip-flops | 16 (sky130_fd_sc_hd__dfrtp_1) |
| Total cell area (um2) | 756.976 |
| Flip-flop area (um2) | 400.384 (16 x 25.024) |
| Flip-flop area (% of total) | 52.89 |
| 3 most-used cell types | dfrtp_1 x16, nand2_1 x7, then a tie: and2_0 x4 and maj3_1 x4 (logic only: nand2_1 x7, and2_0 x4, maj3_1 x4) |
| Netlist simulation result | PASS: 256 vectors checked, 0 errors |

## Part D results

| Metric | Value |
|---|---|
| CLOCK_PERIOD used (ns) | 8.0 |
| Number of runs needed | 10 (3.5 ns up to 8.0 ns in 0.5 ns steps), plus one 10 ns trial run |
| Core area (um2) | 17759.5 (die 22500) |
| Cells after synthesis | 61 |
| Cells after place and route | 1883 |
| Kinds of cells added | decap (1298), fill (254), tap (245), timing-repair buffers (21), clock buffers (3) |
| Wirelength | 2499 um (detailed routing log; met1 1153, met2 1284, met3 61) |
| Setup slack (ns) | +0.396 (worst corner, ss_100C_1v60); +4.207 at the typical corner (max_tt_025C_1v80) |
| Post-route Fmax (MHz) | 131.5 from the worst corner; 263.6 from the typical corner |
| Fmax from Part C (MHz) | 358.4 (Tmin 2.79 ns, typical corner) |
| DRC errors | 0 (Magic 0, KLayout 0) |
| LVS errors | 0 |

Cell count check: 1883 = 62 original-design cells (16 flip-flops + 46 logic cells; synthesis gave 16 + 45) + 1552 decap/fill + 245 tap + 21 repair buffers + 3 clock buffers.
