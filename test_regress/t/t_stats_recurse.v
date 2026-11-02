// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Zhi-Hern Loh
// SPDX-License-Identifier: CC0-1.0

// A cycle of class method calls, reachable from clocked logic, that a flag
// stops at run time. --stats counts instructions along every call path.

class Rpt;
  int errs;
  bit capping;
  function void err(string msg);
    errs++;
    if (errs > 3) fat(msg);
  endfunction
  function void fat(string msg);
    finish_up();
  endfunction
  function void finish_up();
    if (capping) return;
    capping = 1;
    close_all();
  endfunction
  function void close_all();
    if (errs > 100) err("unclosed");
  endfunction
endclass

module t (
    input clk
);
  Rpt r = new;
  int cyc;
  always @(posedge clk) begin
    cyc <= cyc + 1;
    if (cyc[0]) r.err("odd");
    if (cyc == 9) begin
      if (!r.capping || r.errs != 5) $stop;
      $write("*-* All Finished *-*\n");
      $finish;
    end
  end
endmodule
