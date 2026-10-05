// testbench.v (simulation only - do not add to synthesis)
// Runs 5 scenarios and prints classification, deviation, margin, and the
// final Priority 1-4 order. Status codes: 0=NORMAL 1=MODERATE 2=CRITICAL
`include "global_defs.vh"
`timescale 1ns/1ps

`define PRINT_ALL \
    $display(" P0: HR=%0d BP=%0d SpO2=%0d | status=%0d,%0d,%0d | dev=%0d,%0d,%0d | mgn=%0d,%0d,%0d", \
        hr0,bp0,spo2_0, p0[`HRST_HI:`HRST_LO],p0[`BPST_HI:`BPST_LO],p0[`SPST_HI:`SPST_LO], \
        p0[`HRDEV_HI:`HRDEV_LO],p0[`BPDEV_HI:`BPDEV_LO],p0[`SPDEV_HI:`SPDEV_LO], \
        p0[`HRMGN_HI:`HRMGN_LO],p0[`BPMGN_HI:`BPMGN_LO],p0[`SPMGN_HI:`SPMGN_LO]); \
    $display(" P1: HR=%0d BP=%0d SpO2=%0d | status=%0d,%0d,%0d | dev=%0d,%0d,%0d | mgn=%0d,%0d,%0d", \
        hr1,bp1,spo2_1, p1[`HRST_HI:`HRST_LO],p1[`BPST_HI:`BPST_LO],p1[`SPST_HI:`SPST_LO], \
        p1[`HRDEV_HI:`HRDEV_LO],p1[`BPDEV_HI:`BPDEV_LO],p1[`SPDEV_HI:`SPDEV_LO], \
        p1[`HRMGN_HI:`HRMGN_LO],p1[`BPMGN_HI:`BPMGN_LO],p1[`SPMGN_HI:`SPMGN_LO]); \
    $display(" P2: HR=%0d BP=%0d SpO2=%0d | status=%0d,%0d,%0d | dev=%0d,%0d,%0d | mgn=%0d,%0d,%0d", \
        hr2,bp2,spo2_2, p2[`HRST_HI:`HRST_LO],p2[`BPST_HI:`BPST_LO],p2[`SPST_HI:`SPST_LO], \
        p2[`HRDEV_HI:`HRDEV_LO],p2[`BPDEV_HI:`BPDEV_LO],p2[`SPDEV_HI:`SPDEV_LO], \
        p2[`HRMGN_HI:`HRMGN_LO],p2[`BPMGN_HI:`BPMGN_LO],p2[`SPMGN_HI:`SPMGN_LO]); \
    $display(" P3: HR=%0d BP=%0d SpO2=%0d | status=%0d,%0d,%0d | dev=%0d,%0d,%0d | mgn=%0d,%0d,%0d", \
        hr3,bp3,spo2_3, p3[`HRST_HI:`HRST_LO],p3[`BPST_HI:`BPST_LO],p3[`SPST_HI:`SPST_LO], \
        p3[`HRDEV_HI:`HRDEV_LO],p3[`BPDEV_HI:`BPDEV_LO],p3[`SPDEV_HI:`SPDEV_LO], \
        p3[`HRMGN_HI:`HRMGN_LO],p3[`BPMGN_HI:`BPMGN_LO],p3[`SPMGN_HI:`SPMGN_LO]); \
    $display(" Priority order (by ID): %0d, %0d, %0d, %0d\n", id1, id2, id3, id4);

module testbench;

    reg [`VITAL_WIDTH-1:0] hr0, bp0, spo2_0;
    reg [`VITAL_WIDTH-1:0] hr1, bp1, spo2_1;
    reg [`VITAL_WIDTH-1:0] hr2, bp2, spo2_2;
    reg [`VITAL_WIDTH-1:0] hr3, bp3, spo2_3;

    wire [`PWIDTH-1:0] p0, p1, p2, p3;
    wire [`PWIDTH-1:0] pr1, pr2, pr3, pr4;
    wire [`ID_WIDTH-1:0] id1, id2, id3, id4;

    top_module DUT (
        .hr0(hr0), .bp0(bp0), .spo2_0(spo2_0),
        .hr1(hr1), .bp1(bp1), .spo2_1(spo2_1),
        .hr2(hr2), .bp2(bp2), .spo2_2(spo2_2),
        .hr3(hr3), .bp3(bp3), .spo2_3(spo2_3),
        .patient0_rec(p0), .patient1_rec(p1), .patient2_rec(p2), .patient3_rec(p3),
        .priority1_rec(pr1), .priority2_rec(pr2), .priority3_rec(pr3), .priority4_rec(pr4),
        .priority1_id(id1), .priority2_id(id2), .priority3_id(id3), .priority4_id(id4)
    );

    initial begin
        $display("=== Patient Priority Sorting - Testbench ===\n");

        // Test 1: one critical patient (P2)
        hr0=70; bp0=100; spo2_0=98;
        hr1=75; bp1=110; spo2_1=97;
        hr2=80; bp2=115; spo2_2=85;   // critical SpO2
        hr3=65; bp3=105; spo2_3=96;
        #10;
        $display("TEST 1: single critical patient (expect P2 first)");
        `PRINT_ALL

        // Test 2: multiple critical patients, different SpO2 deviation
        hr0=70; bp0=100; spo2_0=85;   // dev 10
        hr1=70; bp1=100; spo2_1=70;   // dev 25
        hr2=70; bp2=100; spo2_2=60;   // dev 35 (most urgent)
        hr3=70; bp3=100; spo2_3=98;   // normal
        #10;
        $display("TEST 2: multiple critical patients (expect order P2,P1,P0,P3)");
        `PRINT_ALL

        // Test 3: exact tie -> smaller ID wins
        hr0=70; bp0=100; spo2_0=85;
        hr1=70; bp1=100; spo2_1=85;   // identical to P0
        hr2=70; bp2=100; spo2_2=98;
        hr3=70; bp3=100; spo2_3=97;
        #10;
        $display("TEST 3: exact tie (expect P0 before P1)");
        `PRINT_ALL

        // Test 4: all-normal patients with different margins
        hr0=61; bp0=105; spo2_0=100;  // HR margin = 1 (tightest)
        hr1=80; bp1=118; spo2_1=96;   // SpO2 margin = 1 (tightest)
        hr2=80; bp2=105; spo2_2=99;   // SpO2 margin = 4
        hr3=80; bp3=105; spo2_3=100;  // SpO2 margin = 5
        #10;
        $display("TEST 4: all-normal, different margins (expect order P1,P0,P2,P3)");
        `PRINT_ALL

        // Test 5: general mixed combination
        hr0=45;  bp0=85;  spo2_0=92;   // moderate all around
        hr1=125; bp1=175; spo2_1=88;   // HR critical, BP moderate, SpO2 critical
        hr2=65;  bp2=115; spo2_2=99;   // all normal
        hr3=35;  bp3=200; spo2_3=93;   // HR critical, BP critical, SpO2 moderate
        #10;
        $display("TEST 5: general mixed combination");
        `PRINT_ALL

        $display("=== Simulation complete ===");
        $finish;
    end

endmodule

