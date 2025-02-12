### Test Plan for AXI-HyperBus Bridge Verification

1. Overview

This test plan outlines the verification strategy for the AXI-HyperBus Bridge, ensuring that the AXI slave interface correctly translates transactions to the HyperBus master interface.

2. Verification Objectives

- Validate AXI write transactions.

- Validate AXI read transactions.

- Verify correct data transfer to/from HyperBus.

- Test error handling and edge cases.

- Validate reset behavior.

- Ensure protocol timing constraints are met.

3. Test Scenarios

3.1 Reset Functionality

- Assert reset (aresetn = 0), ensure all signals initialize correctly.

- Deassert reset (aresetn = 1), ensure normal operation resumes.

3.2 Write Transaction

- Issue write address (awaddr) and data (wdata), set awvalid and wvalid.

- Check that awready and wready are asserted.

- Ensure bvalid is asserted, indicating write completion.

- Check if hyper_addr, hyper_dq, and hyper_we_n match expected values.

3.3 Read Transaction

- Issue read address (araddr), set arvalid.

- Check that arready is asserted.

- Verify rvalid assertion and data availability on rdata.

- Ensure correct HyperBus signals are toggled (hyper_addr, hyper_re_n).

3.4 Back-to-Back Transactions

- Perform multiple read/write operations without waiting for the previous to complete.

- Ensure bridge maintains proper transaction order and data integrity.

3.5 Error Handling

- Simulate timeout scenarios where HyperBus does not respond.

- Test AXI protocol violations (e.g., premature deassertion of awvalid).

- Verify that invalid reads/writes return appropriate responses.

4. Expected Results

- AXI transactions should successfully map to HyperBus operations.

- Data written should be correctly retrieved on a subsequent read.

Reset should properly clear internal states.

The bridge should handle error conditions gracefully.

5. Testbench Features






### AXI INterface (slave)

![image](https://github.com/user-attachments/assets/99c4545c-821c-49cb-9bc7-3bad47a66742)

![image](https://github.com/user-attachments/assets/9a73a77b-05ac-44b7-974d-7b57a96dba86)

1. Write Transaction Flow (AXI to HyperBus)

- AXI master sends awaddr → bridge asserts awready
- AXI master sends wdata → bridge asserts wready
- Bridge converts AXI signals to hyper_addr, hyper_we_n, and hyper_dq
- bvalid is asserted when the write completes

2. Read Transaction Flow (AXI to HyperBus)

- AXI master sends araddr → bridge asserts arready
- Bridge asserts hyper_re_n and places read data onto hyper_dq
- rvalid is asserted when rdata is ready
