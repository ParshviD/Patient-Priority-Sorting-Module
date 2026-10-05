# Patient Priority Sorting Module

### Verilog HDL | VLSI | Digital Systems

A digital system that takes the vital signs of four patients, evaluates their condition, and determines who should receive attention first.

The project was designed as an individual VLSI project using Verilog HDL.

---

## Why I Built This

The idea behind this project was to take a decision that is usually made using human judgement and represent it using digital logic.

Instead of simply comparing one value, the system considers:

- Heart Rate (HR)
- Blood Pressure (BP)
- Oxygen Saturation (SpO₂)

for four different patients and converts those inputs into a priority order.

The interesting part was not just writing the Verilog code, but deciding how the complete decision process could be broken into smaller, reusable hardware blocks.

---

## What the System Does

For each patient, the system:

1. Takes HR, BP and SpO₂ as inputs.
2. Classifies each vital as Normal, Moderate or Critical.
3. Calculates deviation when a value moves outside its normal range.
4. Calculates margin for normal values.
5. Compares patients based on the defined urgency rules.
6. Sorts all four patients into Priority 1 to Priority 4.

The project uses a fixed urgency hierarchy and additional tie-breaking logic to determine the final order.

---

## System Architecture

The design is divided into eight main files:

| File | Purpose |
|---|---|
| `global_defs.vh` | Shared constants, status codes, widths and patient record definitions |
| `patient_classifier.v` | Classifies HR, BP and SpO₂ |
| `deviation_calculator.v` | Calculates how far an abnormal value is outside its normal range |
| `margin_calculator.v` | Calculates how close a normal value is to leaving its range |
| `two_patient_comparator.v` | Compares two patients and determines the more urgent one |
| `category_comparator.v` | Connects five comparators to sort four patients |
| `top_module.v` | Integrates the complete design |
| `testbench.v` | Runs simulation scenarios and displays the results |

The modular structure allows the comparison logic to be reused instead of duplicating it throughout the design. 

---

## Vital Classification

| Vital | Normal | Moderate | Critical |
|---|---|---|---|
| Heart Rate | 60–100 | 40–59 or 101–120 | <40 or >120 |
| Blood Pressure | 90–120 | 80–89 or 121–180 | <80 or >180 |
| SpO₂ | 95–100 | 90–94 | <90 |

These thresholds are defined centrally in `global_defs.vh` so that the different modules use the same reference values. :chatgpt-content-reference{index="3"}

---

## Priority Logic

The system uses the following urgency hierarchy:

1. Critical SpO₂
2. Moderate SpO₂
3. Critical Blood Pressure
4. Moderate Blood Pressure
5. Critical Heart Rate
6. Moderate Heart Rate
7. All Normal

When two patients fall into the same urgency level, additional comparison logic is used to determine their order.

The tie-breaking process uses:

- Deviation for abnormal patients
- Margin for otherwise normal patients
- Patient ID as the final tie-breaker

---

## How the Comparison Works

The `two_patient_comparator.v` module acts as the main decision-making block.

It compares two patients based on their urgency rank.

If both patients have the same urgency level, the comparator moves to the appropriate tie-breaking condition instead of simply selecting one arbitrarily.

This comparator is then reused multiple times inside `category_comparator.v` to create the complete four-patient sorting structure.

---

## Sorting Four Patients

The project uses five instances of the two-patient comparator to sort four patients.

Instead of writing separate comparison logic for every possible patient combination, the same comparator building block is reused across the design.

The resulting outputs are:

```text
Priority 1 → Most urgent patient
Priority 2 → Second most urgent patient
Priority 3 → Third most urgent patient
Priority 4 → Least urgent patient
