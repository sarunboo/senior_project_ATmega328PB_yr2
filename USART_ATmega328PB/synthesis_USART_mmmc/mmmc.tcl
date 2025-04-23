create_library_set -name scc013ull_hd_rvt_ss_v1p08_125c_basic -timing {"scc013ull_hd_rvt_ss_v1p08_125c_basic.lib"}
create_library_set -name scc013ull_hd_rvt_ff_v1p32_-40c_basic -timing {"scc013ull_hd_rvt_ff_v1p32_-40c_basic.lib"}
create_library_set -name scc013ull_hd_rvt_tt_v1p5_25c_basic -timing {"scc013ull_hd_rvt_tt_v1p5_25c_basic.lib"}

create_opcond -name ss_v1p08_125c -process 1 -voltage 1.08 -temperature 125
create_opcond -name ff_v1p32 -process 1 -voltage 1.32 -temperature -40
create_opcond -name tt_v1p5_25c -process 1 -voltage 1.5 -temperature 25

# create_timing_condition -name timing_cond_ss_v1p08_125c -opcond slow -library_sets { ss_v1p08_125c }
# create_timing_condition -name timing_cond_ff_v1p32 -opcond fast -library_sets { ff_v1p32 }
# create_timing_condition -name timing_cond_tt_v1p5_25c -opcond typical -library_sets { tt_v1p5_25c }
create_timing_condition -name timing_cond_ss_v1p08_125c -library_sets { scc013ull_hd_rvt_ss_v1p08_125c_basic }
create_timing_condition -name timing_cond_ff_v1p32 -library_sets { scc013ull_hd_rvt_ff_v1p32_-40c_basic }
create_timing_condition -name timing_cond_tt_v1p5_25c -library_sets { scc013ull_hd_rvt_tt_v1p5_25c_basic }

create_rc_corner -name rc_corner
create_rc_corner -name rc_corner -qrc_tech /nfs/mcu8b/sarun/01lib_v/scc013u_hd_7lm_1tm_thin.tf

# create_delay_corner -name delay_corner_ss_v1p08_125c -rc_corner {rc_corner} -library_set {scc013ull_hd_rvt_ss_v1p08_125c_basic}
# create_delay_corner -name delay_corner_ff_v1p32 -rc_corner {rc_corner} -library_set {scc013ull_hd_rvt_ff_v1p32_-40c_basic}
# create_delay_corner -name delay_corner_tt_v1p5_25c -rc_corner {rc_corner} -library_set {scc013ull_hd_rvt_tt_v1p5_25c_basic}
create_delay_corner -name delay_corner_ss_v1p08_125c -rc_corner {rc_corner} -early_timing_condition timing_cond_ss_v1p08_125c \
-late_timing_condition timing_cond_ss_v1p08_125c -early_rc_corner rc_corner \
-late_rc_corner rc_corner
create_delay_corner -name delay_corner_ff_v1p32 -rc_corner {rc_corner} -early_timing_condition timing_cond_ff_v1p32 \
-late_timing_condition timing_cond_ff_v1p32 -early_rc_corner rc_corner \
-late_rc_corner rc_corner
create_delay_corner -name delay_corner_tt_v1p5_25c -rc_corner {rc_corner} -early_timing_condition timing_cond_tt_v1p5_25c \
-late_timing_condition timing_cond_tt_v1p5_25c -early_rc_corner rc_corner \
-late_rc_corner rc_corner

create_constraint_mode -name functional_ss_v1p08_125c -sdc_files /nfs/mcu8b/sarun/synthesis_USART_mmmc/constraints/USARTn_constraints_ss.sdc
create_constraint_mode -name functional_ff_v1p32 -sdc_files /nfs/mcu8b/sarun/synthesis_USART_mmmc/constraints/USARTn_constraints_ff.sdc
create_constraint_mode -name functional_tt_v1p5_25c -sdc_files /nfs/mcu8b/sarun/synthesis_USART_mmmc/constraints/USARTn_constraints_tt.sdc

create_analysis_view -name view_ss_v1p08_125c -constraint_mode functional_ss_v1p08_125c -delay_corner delay_corner_ss_v1p08_125c
create_analysis_view -name view_ff_v1p32 -constraint_mode functional_ff_v1p32 -delay_corner delay_corner_ff_v1p32
create_analysis_view -name view_tt_v1p5_25c -constraint_mode functional_tt_v1p5_25c -delay_corner delay_corner_tt_v1p5_25c
# create_analysis_view -name view_ss_v1p08_125c -constraint_mode functional_ss_v1p08_125c
# create_analysis_view -name view_ff_v1p32 -constraint_mode functional_ff_v1p32
# create_analysis_view -name view_tt_v1p5_25c -constraint_mode functional_tt_v1p5_25c

set_analysis_view -setup { view_ss_v1p08_125c view_ff_v1p32 view_tt_v1p5_25c}
write_mmmc -dir outputs/