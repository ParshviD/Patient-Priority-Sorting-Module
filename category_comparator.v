// category_comparator.v
// Sorts all 4 patients using 5 copies of two_patient_comparator (a
// standard 4-input sorting network). No comparison logic is duplicated -
// this module just wires the comparators together.
//
//   P0,P1 -> CMP1 -> winner=r1_win_a, loser=r1_lose_a
//   P2,P3 -> CMP2 -> winner=r1_win_b, loser=r1_lose_b
//   (winners duel)  CMP3(r1_win_a, r1_win_b) -> priority1, r2_lose_top
//   (losers duel)   CMP4(r1_lose_a, r1_lose_b) -> r2_win_bot, priority4
//   (middle duel)   CMP5(r2_lose_top, r2_win_bot) -> priority2, priority3
`include "global_defs.vh"

module category_comparator (
    input  wire [`PWIDTH-1:0] patient0,
    input  wire [`PWIDTH-1:0] patient1,
    input  wire [`PWIDTH-1:0] patient2,
    input  wire [`PWIDTH-1:0] patient3,

    output wire [`PWIDTH-1:0] priority1,
    output wire [`PWIDTH-1:0] priority2,
    output wire [`PWIDTH-1:0] priority3,
    output wire [`PWIDTH-1:0] priority4
);

    wire [`PWIDTH-1:0] r1_win_a, r1_lose_a;
    wire [`PWIDTH-1:0] r1_win_b, r1_lose_b;
    wire [`PWIDTH-1:0] r2_lose_top, r2_win_bot;

    two_patient_comparator CMP1 (.patient_a(patient0), .patient_b(patient1),
                                  .winner(r1_win_a), .loser(r1_lose_a));

    two_patient_comparator CMP2 (.patient_a(patient2), .patient_b(patient3),
                                  .winner(r1_win_b), .loser(r1_lose_b));

    two_patient_comparator CMP3 (.patient_a(r1_win_a), .patient_b(r1_win_b),
                                  .winner(priority1), .loser(r2_lose_top));

    two_patient_comparator CMP4 (.patient_a(r1_lose_a), .patient_b(r1_lose_b),
                                  .winner(r2_win_bot), .loser(priority4));

    two_patient_comparator CMP5 (.patient_a(r2_lose_top), .patient_b(r2_win_bot),
                                  .winner(priority2), .loser(priority3));

endmodule

