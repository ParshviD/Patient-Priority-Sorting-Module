// two_patient_comparator.v
// Compares two patients and outputs who is more urgent (winner) and who
// is less urgent (loser). This is the ONLY place the decision is made.
//
// Step 1: rank each patient 1 (most urgent) to 7 (all normal) using the
//         hierarchy: critical SpO2 > moderate SpO2 > critical BP >
//         moderate BP > critical HR > moderate HR > all normal.
// Step 2: if ranks are equal and NOT the all-normal case, use deviation
//         (SpO2, then BP, then HR) - bigger deviation wins.
// Step 3: if ranks are equal AND both patients are all-normal, use
//         margin instead (SpO2, then BP, then HR) - smaller margin wins,
//         because a smaller margin means closer to becoming abnormal.
// Step 4: if still tied, smaller patient ID wins.
`include "global_defs.vh"

module two_patient_comparator (
    input  wire [`PWIDTH-1:0] patient_a,
    input  wire [`PWIDTH-1:0] patient_b,
    output reg  [`PWIDTH-1:0] winner,
    output reg  [`PWIDTH-1:0] loser
);

    // pull the fields we need out of each patient's bus
    wire [1:0] id_a  = patient_a[`ID_HI:`ID_LO];
    wire [1:0] hrs_a = patient_a[`HRST_HI:`HRST_LO];
    wire [1:0] bps_a = patient_a[`BPST_HI:`BPST_LO];
    wire [1:0] sps_a = patient_a[`SPST_HI:`SPST_LO];
    wire [7:0] hrd_a = patient_a[`HRDEV_HI:`HRDEV_LO];
    wire [7:0] bpd_a = patient_a[`BPDEV_HI:`BPDEV_LO];
    wire [7:0] spd_a = patient_a[`SPDEV_HI:`SPDEV_LO];
    wire [7:0] hrm_a = patient_a[`HRMGN_HI:`HRMGN_LO];
    wire [7:0] bpm_a = patient_a[`BPMGN_HI:`BPMGN_LO];
    wire [7:0] spm_a = patient_a[`SPMGN_HI:`SPMGN_LO];

    wire [1:0] id_b  = patient_b[`ID_HI:`ID_LO];
    wire [1:0] hrs_b = patient_b[`HRST_HI:`HRST_LO];
    wire [1:0] bps_b = patient_b[`BPST_HI:`BPST_LO];
    wire [1:0] sps_b = patient_b[`SPST_HI:`SPST_LO];
    wire [7:0] hrd_b = patient_b[`HRDEV_HI:`HRDEV_LO];
    wire [7:0] bpd_b = patient_b[`BPDEV_HI:`BPDEV_LO];
    wire [7:0] spd_b = patient_b[`SPDEV_HI:`SPDEV_LO];
    wire [7:0] hrm_b = patient_b[`HRMGN_HI:`HRMGN_LO];
    wire [7:0] bpm_b = patient_b[`BPMGN_HI:`BPMGN_LO];
    wire [7:0] spm_b = patient_b[`SPMGN_HI:`SPMGN_LO];

    reg [3:0] rank_a, rank_b;
    reg [7:0] min_mgn_a, min_mgn_b;
    reg       a_wins;

    always @(*) begin
        // ---- rank patient A (1 = most urgent) ----
        if (sps_a == `CRITICAL)      rank_a = 1;
        else if (sps_a == `MODERATE) rank_a = 2;
        else if (bps_a == `CRITICAL) rank_a = 3;
        else if (bps_a == `MODERATE) rank_a = 4;
        else if (hrs_a == `CRITICAL) rank_a = 5;
        else if (hrs_a == `MODERATE) rank_a = 6;
        else                         rank_a = 7;   // all normal

        // ---- rank patient B ----
        if (sps_b == `CRITICAL)      rank_b = 1;
        else if (sps_b == `MODERATE) rank_b = 2;
        else if (bps_b == `CRITICAL) rank_b = 3;
        else if (bps_b == `MODERATE) rank_b = 4;
        else if (hrs_b == `CRITICAL) rank_b = 5;
        else if (hrs_b == `MODERATE) rank_b = 6;
        else                         rank_b = 7;

        // smallest of each patient's 3 margins (only used if rank == 7)
        min_mgn_a = (hrm_a < bpm_a) ? ((hrm_a < spm_a) ? hrm_a : spm_a)
                                     : ((bpm_a < spm_a) ? bpm_a : spm_a);
        min_mgn_b = (hrm_b < bpm_b) ? ((hrm_b < spm_b) ? hrm_b : spm_b)
                                     : ((bpm_b < spm_b) ? bpm_b : spm_b);

        // ---- decide the winner ----
        if (rank_a < rank_b)
            a_wins = 1'b1;
        else if (rank_b < rank_a)
            a_wins = 1'b0;
        else if (rank_a == 7) begin
            // both all-normal -> compare margins (smaller = more urgent)
            if (min_mgn_a != min_mgn_b)
                a_wins = (min_mgn_a < min_mgn_b);
            else if (spm_a != spm_b)
                a_wins = (spm_a < spm_b);
            else if (bpm_a != bpm_b)
                a_wins = (bpm_a < bpm_b);
            else if (hrm_a != hrm_b)
                a_wins = (hrm_a < hrm_b);
            else
                a_wins = (id_a <= id_b);
        end
        else begin
            // same critical/moderate tier -> compare deviation (bigger = more urgent)
            if (spd_a != spd_b)
                a_wins = (spd_a > spd_b);
            else if (bpd_a != bpd_b)
                a_wins = (bpd_a > bpd_b);
            else if (hrd_a != hrd_b)
                a_wins = (hrd_a > hrd_b);
            else
                a_wins = (id_a <= id_b);
        end

        // ---- output the winner and loser records ----
        winner = a_wins ? patient_a : patient_b;
        loser  = a_wins ? patient_b : patient_a;
    end

endmodule

