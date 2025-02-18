# DoQuartus.tcl
# ----------------------------------------------------
# Complete Tcl script File :
# Project creation, assignments, compilation, download
# Can run this script from Quartus II Tcl console, or directly :
#  quartus_sh -t doquartus.tcl
#-----------------------------------------------------

set MyProj DE1_SoC

# ---- Load Quartus II Tcl Project package

package require ::quartus::project
package require ::quartus::flow

# ---- Handels command line option

package require cmdline
set options {\
   { "revision.arg" "" "Project Revision" } \
#   { "src_dir.arg" "" "Project Source Directory" } \
#   { "sv_dir.arg" "" "SV Source Directory" } \
    }
array set opts [::cmdline::getoptions quartus(args) $options]

# ---- Check that the right project is open
if {[is_project_open]} {
   if {[string compare -nocase $quartus(project) $MyProj]} {
      puts "Error : another project is already opened."
      puts "Please close this project and try again."
      exit
  } else {
     puts "The project $MyProj was already open..."
  }
} else {
   # Only open if not already open
   if {[project_exists $MyProj]} {
      project_open -revision $opts(revision) $MyProj
  } else {
     project_new -revision $opts(revision) $MyProj
  }
}

# -- remove the old rbf file (if exists)
if [file exists ${MyProj}.rbf]  {
   file delete  ${MyProj}.rbf
}


# ---- Project Assignments (Verilog source files)
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/DE1_SoC.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/gene_reset.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/RISCV.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/ram.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/rom.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/dec7seg.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/ALU.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/decaleur.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/decaleurSigned.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/decoder.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/programme_counter.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/regs.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/state_machine.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file_pipeline/VGA_controller.sv
set_global_assignment -name VERILOG_FILE ../RISCV_file_pipeline/framebuffer.v


# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/DE1_SoC.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/gene_reset.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/RISCV.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/ram.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/rom.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/dec7seg.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/ALU.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/decaleur.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/decaleurSigned.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/decoder.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/programme_counter.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/regs.sv
# set_global_assignment -name SYSTEMVERILOG_FILE ../RISCV_file/state_machine.sv

# TODO: Ajouter ici tous les fichiers SystemVerilog de votre projet


set_global_assignment -name TOP_LEVEL_ENTITY $MyProj

# Analysis & Synthesis Assignments
# ================================
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"

set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85

set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "<None>"
set_global_assignment -name AUTO_ENABLE_SMART_COMPILE ON
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name HDL_MESSAGE_LEVEL LEVEL1

# ---- Compiler Assignments for top
# ---- The argument is the revision
# ---- not the project
set_project_settings -cmp $opts(revision) 
set_global_assignment -name COMPILATION_LEVEL FULL

