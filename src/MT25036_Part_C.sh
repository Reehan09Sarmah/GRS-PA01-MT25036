#!/bin/bash

_CSV="./data/MT25036_Part_C_CSV.csv"
_CORE=1

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")

echo "Program+Function,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do
  for function in "${FUNCTIONS[@]}"; do

    echo "Running $program + $function, number of workers = 2"

    top -b -d 1 -n 5 | grep "Program$program" |
    awk '{cpu+=$9; mem+=$10; cnt++}
         END {if(cnt>0) print cpu/cnt, mem/cnt; else print 0,0}' > /tmp/top_out &

    TOP_PID=$!

    if [ "$program" == "A" ]; then
        EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramA $function 2 2>&1 >/dev/null)
    else
        EXEC_TIME=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramB $function 2 2>&1 >/dev/null)
    fi

    wait $TOP_PID

    read CPU_AVG MEM_AVG < /tmp/top_out

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

    echo "$program+$function,$CPU_AVG,$MEM_AVG,$DREAD,$DWRITE,$DUTIL,$EXEC_TIME" >> $_CSV

  done
done
