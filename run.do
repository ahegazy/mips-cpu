if [file exists "work"] {vdel -all}
vlib work

vlog *.v

vsim -novopt work.cpu_TB

run -all