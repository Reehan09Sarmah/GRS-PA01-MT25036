#!/bin/bash

_CSV="MT25036_Part_D_CSV.csv"
_CORE=2

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")

echo "Program+Function,num_workers,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do

    if ["$program" == "A"]; then
        NUM_WORKERS=(2 3 4 5)
    else
        NUM_WORKERS=(2 3 4 5 6 7 8)
    fi

    for function in "${FUNCTIONS[@]}"; do
        for K in "${NUM_WORKERS[@]}"; do

            echo "Running $program+$function, number of workers = $K"

            START_TIME
