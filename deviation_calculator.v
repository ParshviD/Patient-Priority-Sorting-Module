// deviation_calculator.v
// Reusable: how far a value is OUTSIDE its normal range. 0 if inside.
// One instance is used per vital (HR/BP/SpO2), per patient.
`include "global_defs.vh"

module deviation_calculator (
    input  wire [`VITAL_WIDTH-1:0]  value,
    input  wire [1:0]               param_type,   // IS_HR / IS_BP / IS_SPO2
    output reg  [`DEV_WIDTH-1:0]    deviation
);

    always @(*) begin
        case (param_type)
            `IS_HR: begin
                if (value < `HR_LOW)
                    deviation = `HR_LOW - value;
                else if (value > `HR_HIGH)
                    deviation = value - `HR_HIGH;
                else
                    deviation = 0;
            end

            `IS_BP: begin
                if (value < `BP_LOW)
                    deviation = `BP_LOW - value;
                else if (value > `BP_HIGH)
                    deviation = value - `BP_HIGH;
                else
                    deviation = 0;
            end

            `IS_SPO2: begin
                if (value < `SPO2_LOW)
                    deviation = `SPO2_LOW - value;
                else
                    deviation = 0;
            end

            default: deviation = 0;
        endcase
    end

endmodule

