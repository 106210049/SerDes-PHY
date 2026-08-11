package serdes_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef uvm_config_db#(virtual serdes_if) serdes_vif_config;

    `include "serdes_packet.sv"
    `include "serdes_driver.sv"
    `include "serdes_sequencer.sv"
    `include "serdes_monitor.sv"
    `include "serdes_sequences.sv"
    `include "serdes_agent.sv"
    `include "serdes_env.sv"
endpackage: serdes_pkg