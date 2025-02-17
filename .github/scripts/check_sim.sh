#!/bin/bash
# Copyright (c) 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Author:  Philippe Sauter <phsauter@iis.ee.ethz.ch>

LOG_FILE=$1

expected_lines=(
  "[CORE] Start fetching instructions"
  "[JTAG] Halting hart 0"
  "[JTAG] Resumed hart 0"
  "[UART] Hello World!"
  "[UART] Result: 0x8940, Cycles: 0xBD"
  "[UART] Tick"
  "[UART] Tock"
)

for line in "${EXPECTED_LINES[@]}"; do
  if ! grep -q "$line" "$LOG_FILE"; then
    echo "Error: Expected line not found in the log: '$line'"
    exit 1
  fi
done

TICK_TIMESTAMP=$(awk '/Tick/ {gsub("ns", "", $1); print $1}' "$LOG_FILE")
TOCK_TIMESTAMP=$(awk '/Tock/ {gsub("ns", "", $1); print $1}' "$LOG_FILE")

TIME_DIFF=$((TOCK_TIMESTAMP - TICK_TIMESTAMP))
TIME_DIFF_MS=$((TIME_DIFF / 1000000))

# 1ms tolerance
if ((TIME_DIFF_MS >= 9 && TIME_DIFF_MS <= 11)); then
  echo "Timer correct: The gap between Tick and Tock is approximately 10ms: ${TIME_DIFF_MS}ms."
else
  echo "Timer Error: The gap between Tick and Tock is not approximately 10ms: ${TIME_DIFF_MS}ms."
  exit 1
fi

echo "Hello world simulation passed."
exit 0
