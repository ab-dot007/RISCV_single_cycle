#====================================================================
# RISCV_CPU_CORE — Genus Synthesis Run Script
# Flow control only. All timing constraints live in the companion
# riscv_cpu.sdc file and are pulled in via read_sdc below.
#=====================================================================


# ---------------------------------------------------------------
# >>> PASTE PATH: directory containing your 12 RTL source files <<<
# e.g. set RTL_DIR   /home/user/riscv_cpu/rtl<PASTE_RTL_DIRECTORY_PATH_HERE>
# ---------------------------------------------------------------
set RTL_DIR     /run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/RISCV_core/

# ---------------------------------------------------------------
# >>> PASTE PATH: directory containing your .lib timing libraries <<<
# e.g. set LIB_DIR   /home/user/pdk/lib
# ---------------------------------------------------------------
set LIB_DIR     /run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/lib_fast/

# ---------------------------------------------------------------
# >>> PASTE PATH: directory containing your SDC constraints file <<<
# e.g. set CONSTR_DIR   /home/user/riscv_cpu/constraints
# ---------------------------------------------------------------
set CONSTR_DIR  /run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/RISCV_constrain/

set OUT_DIR      /run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/RISCV_gsyn/out/
set REPORT_DIR   /run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/RISCV_gsyn/reports/

file mkdir $OUT_DIR
file mkdir $REPORT_DIR

set_db information_level      7
set_db max_cpus_per_server    4

set_db init_lib_search_path   $LIB_DIR


set_db lib_search_path        $LIB_DIR
set_db hdl_search_path        $RTL_DIR


# -------------------- 1. Read technology libraries --------------------
# ---------------------------------------------------------------
# >>> PASTE FILE NAMES: your actual worst-case (setup) and
#     best-case (hold) corner .lib files, replacing the two
#     placeholder names below <<<
# ---------------------------------------------------------------
set_db library $LIB_DIR/tsl18fs120_scl_ff.lib

# Optional, only if doing physical-aware (iSpatial) synthesis:
# ---------------------------------------------------------------
# >>> PASTE PATH: tech LEF and standard-cell LEF, if using iSpatial <<<
# ---------------------------------------------------------------
# read_physical -lef { <PASTE_TECH_LEF_PATH> <PASTE_STDCELL_LEF_PATH> }

# -------------------- 2. Read and elaborate RTL --------------------
read_hdl -sv {
    Branch_control.v
    Datamem_WB_TOP.v
    Imm_gen.v
    Control_top.v
    ALU_control.v
    Instr_mem.v
    Execute_TOP.v
    PC_control.v
    ALU_allfn.v
    Main_control.v
    Reg_file.v
    RISCV_CPU.v
}

elaborate  RISCV_CPU

# -------------------- 3. Design health checks (do not skip) --------------------
check_design -unresolved       > $REPORT_DIR/check_unresolved.rpt
check_design -multiple_driver  > $REPORT_DIR/check_multidriver.rpt
check_design -unloaded         > $REPORT_DIR/check_unloaded.rpt
report_gen_lib_config          > $REPORT_DIR/lib_config.rpt

# -------------------- 4. Read constraints (SDC lives separately) --------------------
read_sdc $CONSTR_DIR/constrain.sdc

# -------------------- 5. Synthesis stages --------------------
syn_generic
syn_map
syn_opt

# Optional second pass after reviewing first-pass QoR:
# syn_opt -incremental

# -------------------- 6. Post-synthesis analysis --------------------
report_timing -max_paths 20 -nworst 5   > $REPORT_DIR/timing_setup.rpt
report_timing -delay_type min           > $REPORT_DIR/timing_hold.rpt
report_area   -depth 2                  > $REPORT_DIR/area.rpt
report_power                            > $REPORT_DIR/power.rpt
report_qor                              > $REPORT_DIR/qor.rpt
check_timing_intent                     > $REPORT_DIR/timing_intent.rpt
report_gates                            > $REPORT_DIR/gates.rpt

# -------------------- 7. Optional DFT scan insertion --------------------
# Recommended given no-reset Reg_File / DataMem (see RTL review notes) —
# gives a deterministic way to load/observe state for ATPG and bring-up.
# set_db design_dft_chain_count 1
# insert_dft
# define_scan_chain -name chain1 -sdi scan_in -sdo scan_out

# -------------------- 8. Write outputs for Innovus handoff --------------------
write_hdl                        > $OUT_DIR/${DESIGN}_netlist_G.v
write_sdc                        > $OUT_DIR/${DESIGN}_synth_G.sdc
write_sdf -setup -hold           > $OUT_DIR/${DESIGN}_synth_G.sdf
write_script                     > $OUT_DIR/${DESIGN}_genus_run.tcl
write_design -innovus -base_name $OUT_DIR/${DESIGN}_handoff

report_summary -outfile $REPORT_DIR/summary

puts "=== Genus synthesis flow complete for $DESIGN ==="
puts "=== Review $REPORT_DIR/timing_setup.rpt BEFORE trusting the T_CLK value in riscv_cpu.sdc ==="
puts "=== Run formal LEC (netlist vs RTL) before moving to Innovus ==="

/run/media/user1/c2s/Btech_Internship_2026/AEI/Team_5/abhinav/RISCV_core/
