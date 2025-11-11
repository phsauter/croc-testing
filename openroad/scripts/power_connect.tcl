# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Philippe Sauter   <phsauter@iis.ee.ethz.ch>


##########################################################################
# Global Connections
##########################################################################

# IOs and std cells
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VDD} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VSS} -ground
# fix for bondpad/port naming
add_global_connection -net {VDDIO} -inst_pattern {.*} -pin_pattern {.*VDD_RING} -power
add_global_connection -net {VSSIO} -inst_pattern {.*} -pin_pattern {.*VSS_RING} -ground
# pads
add_global_connection -net {VDDIO} -inst_pattern {.*} -pin_pattern {VDDIO} -power
add_global_connection -net {VSSIO} -inst_pattern {.*} -pin_pattern {VSSIO} -ground

# connection
global_connect

# voltage domains
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
# standard cell grid and rings
define_pdn_grid -name {core_grid} -voltage_domains {CORE}