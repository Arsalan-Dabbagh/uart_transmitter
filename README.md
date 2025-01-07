# UART Transmitter (`uart_tr`) with Testbench

This repository provides the implementation of a Universal Asynchronous Receiver-Transmitter (UART) Transmitter module (`uart_tr`) in VHDL and its corresponding testbench (`tb_uart_tr`). The module implements serial communication using a Finite State Machine (FSM), and the testbench validates its functionality through simulation.

## Features

### UART Transmitter (`uart_tr`)
- Configurable **data width** for flexible communication.
- Implements **start bit**, **data bits**, and **stop bit** transmission.
- FSM-based design ensures clear transitions between idle, start, transmit, and stop states.
- Outputs a **busy signal** (`BSY`) to indicate when the transmitter is active.
- Compatible with FPGA or ASIC synthesis.

### Testbench (`tb_uart_tr`)
- Simulates the UART transmitter with various test cases.
- Generates clock and reset signals.
- Tests data transmission and reset functionality.
- Verifies proper output on serial line (`TXD`) and busy signal (`BSY`).

## Files in Repository

| File Name       | Description                                                                                  |
|------------------|----------------------------------------------------------------------------------------------|
| `uart_tr.vhd`    | UART transmitter module written in VHDL.                                                    |
| `tb_uart_tr.vhd` | Testbench for simulating and validating the `uart_tr` module.                               |
| `LICENSE`        | Licensed under the CERN-OHL-P v2.0. See [CERN-OHL-P](https://cern.ch/cern-ohl-p) for details.|

---

## UART Transmitter (`uart_tr`)

### Generics

| Name        | Type      | Default | Description                                |
|-------------|-----------|---------|--------------------------------------------|
| `DATA_WIDTH`| Integer   | 8       | Width of the data to be transmitted        |
| `STOP_WIDTH`| Integer   | 1       | Width of the stop bit                      |
| `START_BIT` | std_logic | '0'     | Value of the start bit (default: low)      |
| `STOP_BIT`  | std_logic | '1'     | Value of the stop bit (default: high)      |

### Ports

| Port Name | Direction | Description                                      |
|-----------|-----------|--------------------------------------------------|
| `BCLK`    | Input     | Input clock signal                               |
| `RST`     | Input     | Reset signal (active-low)                        |
| `DIN`     | Input     | Parallel data input, defined by `DATA_WIDTH`     |
| `TXD`     | Output    | Serial data output                               |
| `BSY`     | Output    | Busy signal indicating active transmission       |

### FSM States
- **Idle State**: Default high state for the UART line, no transmission.
- **Start State**: Transmits the start bit (`START_BIT`).
- **Transmit State**: Serially transmits data bits from the `DIN` input.
- **Stop State**: Transmits the stop bit (`STOP_BIT`) and returns to idle.

---

## Testbench (`tb_uart_tr`)

The testbench simulates the behavior of the UART transmitter under the following conditions:

1. **Clock Generation**:
   - A clock signal (`BCLK`) is generated with a configurable period (`CLK_PERIOD`).

2. **Reset Functionality**:
   - Tests the system’s response to both initial and mid-operation reset (`RST`).

3. **Data Transmission**:
   - Transmits sample data values to validate serialization on the `TXD` output.

4. **Busy Signal**:
   - Observes the `BSY` signal to ensure it reflects the transmitter's state correctly.

### Test Scenarios
- **Case 1**: Transmits the byte `0x0F`.
- **Case 2**: Transmits the byte `0xCC`.
- **Case 3**: Applies a reset during operation and checks recovery.

### Signals Used in Testbench

| Signal Name | Type                     | Description                                  |
|-------------|--------------------------|----------------------------------------------|
| `BCLK`      | `std_logic`              | Clock signal with a period of `CLK_PERIOD`.  |
| `RST`       | `std_logic`              | Reset signal to test initial and active reset. |
| `DIN`       | `std_logic_vector(7 downto 0)` | Input data for the transmitter.              |
| `TXD`       | `std_logic`              | Output serial data from the transmitter.     |
| `BSY`       | `std_logic`              | Busy signal indicating active transmission.  |

---

## How to Use

### Simulation
1. Use any VHDL simulator (e.g., ModelSim, Vivado).
2. Run the testbench (`tb_uart_tr.vhd`) to validate the module:
   - Observe the `TXD` output for serialized data.
   - Verify the transitions of the `BSY` signal and FSM states.

### Synthesis
1. The `uart_tr` module can be synthesized for FPGA or ASIC designs.
2. Ensure the input clock frequency (`BCLK`) matches the desired baud rate for accurate operation.

---

## License

This project is licensed under the CERN-OHL-P v2.0. See the [LICENSE](https://cern.ch/cern-ohl-p) for details.

## Author

- **Arsalan Dabbagh**
  - Field: FPGA, ASIC, Embedded Systems Design
  - Contact: [Your Contact Info Here]

## Acknowledgments

Special thanks to contributors and reviewers who helped in refining this project.

---


