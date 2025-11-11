# Copyright (c) 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>

# All paths relative to yosys/

puts "0. Executing init_tech: load technology from Github PDK"
if {![info exists pdk_dir]} {
	set pdk_dir "../icsprout55/pdk"
}
set pdk_cells_lib ${pdk_dir}/IP/STD_cell/ics55_LLSC_H7C_V1p10C100/ics55_LLSC_H7CR/liberty
set pdk_io_lib    ${pdk_dir}/IP/IO/ICsprout_55LLULP1233_IO_251013/liberty

set tech_cells [list "$pdk_cells_lib/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib"]
set tech_macros [list ]
lappend tech_macros "$pdk_io_lib/ICSIOA_N55_3P3_tt_1p2_3p3_25c.lib"

# for hilomap
set tech_cell_tiehi {TIEHIH7R Z}
set tech_cell_tielo {TIELOH7R Z}

# pre-formated for easier use in yosys commands
# all liberty files
set lib_list [concat [split $tech_cells] [split $tech_macros] ]
set liberty_args_list [lmap lib $lib_list {concat "-liberty" $lib}]
set liberty_args [concat {*}$liberty_args_list]
# only the standard cells
set tech_cells_args_list [lmap lib $tech_cells {concat "-liberty" $lib}]
set tech_cells_args [concat {*}$tech_cells_args_list]

# read library files
foreach file $lib_list {
	yosys read_liberty -lib "$file"
}