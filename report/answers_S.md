# Report answers (Vedant)

## Q1. Why isn't the logic simply 16 + 12 cells?
Synthesis produced 61 cells in total. Subtracting the 16 flip-flops leaves 45 logic cells, not 16 + 12 = 28. The assignment's count is the number of building blocks (AND gates and full adders), not library cells. Yosys flattened the full adders, and ABC then remapped the whole logic cloud as one network. The stat report shows only 4 maj3 cells (a carry-like function) and a mix of xor3, xnor3, xor2, xnor2, nand, and and compound cells such as a21oi and a22oi, rather than 12 identical adder blocks. Also, the first adder of each row has a constant-zero carry-in, and the top bit of the row-0 output is constant zero, so some adders reduce to half-adders or simple gates. ABC also merges AND gates into compound cells.

## Q3. What percentage of the total cell area is flip-flops, and why is it large?
Flip-flops take 400.384 um2 out of 756.976 um2, which is 52.89%. Each dfrtp_1 cell is 25.024 um2, while the average logic cell is only about 7.9 um2 ((756.976 - 400.384) / 45), so one flip-flop is roughly three times the size of an average logic cell. The design is tiny, with only 45 small logic cells, but it registers all 8 input bits and all 8 output bits, so the 16 flip-flops are a large share of the total.

## Q5. What do DRC and LVS check, and why must both pass?
DRC (design rule check) checks the physical layout geometry against the foundry's manufacturing rules, such as minimum wire width, spacing between shapes, and via enclosure, so the layout can actually be made. LVS (layout versus schematic) extracts the devices and connections from the layout and compares them with the intended netlist, so the layout implements the circuit we designed. Both must pass: a layout can obey every rule and still be the wrong circuit (DRC clean, LVS fail), or be the right circuit but unmanufacturable (LVS clean, DRC fail). In our trial run both reported 0 errors.

## Q4 (draft, finish after Part C)
(needs Fmax from Part C)
