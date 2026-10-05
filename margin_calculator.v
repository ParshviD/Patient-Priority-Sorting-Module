// margin_calculator.v
// Reusable: how close a value is to LEAVING its normal range (opposite of
// deviation_calculator). Only meaningful while the value is still normal.
// Used to break ties among patients who are all completely normal.
`include "global_defs.vh"

module margin_calculator (
    input  wire [`VITAL_WIDTH-1:0]  value,
    input  wire [1:0]               param_type,   // IS_HR / IS_BP / IS_SPO2
    output reg  [`DEV_WIDTH-1:0]    margin
);

    reg [`DEV_WIDTH-1:0] dist_low, dist_high;

    always @(*) begin
        case (param_type)
            `IS_HR: begin
                dist_low  = value - `HR_LOW;
                dist_high = `HR_HIGH - value;
                margin = (dist_low < dist_high) ? dist_low : dist_high;
            end

            `IS_BP: begin
                dist_low  = value - `BP_LOW;
                dist_high = `BP_HIGH - value;
                margin = (dist_low < dist_high) ? dist_low : dist_high;
            end

            `IS_SPO2: begin
                // only a lower edge matters for SpO2 (100 is the max anyway)
                margin = value - `SPO2_LOW;
            end

            default: margin = 0;
        endcase
    end

endmodule

