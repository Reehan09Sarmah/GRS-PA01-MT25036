import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("MT25036_Part_D_CSV.csv")

df[['Program', 'Function']] = df['Program+Function'].str.split('+', expand=True)

functions = ['cpu', 'mem', 'io']

for func in functions:
    plt.figure()
    
    for prog in ['A', 'B']:
        subset = df[(df['Function'] == func) & (df['Program'] == prog)]
        plt.plot(subset['num_workers'], subset['Exec_Time_sec'], marker='o', label=f'Program {prog}')
    
    plt.xlabel("Number of Workers")
    plt.ylabel("Execution Time (sec)")
    plt.title(f"Execution Time vs Workers ({func.upper()})")
    plt.legend()
    plt.grid(True)
    
    plt.savefig(f"MT25036_Part_D_execution_time_{func}.png")
    plt.close()


plt.figure()

for prog in ['A', 'B']:
    subset = df[(df['Function'] == 'cpu') & (df['Program'] == prog)]
    plt.plot(subset['num_workers'], subset['CPU%'], marker='o', label=f'Program {prog}')

plt.xlabel("Number of Workers")
plt.ylabel("CPU Utilization (%)")
plt.title("CPU% vs Workers (CPU)")
plt.legend()
plt.grid(True)

plt.savefig("MT25036_Part_D_cpu_percentage.png")
plt.close()


plt.figure()

for prog in ['A', 'B']:
    subset = df[(df['Function'] == 'io') & (df['Program'] == prog)]
    plt.plot(subset['num_workers'], subset['Disk_Util%'], marker='o', label=f'Program {prog}')

plt.xlabel("Number of Workers")
plt.ylabel("Disk Utilization (%)")
plt.title("Disk% vs Workers (IO)")
plt.legend()
plt.grid(True)

plt.savefig("MT25036_Part_D_disk_percentage_io.png")
plt.close()


for func in functions:
    plt.figure()

    for prog in ['A', 'B']:
        subset = df[(df['Function'] == func) & (df['Program'] == prog)]
        plt.plot(subset['num_workers'], subset['MEM%'],
                 marker='o', label=f'Program {prog}')

    plt.xlabel("Number of Workers")
    plt.ylabel("Memory Usage (%)")
    plt.title(f"Mem% vs Workers ({func.upper()})")
    plt.legend()
    plt.grid(True)

    plt.savefig(f"MT25036_Part_D_mem_util_{func}.png")
    plt.close()
