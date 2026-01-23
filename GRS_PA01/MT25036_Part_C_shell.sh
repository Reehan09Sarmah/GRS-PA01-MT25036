#!/bin/bash

_CSV="MT25036_Part_C_CSV.csv"
_CORE=1

PROGS=("A" "B")
FUNCTIONS=("cpu" "mem" "io")

echo "Program+Function,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec" > $_CSV

for program in "${PROGS[@]}"; do
  for function in "${FUNCTIONS[@]}"; do

    echo "Running $program + $function, number of workers = 2"

    top -b -d 1 -n 6 > top.txt &
    TOP_PID=$!
    
    iostat -dx 1 6 > io.txt &
    IO_PID=$!

    if [ "$program" = "A" ]; then
      TIME_VAL=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramA $function 2 2>&1)
    else
      TIME_VAL=$(/usr/bin/time -f "%e" taskset -c $_CORE ./out/ProgramB $function 2 2>&1)
    fi

   
    wait $TOP_PID $IO_PID

    
    CPU=$(awk 'NR>7 && NF {sum+=$9; c++} END {if(c>0) print sum/c; else print 0}' top.txt)
    MEM=$(awk 'NR>7 && NF {sum+=$10; c++} END {if(c>0) print sum/c; else print 0}' top.txt)

    DREAD=$(awk 'NR>3 && NF {r+=$6; c++} END {if(c>0) print r/c; else print 0}' io.txt)
    DWRITE=$(awk 'NR>3 && NF {w+=$7; c++} END {if(c>0) print w/c; else print 0}' io.txt)
    DUTIL=$(awk 'NR>3 && NF {u+=$NF; c++} END {if(c>0) print u/c; else print 0}' io.txt)

    echo "$program+$function,$CPU,$MEM,$DREAD,$DWRITE,$DUTIL,$TIME_VAL" >> $_CSV

  done
done

rm -f top.txt io.txt