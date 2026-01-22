#!/bin/bash

_CSV="MT25036_Part_C_CSV.csv"
_CORE=1

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")


echo "Program,Function,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do
  for function in "${FUNCTIONS[@]}"; do

    echo "Running $program + $function"

    
    START_TIME=$(date +%s.%N)

    if [ "$program" == "A" ]; then
        taskset -c $_CORE ./out/ProgramA $function &
    else
        taskset -c $_CORE ./out/ProgramB $function &
    fi

    PROG_PID=$!

  
    read CPU_AVG MEM_AVG < <(
        top -b -d 1 -n 5 -p $PROG_PID |
        awk 'NR>7 { cpu+=$9; mem+=$10; cnt++ }
             END { if(cnt>0) print cpu/cnt, mem/cnt; else print 0,0 }'
    )


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

    
    wait $PROG_PID

    END_TIME=$(date +%s.%N)
    EXEC_TIME=$(echo "$END_TIME - $START_TIME" | bc)

   
    echo "$program,$function,$CPU_AVG,$MEM_AVG,$DREAD,$DWRITE,$DUTIL,$EXEC_TIME" >> $_CSV

  done
done
