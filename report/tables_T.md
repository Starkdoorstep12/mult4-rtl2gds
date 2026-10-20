# Tables (Aarav): Part C

## Part C results (typical corner, tt_025C_1v80)

| Metric | Value |
|---|---|
| Worst slack at T = 10 ns (ns) | 7.21 |
| Tmin (ns) | 2.79 (= 10 - 7.21) |
| Fmax (MHz) | 358.4 (= 1000 / 2.79) |
| Slack at T = Tmin (ns) | +0.003 (MET) |
| Critical path start point | `_91_` (dfrtp_1), input register `a_r[1]`, clocked by clk |
| Critical path end point | `_88_` (dfrtp_1) D pin, output register `p[6]` |
| Number of cells on the critical path | 9 (launch flip-flop + 8 logic cells), 10 counting the capture flip-flop |
| Latency (ns) = 2 x Tmin | 5.58 |
| Throughput (million results per second) | 358.4 |

## Critical path cells, in order (from sta/mult_array_timing.rpt at T = 2.79 ns)

| # | Instance | Cell | Delay (ns) | Arrival (ns) | Role |
|---|---|---|---|---|---|
| 1 | `_91_` | dfrtp_1 (CLK to Q) | 0.398 | 0.398 | launch register, a_r[1] |
| 2 | `_37_` | clkinv_1 | 0.073 | 0.471 | inverts a_r[1] |
| 3 | `_42_` | o311ai_0 | 0.356 | 0.827 | partial products of a_r[1:0], b_r[1:0] merged with row-1 logic |
| 4 | `_45_` | a21oi_1 | 0.153 | 0.980 | row-1 carry logic |
| 5 | `_51_` | maj3_1 | 0.402 | 1.382 | full-adder carry |
| 6 | `_58_` | xnor3_1 | 0.370 | 1.752 | full-adder sum |
| 7 | `_61_` | maj3_1 | 0.368 | 2.119 | full-adder carry |
| 8 | `_63_` | maj3_1 | 0.354 | 2.474 | full-adder carry |
| 9 | `_64_` | xor3_1 | 0.178 | 2.652 | full-adder sum, p_next[6] |
| - | `_88_` | dfrtp_1 (D, setup 0.135) | - | required 2.655 | capture register, p[6] |

Cells that implement a full-adder function: 5 (3 maj3 carries, 1 xnor3 sum, 1 xor3 sum).
Logic delay = 2.652 - 0.398 = 2.254 ns. Clock-to-Q (0.398) + setup (0.135) = 0.533 ns of overhead.

Note: the report also lists the asynchronous reset recovery check (rst_n to `_82_`/RESET_B), slack 2.018 ns. It is not the critical path.
