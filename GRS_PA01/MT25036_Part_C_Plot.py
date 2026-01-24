import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


df = pd.read_csv("MT25036_Part_C_CSV.csv")


df[['Program', 'Function']] = df['Program+Function'].str.split('+', expand=True)

functions = ['cpu', 'mem', 'io']
x = np.arange(len(functions))
width = 0.35

plt.figure()

cpu_A = df[df['Program'] == 'A']['CPU%'].values
cpu_B = df[df['Program'] == 'B']['CPU%'].values

plt.bar(x - width/2, cpu_A, width, label='Program A')
plt.bar(x + width/2, cpu_B, width, label='Program B')

plt.xticks(x, functions)
plt.xlabel("Functions")
plt.ylabel("CPU Utilization (%)")
plt.title("CPU% Comparison (2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("MT25036_Part_C_CPU_percentage_comparison.png")
plt.close()


plt.figure()

mem_A = df[df['Program'] == 'A']['MEM%'].values
mem_B = df[df['Program'] == 'B']['MEM%'].values

plt.bar(x - width/2, mem_A, width, label='Program A')
plt.bar(x + width/2, mem_B, width, label='Program B')

plt.xticks(x, functions)
plt.xlabel("Functions")
plt.ylabel("Memory Usage (%)")
plt.title("Mem% Comparison (2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("MT25036_Part_C_mem_percentage_comparison.png")
plt.close()


plt.figure()

disk_A = df[df['Program'] == 'A']['Disk_Util%'].values
disk_B = df[df['Program'] == 'B']['Disk_Util%'].values

plt.bar(x - width/2, disk_A, width, label='Program A')
plt.bar(x + width/2, disk_B, width, label='Program B')

plt.xticks(x, functions)
plt.xlabel("Functions")
plt.ylabel("Disk Utilization (%)")
plt.title("Disk% Comparison (2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("MT25036_Part_C_disk_percentage_comparison.png")
plt.close()

programs = ['A', 'B']

for func in ['cpu', 'mem', 'io']:
    times = []
    for prog in programs:
        val = df[(df['Program'] == prog) & (df['Function'] == func)]['Exec_Time_sec'].values
        times.append(val[0] if len(val) > 0 else 0)

    plt.plot(programs, times, marker='o', label=func.upper())

plt.xlabel("Program")
plt.ylabel("Execution Time (sec)")
plt.title("Execution Time vs Program (Part C)")
plt.legend()
plt.grid(True)

# Save plot
plt.savefig("MT25036_Part_C_exec_time_vs_program.png")
plt.close()
