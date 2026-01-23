#!/bin/bash

_CSV="./data/MT25036_Part_D_CSV.csv"
_CORE=2

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")

echo "Program+Function,num_workers,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do

    if [ "$program" == "A" ]; then
        NUM_WORKERS=(2 3 4 5)
    else
        NUM_WORKERS=(2 3 4 5 6 7 8)
    fi

    for function in "${FUNCTIONS[@]}"; do
        for K in "${NUM_WORKERS[@]}"; do

            echo "Running $program+$function with $K workers"

            top -b -d 1 -n 6 > /tmp/top_out_d &
            TOP_PID=$!
            
            iostat -dx 1 6 > /tmp/io_out_d &
            IO_PID=$!

            if [ "$program" == "A" ]; then
                EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramA $function $K 2>&1)
            else
                EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramB $function $K 2>&1)
            fi

            wait $TOP_PID $IO_PID

            CPU_AVG=$(awk 'NR>7 && NF {sum+=$9; c++} END {if(c>0) print sum/c; else print 0}' /tmp/top_out_d)
            MEM_AVG=$(awk 'NR>7 && NF {sum+=$10; c++} END {if(c>0) print sum/c; else print 0}' /tmp/top_out_d)

            DREAD=$(awk 'NR>3 && NF {r+=$6; c++} END {if(c>0) print r/c; else print 0}' /tmp/io_out_d)
            DWRITE=$(awk 'NR>3 && NF {w+=$7; c++} END {if(c>0) print w/c; else print 0}' /tmp/io_out_d)
            DUTIL=$(awk 'NR>3 && NF {u+=$NF; c++} END {if(c>0) print u/c; else print 0}' /tmp/io_out_d)

            echo "$program+$function,$K,$CPU_AVG,$MEM_AVG,$DREAD,$DWRITE,$DUTIL,$EXEC_TIME" >> $_CSV

        done
    done
done

rm -f /tmp/top_out_d /tmp/io_out_d