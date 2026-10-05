// global_defs.vh
// Just constants used everywhere else. Not a module - included with `include.
`ifndef GLOBAL_DEFS_VH
`define GLOBAL_DEFS_VH

// widths
`define VITAL_WIDTH   8   // HR / BP / SpO2 value
`define STATUS_WIDTH  2   // NORMAL / MODERATE / CRITICAL
`define DEV_WIDTH     8   // deviation / margin score
`define ID_WIDTH       2   // patient ID (0-3)

// status codes
`define NORMAL     2'b00
`define MODERATE   2'b01
`define CRITICAL   2'b10

// which vital a deviation/margin calculator should use
`define IS_HR    2'b00
`define IS_BP    2'b01
`define IS_SPO2  2'b10

// normal-range boundaries (used by deviation_calculator and margin_calculator)
`define HR_LOW    60
`define HR_HIGH   100
`define BP_LOW    90
`define BP_HIGH   120
`define SPO2_LOW  95

// ---- packed patient record: one bus that carries everything about ----
// ---- one patient, so modules only need 2 ports (in, out) not 20+  ----
//  [79:78] ID
//  [77:70] HR        [53:52] HR status   [47:40] HR deviation   [23:16] HR margin
//  [69:62] BP        [51:50] BP status   [39:32] BP deviation   [15:8]  BP margin
//  [61:54] SpO2      [49:48] SpO2 status [31:24] SpO2 deviation [7:0]   SpO2 margin
`define PWIDTH 80

`define ID_HI     79
`define ID_LO     78
`define HR_HI     77
`define HR_LO     70
`define BP_HI     69
`define BP_LO     62
`define SP_HI     61
`define SP_LO     54
`define HRST_HI   53
`define HRST_LO   52
`define BPST_HI   51
`define BPST_LO   50
`define SPST_HI   49
`define SPST_LO   48
`define HRDEV_HI  47
`define HRDEV_LO  40
`define BPDEV_HI  39
`define BPDEV_LO  32
`define SPDEV_HI  31
`define SPDEV_LO  24
`define HRMGN_HI  23
`define HRMGN_LO  16
`define BPMGN_HI  15
`define BPMGN_LO  8
`define SPMGN_HI  7
`define SPMGN_LO  0

`endif

