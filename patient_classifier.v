// patient_classifier.v
// Classifies one patient's HR, BP, SpO2 as NORMAL / MODERATE / CRITICAL.
`include "global_defs.vh"

module patient_classifier (
    input  wire [`VITAL_WIDTH-1:0] hr,
    input  wire [`VITAL_WIDTH-1:0] bp,
    input  wire [`VITAL_WIDTH-1:0] spo2,

    output reg [`STATUS_WIDTH-1:0] hr_status,
    output reg [`STATUS_WIDTH-1:0] bp_status,
    output reg [`STATUS_WIDTH-1:0] spo2_status
);

    // HR: critical <40 or >120, moderate 40-59 or 101-120, normal 60-100
    always @(*) begin
        if (hr < 40 || hr > 120)
            hr_status = `CRITICAL;
        else if ((hr >= 40 && hr <= 59) || (hr >= 101 && hr <= 120))
            hr_status = `MODERATE;
        else
            hr_status = `NORMAL;
    end

    // BP: critical <80 or >180, moderate 80-89 or 121-180, normal 90-120
    always @(*) begin
        if (bp < 80 || bp > 180)
            bp_status = `CRITICAL;
        else if ((bp >= 80 && bp <= 89) || (bp >= 121 && bp <= 180))
            bp_status = `MODERATE;
        else
            bp_status = `NORMAL;
    end

    // SpO2: critical <90, moderate 90-94, normal 95-100
    always @(*) begin
        if (spo2 < 90)
            spo2_status = `CRITICAL;
        else if (spo2 <= 94)
            spo2_status = `MODERATE;
        else
            spo2_status = `NORMAL;
    end

endmodule

