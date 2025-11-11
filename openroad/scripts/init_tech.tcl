# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Tobias Senti      <tsenti@ethz.ch>
# - Jannis Schönleber <janniss@iis.ee.ethz.ch>
# - Philippe Sauter   <phsauter@iis.ee.ethz.ch>

# Initialize the PDK

utl::report "Init tech from Github PDK"
if {![info exists pdk_dir]} {
	set pdk_dir "../icsprout55/pdk"
}
set pdk_cells_lib ${pdk_dir}/IP/STD_cell/ics55_LLSC_H7C_V1p10C100/ics55_LLSC_H7CR/liberty
set pdk_cells_lef ${pdk_dir}/IP/STD_cell/ics55_LLSC_H7C_V1p10C100/ics55_LLSC_H7CR/lef
set pdk_io_lib    ${pdk_dir}/IP/IO/ICsprout_55LLULP1233_IO_251013/liberty
set pdk_io_lef    ${pdk_dir}/IP/IO/ICsprout_55LLULP1233_IO_251013/lef

# LIB
define_corners tt ff

puts "Init standard cells"
read_liberty -corner tt ${pdk_cells_lib}/ics55_LLSC_H7CR_typ_tt_1p2_25_nldm.lib
read_liberty -corner ff ${pdk_cells_lib}/ics55_LLSC_H7CR_ff_rcbest_1p32_m40_nldm.lib

puts "Init IO cells"
read_liberty -corner tt ${pdk_io_lib}/ICSIOA_N55_3P3_tt_1p2_3p3_25c.lib
read_liberty -corner ff ${pdk_io_lib}/ICSIOA_N55_3P3_ff_1p32_3p63_m40c.lib

# puts "Init SRAM macros"

puts "Init tech-lef"
read_lef ${pdk_dir}/prtech/techLEF/N551P6M_ieda.lef

puts "Init cell-lef"
read_lef ${pdk_cells_lef}/ics55_LLSC_H7CR_ieda.lef
read_lef ${pdk_io_lef}/ICSIOA_N55_3P3_1P6M1TM.lef
read_lef ${pdk_dir}/../bondpad_50x50.lef

# foreach file [glob -directory $pdk_sram_lef *.lef] {
# 	read_lef "$file"
# }

set ctsBuf [ list BUFX20H7R BUFX16H7R BUFX12H7R BUFX10H7R BUFX8H7R BUFX7H7R BUFX6H7R BUFX5H7R BUFX4H7R ]
set ctsBufRoot BUFX20H7R

set stdfill [ list FILLER64H7R FILLER32H7R FILLER16H7R FILLER8H7R FILLER4H7R FILLER2H7R FILLER1H7R ]

set iocorner P65_1233_CORNER
set iofill [ list P65_1233_FILLER50 P65_1233_FILLER20 P65_1233_FILLER10 P65_1233_FILLER5 P65_1233_FILLER2 P65_1233_FILLER1 P65_1233_FILLER01 P65_1233_FILLER001 P65_1233_FILLER0005 ]

set dont_use_cells [list ]

proc makeTracks {} {
    utl::report "Metal Tracks"
	make_tracks MET1 -x_offset 0 -x_pitch 0.2  -y_offset 0 -y_pitch 0.2
	make_tracks MET2 -x_offset 0 -x_pitch 0.2  -y_offset 0 -y_pitch 0.2
	make_tracks MET3 -x_offset 0 -x_pitch 0.2  -y_offset 0 -y_pitch 0.2
	make_tracks MET4 -x_offset 0 -x_pitch 0.2  -y_offset 0 -y_pitch 0.2
	make_tracks MET5 -x_offset 0 -x_pitch 0.2  -y_offset 0 -y_pitch 0.2
	make_tracks T4M2 -x_offset 0 -x_pitch 0.8  -y_offset 0 -y_pitch 0.8
	make_tracks RDL  -x_offset 0 -x_pitch 5.0  -y_offset 0 -y_pitch 5.0
}
