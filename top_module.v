// top_module.v
// Connects everything: 4 classifiers, 12 deviation calculators (3 per
// patient), 12 margin calculators (3 per patient), and the category
// comparator. Patient ID = input position (patient0 = ID 0, etc.)
`include "global_defs.vh"

module top_module (
    input  wire [`VITAL_WIDTH-1:0] hr0, bp0, spo2_0,
    input  wire [`VITAL_WIDTH-1:0] hr1, bp1, spo2_1,
    input  wire [`VITAL_WIDTH-1:0] hr2, bp2, spo2_2,
    input  wire [`VITAL_WIDTH-1:0] hr3, bp3, spo2_3,

    output wire [`PWIDTH-1:0] patient0_rec, patient1_rec, patient2_rec, patient3_rec,
    output wire [`PWIDTH-1:0] priority1_rec, priority2_rec, priority3_rec, priority4_rec,

    output wire [`ID_WIDTH-1:0] priority1_id, priority2_id, priority3_id, priority4_id
);

    wire [1:0] hrs0, bps0, sps0, hrs1, bps1, sps1, hrs2, bps2, sps2, hrs3, bps3, sps3;
    wire [7:0] hrd0, bpd0, spd0, hrd1, bpd1, spd1, hrd2, bpd2, spd2, hrd3, bpd3, spd3;
    wire [7:0] hrm0, bpm0, spm0, hrm1, bpm1, spm1, hrm2, bpm2, spm2, hrm3, bpm3, spm3;

    // ---- Patient 0 ----
    patient_classifier PC0 (.hr(hr0), .bp(bp0), .spo2(spo2_0),
                             .hr_status(hrs0), .bp_status(bps0), .spo2_status(sps0));
    deviation_calculator DC0_HR   (.value(hr0),    .param_type(`IS_HR),   .deviation(hrd0));
    deviation_calculator DC0_BP   (.value(bp0),    .param_type(`IS_BP),   .deviation(bpd0));
    deviation_calculator DC0_SPO2 (.value(spo2_0), .param_type(`IS_SPO2), .deviation(spd0));
    margin_calculator MC0_HR   (.value(hr0),    .param_type(`IS_HR),   .margin(hrm0));
    margin_calculator MC0_BP   (.value(bp0),    .param_type(`IS_BP),   .margin(bpm0));
    margin_calculator MC0_SPO2 (.value(spo2_0), .param_type(`IS_SPO2), .margin(spm0));

    // ---- Patient 1 ----
    patient_classifier PC1 (.hr(hr1), .bp(bp1), .spo2(spo2_1),
                             .hr_status(hrs1), .bp_status(bps1), .spo2_status(sps1));
    deviation_calculator DC1_HR   (.value(hr1),    .param_type(`IS_HR),   .deviation(hrd1));
    deviation_calculator DC1_BP   (.value(bp1),    .param_type(`IS_BP),   .deviation(bpd1));
    deviation_calculator DC1_SPO2 (.value(spo2_1), .param_type(`IS_SPO2), .deviation(spd1));
    margin_calculator MC1_HR   (.value(hr1),    .param_type(`IS_HR),   .margin(hrm1));
    margin_calculator MC1_BP   (.value(bp1),    .param_type(`IS_BP),   .margin(bpm1));
    margin_calculator MC1_SPO2 (.value(spo2_1), .param_type(`IS_SPO2), .margin(spm1));

    // ---- Patient 2 ----
    patient_classifier PC2 (.hr(hr2), .bp(bp2), .spo2(spo2_2),
                             .hr_status(hrs2), .bp_status(bps2), .spo2_status(sps2));
    deviation_calculator DC2_HR   (.value(hr2),    .param_type(`IS_HR),   .deviation(hrd2));
    deviation_calculator DC2_BP   (.value(bp2),    .param_type(`IS_BP),   .deviation(bpd2));
    deviation_calculator DC2_SPO2 (.value(spo2_2), .param_type(`IS_SPO2), .deviation(spd2));
    margin_calculator MC2_HR   (.value(hr2),    .param_type(`IS_HR),   .margin(hrm2));
    margin_calculator MC2_BP   (.value(bp2),    .param_type(`IS_BP),   .margin(bpm2));
    margin_calculator MC2_SPO2 (.value(spo2_2), .param_type(`IS_SPO2), .margin(spm2));

    // ---- Patient 3 ----
    patient_classifier PC3 (.hr(hr3), .bp(bp3), .spo2(spo2_3),
                             .hr_status(hrs3), .bp_status(bps3), .spo2_status(sps3));
    deviation_calculator DC3_HR   (.value(hr3),    .param_type(`IS_HR),   .deviation(hrd3));
    deviation_calculator DC3_BP   (.value(bp3),    .param_type(`IS_BP),   .deviation(bpd3));
    deviation_calculator DC3_SPO2 (.value(spo2_3), .param_type(`IS_SPO2), .deviation(spd3));
    margin_calculator MC3_HR   (.value(hr3),    .param_type(`IS_HR),   .margin(hrm3));
    margin_calculator MC3_BP   (.value(bp3),    .param_type(`IS_BP),   .margin(bpm3));
    margin_calculator MC3_SPO2 (.value(spo2_3), .param_type(`IS_SPO2), .margin(spm3));

    // ---- pack each patient into one bus (ID = position 0,1,2,3) ----
    assign patient0_rec = {2'd0, hr0, bp0, spo2_0, hrs0, bps0, sps0, hrd0, bpd0, spd0, hrm0, bpm0, spm0};
    assign patient1_rec = {2'd1, hr1, bp1, spo2_1, hrs1, bps1, sps1, hrd1, bpd1, spd1, hrm1, bpm1, spm1};
    assign patient2_rec = {2'd2, hr2, bp2, spo2_2, hrs2, bps2, sps2, hrd2, bpd2, spd2, hrm2, bpm2, spm2};
    assign patient3_rec = {2'd3, hr3, bp3, spo2_3, hrs3, bps3, sps3, hrd3, bpd3, spd3, hrm3, bpm3, spm3};

    // ---- sort all 4 patients ----
    category_comparator CC (
        .patient0(patient0_rec), .patient1(patient1_rec),
        .patient2(patient2_rec), .patient3(patient3_rec),
        .priority1(priority1_rec), .priority2(priority2_rec),
        .priority3(priority3_rec), .priority4(priority4_rec)
    );

    // ---- pull just the ID back out for easy reading ----
    assign priority1_id = priority1_rec[`ID_HI:`ID_LO];
    assign priority2_id = priority2_rec[`ID_HI:`ID_LO];
    assign priority3_id = priority3_rec[`ID_HI:`ID_LO];
    assign priority4_id = priority4_rec[`ID_HI:`ID_LO];

endmodule

