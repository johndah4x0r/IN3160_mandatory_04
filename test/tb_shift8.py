#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, ValueChange

# Compensate for 1e3 multiplicative error
TIME_UNIT="us"

@cocotb.test()
async def main_test(dut):
    dut._log.info("Applying stimuli...")
    
    # DUT in reset
    dut.rst_n.value = 0

    # Default serial input
    dut.serial_in.value = 0
    
    # Starting clock
    dut._log.info("Starting clock")
    cocotb.start_soon(Clock(dut.mclk, 100, unit=TIME_UNIT).start())
    
    # Hold the reset flag for 200 ns, then
    # unset it (rst_n <= 1), then apply a
    # 200 ns pulse at the serial input
    # - the reset command doesn't apply
    # for the first clock cycle
    await Timer(200, unit=TIME_UNIT)
    dut.rst_n.value = 1
    dut.serial_in.value = 1

    await Timer(200, unit=TIME_UNIT)
    dut.serial_in.value = 0

    # apply a reset commant 400 ns later
    await Timer(400, unit=TIME_UNIT)
    dut.rst_n.value = 0
    await Timer(100, unit=TIME_UNIT)
    dut.rst_n.value = 1

    await Timer(200, unit=TIME_UNIT)
    dut._log.info("Stimuli done")

    await Timer(400, unit=TIME_UNIT)
