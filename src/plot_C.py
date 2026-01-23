import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


df = pd.read_csv("./data/MT25036_Part_C_CSV.csv")


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
plt.xlabel("Workload")
plt.ylabel("CPU Utilization (%)")
plt.title("CPU Utilization Comparison (Part C, 2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("./plots/Part-C/cpu_util_comparison.png")
plt.close()


plt.figure()

mem_A = df[df['Program'] == 'A']['MEM%'].values
mem_B = df[df['Program'] == 'B']['MEM%'].values

plt.bar(x - width/2, mem_A, width, label='Program A')
plt.bar(x + width/2, mem_B, width, label='Program B')

plt.xticks(x, functions)
plt.xlabel("Workload")
plt.ylabel("Memory Usage (%)")
plt.title("Memory Utilization Comparison (Part C, 2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("./plots/Part-C/mem_util_comparison.png")
plt.close()


plt.figure()

disk_A = df[df['Program'] == 'A']['Disk_Util%'].values
disk_B = df[df['Program'] == 'B']['Disk_Util%'].values

plt.bar(x - width/2, disk_A, width, label='Program A')
plt.bar(x + width/2, disk_B, width, label='Program B')

plt.xticks(x, functions)
plt.xlabel("Workload")
plt.ylabel("Disk Utilization (%)")
plt.title("Disk Utilization Comparison (Part C, 2 Workers)")
plt.legend()
plt.grid(axis='y')

plt.savefig("./plots/Part-C/disk_util_comparison.png")
plt.close()