# ---- Pin assignments
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_adcdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_adclrck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_bclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_dacdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_daclrck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aud_mclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to fpga_i2c_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to fpga_i2c_sdat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_0[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_1[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex2[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex3[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex4[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex5[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to key[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to key[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to key[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to key[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ledr[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sw[9]
set_location_assignment PIN_K7 -to aud_adcdat
set_location_assignment PIN_K8 -to aud_adclrck
set_location_assignment PIN_H7 -to aud_bclk
set_location_assignment PIN_J7 -to aud_dacdat
set_location_assignment PIN_H8 -to aud_daclrck
set_location_assignment PIN_G7 -to aud_mclk
set_location_assignment PIN_AF14 -to clock_50
set_location_assignment PIN_J12 -to fpga_i2c_sclk
set_location_assignment PIN_K12 -to fpga_i2c_sdat
set_location_assignment PIN_AC18 -to gpio_0[0]
set_location_assignment PIN_AH18 -to gpio_0[10]
set_location_assignment PIN_AH17 -to gpio_0[11]
set_location_assignment PIN_AG16 -to gpio_0[12]
set_location_assignment PIN_AE16 -to gpio_0[13]
set_location_assignment PIN_AF16 -to gpio_0[14]
set_location_assignment PIN_AG17 -to gpio_0[15]
set_location_assignment PIN_AA18 -to gpio_0[16]
set_location_assignment PIN_AA19 -to gpio_0[17]
set_location_assignment PIN_AE17 -to gpio_0[18]
set_location_assignment PIN_AC20 -to gpio_0[19]
set_location_assignment PIN_Y17 -to gpio_0[1]
set_location_assignment PIN_AH19 -to gpio_0[20]
set_location_assignment PIN_AJ20 -to gpio_0[21]
set_location_assignment PIN_AH20 -to gpio_0[22]
set_location_assignment PIN_AK21 -to gpio_0[23]
set_location_assignment PIN_AD19 -to gpio_0[24]
set_location_assignment PIN_AD20 -to gpio_0[25]
set_location_assignment PIN_AE18 -to gpio_0[26]
set_location_assignment PIN_AE19 -to gpio_0[27]
set_location_assignment PIN_AF20 -to gpio_0[28]
set_location_assignment PIN_AF21 -to gpio_0[29]
set_location_assignment PIN_AD17 -to gpio_0[2]
set_location_assignment PIN_AF19 -to gpio_0[30]
set_location_assignment PIN_AG21 -to gpio_0[31]
set_location_assignment PIN_AF18 -to gpio_0[32]
set_location_assignment PIN_AG20 -to gpio_0[33]
set_location_assignment PIN_AG18 -to gpio_0[34]
set_location_assignment PIN_AJ21 -to gpio_0[35]
set_location_assignment PIN_Y18 -to gpio_0[3]
set_location_assignment PIN_AK16 -to gpio_0[4]
set_location_assignment PIN_AK18 -to gpio_0[5]
set_location_assignment PIN_AK19 -to gpio_0[6]
set_location_assignment PIN_AJ19 -to gpio_0[7]
set_location_assignment PIN_AJ17 -to gpio_0[8]
set_location_assignment PIN_AJ16 -to gpio_0[9]
set_location_assignment PIN_AB17 -to gpio_1[0]
set_location_assignment PIN_AG26 -to gpio_1[10]
set_location_assignment PIN_AH24 -to gpio_1[11]
set_location_assignment PIN_AH27 -to gpio_1[12]
set_location_assignment PIN_AJ27 -to gpio_1[13]
set_location_assignment PIN_AK29 -to gpio_1[14]
set_location_assignment PIN_AK28 -to gpio_1[15]
set_location_assignment PIN_AK27 -to gpio_1[16]
set_location_assignment PIN_AJ26 -to gpio_1[17]
set_location_assignment PIN_AK26 -to gpio_1[18]
set_location_assignment PIN_AH25 -to gpio_1[19]
set_location_assignment PIN_AA21 -to gpio_1[1]
set_location_assignment PIN_AJ25 -to gpio_1[20]
set_location_assignment PIN_AJ24 -to gpio_1[21]
set_location_assignment PIN_AK24 -to gpio_1[22]
set_location_assignment PIN_AG23 -to gpio_1[23]
set_location_assignment PIN_AK23 -to gpio_1[24]
set_location_assignment PIN_AH23 -to gpio_1[25]
set_location_assignment PIN_AK22 -to gpio_1[26]
set_location_assignment PIN_AJ22 -to gpio_1[27]
set_location_assignment PIN_AH22 -to gpio_1[28]
set_location_assignment PIN_AG22 -to gpio_1[29]
set_location_assignment PIN_AB21 -to gpio_1[2]
set_location_assignment PIN_AF24 -to gpio_1[30]
set_location_assignment PIN_AF23 -to gpio_1[31]
set_location_assignment PIN_AE22 -to gpio_1[32]
set_location_assignment PIN_AD21 -to gpio_1[33]
set_location_assignment PIN_AA20 -to gpio_1[34]
set_location_assignment PIN_AC22 -to gpio_1[35]
set_location_assignment PIN_AC23 -to gpio_1[3]
set_location_assignment PIN_AD24 -to gpio_1[4]
set_location_assignment PIN_AE23 -to gpio_1[5]
set_location_assignment PIN_AE24 -to gpio_1[6]
set_location_assignment PIN_AF25 -to gpio_1[7]
set_location_assignment PIN_AF26 -to gpio_1[8]
set_location_assignment PIN_AG25 -to gpio_1[9]
set_location_assignment PIN_AE26 -to hex0[0]
set_location_assignment PIN_AE27 -to hex0[1]
set_location_assignment PIN_AE28 -to hex0[2]
set_location_assignment PIN_AG27 -to hex0[3]
set_location_assignment PIN_AF28 -to hex0[4]
set_location_assignment PIN_AG28 -to hex0[5]
set_location_assignment PIN_AH28 -to hex0[6]
set_location_assignment PIN_AJ29 -to hex1[0]
set_location_assignment PIN_AH29 -to hex1[1]
set_location_assignment PIN_AH30 -to hex1[2]
set_location_assignment PIN_AG30 -to hex1[3]
set_location_assignment PIN_AF29 -to hex1[4]
set_location_assignment PIN_AF30 -to hex1[5]
set_location_assignment PIN_AD27 -to hex1[6]
set_location_assignment PIN_AB23 -to hex2[0]
set_location_assignment PIN_AE29 -to hex2[1]
set_location_assignment PIN_AD29 -to hex2[2]
set_location_assignment PIN_AC28 -to hex2[3]
set_location_assignment PIN_AD30 -to hex2[4]
set_location_assignment PIN_AC29 -to hex2[5]
set_location_assignment PIN_AC30 -to hex2[6]
set_location_assignment PIN_AD26 -to hex3[0]
set_location_assignment PIN_AC27 -to hex3[1]
set_location_assignment PIN_AD25 -to hex3[2]
set_location_assignment PIN_AC25 -to hex3[3]
set_location_assignment PIN_AB28 -to hex3[4]
set_location_assignment PIN_AB25 -to hex3[5]
set_location_assignment PIN_AB22 -to hex3[6]
set_location_assignment PIN_AA24 -to hex4[0]
set_location_assignment PIN_Y23 -to hex4[1]
set_location_assignment PIN_Y24 -to hex4[2]
set_location_assignment PIN_W22 -to hex4[3]
set_location_assignment PIN_W24 -to hex4[4]
set_location_assignment PIN_V23 -to hex4[5]
set_location_assignment PIN_W25 -to hex4[6]
set_location_assignment PIN_V25 -to hex5[0]
set_location_assignment PIN_AA28 -to hex5[1]
set_location_assignment PIN_Y27 -to hex5[2]
set_location_assignment PIN_AB27 -to hex5[3]
set_location_assignment PIN_AB26 -to hex5[4]
set_location_assignment PIN_AA26 -to hex5[5]
set_location_assignment PIN_AA25 -to hex5[6]
set_location_assignment PIN_AA14 -to key[0]
set_location_assignment PIN_AA15 -to key[1]
set_location_assignment PIN_W15 -to key[2]
set_location_assignment PIN_Y16 -to key[3]
set_location_assignment PIN_V16 -to ledr[0]
set_location_assignment PIN_W16 -to ledr[1]
set_location_assignment PIN_V17 -to ledr[2]
set_location_assignment PIN_V18 -to ledr[3]
set_location_assignment PIN_W17 -to ledr[4]
set_location_assignment PIN_W19 -to ledr[5]
set_location_assignment PIN_Y19 -to ledr[6]
set_location_assignment PIN_W20 -to ledr[7]
set_location_assignment PIN_W21 -to ledr[8]
set_location_assignment PIN_Y21 -to ledr[9]
set_location_assignment PIN_AB12 -to sw[0]
set_location_assignment PIN_AC12 -to sw[1]
set_location_assignment PIN_AF9 -to sw[2]
set_location_assignment PIN_AF10 -to sw[3]
set_location_assignment PIN_AD11 -to sw[4]
set_location_assignment PIN_AD12 -to sw[5]
set_location_assignment PIN_AE11 -to sw[6]
set_location_assignment PIN_AC9 -to sw[7]
set_location_assignment PIN_AD10 -to sw[8]
set_location_assignment PIN_AE12 -to sw[9]

# interface VGA
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL"  -to VGA*
set_instance_assignment -name CURRENT_STRENGTH_NEW "8MA" -to VGA*
set_instance_assignment -name SLEW_RATE 1 -to  VGA*
set_location_assignment PIN_B13 -to VGA_B[0]
set_location_assignment PIN_G13 -to VGA_B[1]
set_location_assignment PIN_H13 -to VGA_B[2]
set_location_assignment PIN_F14 -to VGA_B[3]
set_location_assignment PIN_H14 -to VGA_B[4]
set_location_assignment PIN_F15 -to VGA_B[5]
set_location_assignment PIN_G15 -to VGA_B[6]
set_location_assignment PIN_J14 -to VGA_B[7]
set_location_assignment PIN_F10 -to VGA_BLANK
set_location_assignment PIN_A11 -to VGA_CLK
set_location_assignment PIN_J9 -to VGA_G[0]
set_location_assignment PIN_J10 -to VGA_G[1]
set_location_assignment PIN_H12 -to VGA_G[2]
set_location_assignment PIN_G10 -to VGA_G[3]
set_location_assignment PIN_G11 -to VGA_G[4]
set_location_assignment PIN_G12 -to VGA_G[5]
set_location_assignment PIN_F11 -to VGA_G[6]
set_location_assignment PIN_E11 -to VGA_G[7]
set_location_assignment PIN_B11 -to VGA_HS
set_location_assignment PIN_A13 -to VGA_R[0]
set_location_assignment PIN_C13 -to VGA_R[1]
set_location_assignment PIN_E13 -to VGA_R[2]
set_location_assignment PIN_B12 -to VGA_R[3]
set_location_assignment PIN_C12 -to VGA_R[4]
set_location_assignment PIN_D12 -to VGA_R[5]
set_location_assignment PIN_E12 -to VGA_R[6]
set_location_assignment PIN_F13 -to VGA_R[7]
set_location_assignment PIN_C10 -to VGA_SYNC
set_location_assignment PIN_D11 -to VGA_VS


set_global_assignment -name OPTIMIZE_POWER_DURING_FITTING OFF
set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL OFF
set_global_assignment -name NUMBER_OF_PATHS_TO_REPORT 0
set_global_assignment -name NUMBER_OF_DESTINATION_TO_REPORT 0
set_global_assignment -name NUMBER_OF_SOURCES_PER_DESTINATION_TO_REPORT 0

set_global_assignment -name SDC_FILE Timing.sdc


# -- Run Design Assistant
# set_global_assignment -name ENABLE_DRC_SETTINGS ON

#---- Commit assignments
export_assignments
puts "Assignments done, starting compilation..."

#---- Compile using ::quartus::flow
execute_flow -compile


