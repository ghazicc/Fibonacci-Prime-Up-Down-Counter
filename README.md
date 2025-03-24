# Prime/Fibonacci Up/Down Counter

## Overview
This project implements a special counter that can count two different sequences: Prime Numbers and Fibonacci numbers, in both up and down manners. The counter is built using T-Flip Flops and combinational logic.

## Features
- Supports counting in both **Prime Numbers** and **Fibonacci Sequence**
- Up/Down counting mode selection
- Reset input (asynchronous) to reset the circuit
- Enable input (synchronous) to enable/disable counting
- Fully verified using a **testbench** to ensure correctness

## Design Philosophy
The counter consists of two main stages:
1. **Term-Index Counter**: A mod-11 counter implemented using T Flip-Flops.
2. **Mapping Logic**: A combinational circuit that maps the term index to its corresponding prime or Fibonacci number.

### Hardware Components Used
- T Flip-Flops
- Combinational Logic Circuit
- Mode Control Signal

## Implementation Details
- The **first stage** is a synchronous counter that generates a term index.
- The **second stage** is a mapping logic circuit that translates the term index into the actual sequence value.
- A **testbench** generates expected outputs and compares them with actual outputs to verify the design.

## Simulation Results
- The testbench verifies correctness by running random test vectors.
- The error flag is used to identify mismatches; no errors were detected during testing.
- Further testing with multiple testbenches is recommended to ensure full correctness.

## Usage Instructions
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/Prime-Fibonacci-Counter.git
   cd Prime-Fibonacci-Counter
   ```
2. Run the simulation:
   - Open the project in your preferred Verilog simulator.
   - Load the testbench.
   - Run the simulation and check the output.


## Future Improvements
- Optimize propagation delay by reducing stage dependencies.
- Improve the testbench with corner case scenarios.
- Extend the counter to support more terms.

## Authors
- Ghazi Haj Qassem

## License
This project is licensed under the MIT License - see the LICENSE file for details.

