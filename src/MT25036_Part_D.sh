#!/bin/bash

_CSV="MT25036_Part_D_CSV.csv"
_CORE=2

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")

echo "Program+Function,num_workers,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do

    if ["$program" == "A"]; then
        NUM_WORKERS=(2 3 4)
    else
        NUM_WORKERS=(2 3 4)
    fi

    for function in "${FUNCTIONS[@]}"; do
        for K in "${NUM_WORKERS[@]}"; do

            echo "Running $program+$function, number of workers = $K"

            top -b -d 1 -n 5 | grep "Program$program" |
            awk '{cpu+=$9; mem+=$10; cnt++}
                END {if(cnt > 0) print cpu/cnt, mem/cnt; else print 0,0}' > /tmp/top_out_d &
            
            TOP_PID=$!

            if [ '$program' == 'A' ]; then
                EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramA $function $K 2>&1 >/dev/null)
            else
                EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramB $function $K 2>&1 >/dev/null)
            fi

            wait $TOP_PID
            read CPU_AVG MEM_AVG < /tmp/top_out_d

            read DREAD DWRITE DUTIL < <(
                iostat -dx 1 5 |
                awk 'NR>6 && $1!="Device:" {
                        r+=$6; w+=$7; u+=$14; cnt++
                     }
                     END {
                        if(cnt>0) print r/cnt, w/cnt, u/cnt;
                        else print 0,0,0
                     }'
            )

            echo "$program+$function,$K,$CPU_AVG,$MEM_AVG,$DREAD,$DWRITE,$DUTIL,$EXEC_TIME" >> $_CSV