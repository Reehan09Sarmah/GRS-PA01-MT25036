# Graduate Systems (CSE638) - PA01: Processes and Threads

**Name:** Reehan Sarmah
**Roll Number:** MT25036  
**Assignment:** PA01 - Processes and Threads Comparison  
**Deadline:** January 23, 2026
**Guide:** Dr. Rinku Shah (Assistant Professor (CSE), IIIT Delhi)

---

## What This Project Does

This project compares how processes and threads perform when running different types of tasks:
- **CPU-intensive tasks** (mathematical calculations)
- **Memory-intensive tasks** (large data processing)
- **I/O-intensive tasks** (file writing)

We measure and compare the performance of both approaches to understand their strengths and weaknesses.

---

## File Organization

All files are in a single folder: `GRS_PA01/`

```
GRS_PA01/
├── README.md                                              # This file - start here!
├── Makefile                                               # Instructions for building the program
├── MT25036_Part_A_Program_A.c                             # Process-based program (uses fork)
├── MT25036_Part_A_Program_B.c                             # Thread-based program (uses pthread)
├── MT25036_Part_B_Workers.c                               # The work tasks (cpu, mem, io)
├── MT25036_Part_C_shell.sh                                # Script to test with 2 workers
├── MT25036_Part_C_Plot.py                                 # Makes graphs for Part C
├── MT25036_Part_C_CSV.csv                                 # Results data for Part C
├── MT25036_Part_C_CPU_percentage_comparison.png           # CPU comparison graph for Part C
├── MT25036_Part_C_mem_percentage_comparison.png           # Memory comparison graph for Part C
├── MT25036_Part_C_disk_percentage_comparison.png          # Disk comparison graph for Part C
├── MT25036_Part_C_exec_time_vs_program.png                # Execution time graph for Part C
├── MT25036_Part_D_shell.sh                                # Script to test with many workers
├── MT25036_Part_D_Plot.py                                 # Makes graphs for Part D
├── MT25036_Part_D_CSV.csv                                 # Results data for Part D
├── MT25036_Part_D_execution_time_cpu.png                  # CPU execution time scaling graph
├── MT25036_Part_D_execution_time_mem.png                  # Memory execution time scaling graph
├── MT25036_Part_D_execution_time_io.png                   # I/O execution time scaling graph
├── MT25036_Part_D_cpu_percentage.png                      # CPU utilization scaling graph
├── MT25036_Part_D_disk_percentage_io.png                  # Disk utilization scaling graph
├── MT25036_Part_D_mem_util_cpu.png                        # Memory utilization for CPU task
├── MT25036_Part_D_mem_util_mem.png                        # Memory utilization for memory task
├── MT25036_Part_D_mem_util_io.png                         # Memory utilization for I/O task
└── MT25036_Report.pdf                                     # Detailed analysis and conclusions
```

---

## Quick Start Guide

### Step 1: Compile the Programs

```bash
make
```

This creates two executable programs:
- `ProgramA` - uses processes
- `ProgramB` - uses threads

### Step 2: Run a Program

**For Program A (Process-based):**
```bash
./ProgramA cpu 2      # Run CPU task with 2 processes
./ProgramA mem 2      # Run memory task with 2 processes
./ProgramA io 2       # Run I/O task with 2 processes
```

**For Program B (Thread-based):**
```bash
./ProgramB cpu 2      # Run CPU task with 2 threads
./ProgramB mem 2      # Run memory task with 2 threads
./ProgramB io 2       # Run I/O task with 2 threads
```

That's it! The program will run and show you the results.

### Step 3: Clean Up

To remove the compiled programs:
```bash
make clean
```

---

## Understanding the Programs

### Program A: Using Processes (fork)

This program creates separate processes:
- Each process gets its own memory
- Processes run independently
- More overhead, but better isolation

### Program B: Using Threads (pthread)

This program creates threads within a single process:
- Threads share memory
- Faster to create and switch between
- Less memory overhead

### The Three Work Tasks

**cpu**: Does math calculations (matrix multiplication)
- Tests how well each approach handles pure computation

**mem**: Modifies a large block of memory repeatedly
- Tests memory bandwidth and cache behavior

**io**: Writes data to a file on disk
- Tests how well each approach handles waiting for I/O

---

## The Two Test Scenarios

### Part C: Baseline Test (Fixed 2 Workers)

Compares process vs thread behavior with exactly 2 workers running the same task.

**Run all tests automatically:**
```bash
bash MT25036_Part_C_shell.sh
```

This creates `MT25036_Part_C_CSV.csv` with measurements and generates graphs.

**Create the graphs:**
```bash
python3 MT25036_Part_C_Plot.py
```

### Part D: Scalability Test (Variable Worker Count)

Tests what happens as you increase the number of workers:
- Program A: Tests 2, 3, 4, 5 processes
- Program B: Tests 2, 3, 4, 5, 6, 7, 8 threads

**Run all tests automatically:**
```bash
bash MT25036_Part_D_shell.sh
```

This creates `MT25036_Part_D_CSV.csv` with measurements and generates graphs.

**Create the graphs:**
```bash
python3 MT25036_Part_D_Plot.py
```

---

## What Gets Measured

Both test scripts measure these metrics:

- **CPU%**: How much processor the program uses
- **MEM%**: How much memory the program uses
- **Disk_Util%**: How busy the disk is
- **Exec_Time_sec**: How long the program takes to finish

The data is saved in CSV files, and graphs are automatically created.

---

## Output Files

### Generated CSV Files

**MT25036_Part_C_CSV.csv** - Results from Part C
```
Program+Function,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec
A+cpu,48.6817,5.90273,0.113448,7.5069,0.0782759,4.74
A+mem,46.6974,5.69952,0.0789655,6.1969,0.0651724,27.19
...
```

**MT25036_Part_D_CSV.csv** - Results from Part D
```
Program+Function,num_workers,CPU%,MEM%,Disk_Read_kBps,Disk_Write_kBps,Disk_Util%,Exec_Time_sec
A+cpu,2,48.8027,4.91776,0.0796552,6.4431,0.052069,4.64
A+cpu,3,47.7907,4.79126,0.0796552,6.4431,0.0382759,7.19
...
```

### Generated Graphs

The Python scripts create PNG images that visualize the data:
- Bar charts comparing Process vs Thread performance
- Line graphs showing how performance changes with more workers
- Separate graphs for CPU, memory, and disk metrics

---

## File Descriptions

### Source Code Files

**MT25036_Part_A_Program_A.c**
- Creates K child processes using `fork()`
- Each process runs one of the work tasks
- Parent waits for all children to finish

**MT25036_Part_A_Program_B.c**
- Creates K threads using `pthread_create()`
- All threads run the same work task
- Main thread waits for all child threads to finish

**MT25036_Part_B_Workers.c**
- Contains the three work functions: `cpu()`, `mem()`, `io()`
- Each function performs 6000 iterations of its task
- Loop count based on roll number (MT25036: 6 × 1000 = 6000)

### Script Files

**MT25036_Part_C_shell.sh**
- Automatically runs all 6 combinations (A+cpu, A+mem, A+io, B+cpu, B+mem, B+io)
- Each test uses exactly 2 workers
- Measures CPU%, memory, disk usage, and execution time
- Saves results to `MT25036_Part_C_CSV.csv`

**MT25036_Part_D_shell.sh**
- Similar to Part C, but tests with varying worker counts
- Program A: 2, 3, 4, 5 processes
- Program B: 2, 3, 4, 5, 6, 7, 8 threads
- Saves results to `MT25036_Part_D_CSV.csv`

### Plotting Files

**MT25036_Part_C_Plot.py**
- Reads `MT25036_Part_C_CSV.csv`
- Creates comparison graphs for Part C

**MT25036_Part_D_Plot.py**
- Reads `MT25036_Part_D_CSV.csv`
- Creates trend graphs for Part D

---

## Important Details

### Roll Number Calculation
- Roll number: MT25036
- Last digit: 6
- Loop iterations: 6 × 1000 = 6000

### CPU Pinning
- The test scripts use `taskset` to restrict programs to a single CPU core
- This ensures consistent and fair measurements
- Results are more reliable and reproducible

### Temporary Files
- The I/O task creates a temporary file called `test.txt`
- This file is automatically deleted after the test completes
- You don't need to manually clean it up

---

## Troubleshooting

### "Command not found" when running make
Make sure you're in the same directory as the Makefile.

### Compilation fails
Make sure you have GCC and pthread development libraries installed:
```bash
sudo apt-get install build-essential    # On Ubuntu/Debian
```

### "Permission denied" when running bash scripts
Make the scripts executable first:
```bash
chmod +x MT25036_Part_C_shell.sh
chmod +x MT25036_Part_D_shell.sh
```

### CSV files not created
The scripts may need to be run with elevated privileges for accurate measurements. Try:
```bash
sudo bash MT25036_Part_C_shell.sh
```

### Graphs not generated
Create a python environment first
```bash
python3 -m venv .venv
```
---
Make sure Python 3 is installed with pandas and matplotlib.
```bash
pip install pandas matplotlib
```

---

## How to Read the Results

### Part C Analysis
Look at the graphs to compare how Process (Program A) and Thread (Program B) perform:
- Which one uses less CPU?
- Which one finishes faster?
- Which one uses more memory?

### Part D Analysis
Look at the trend graphs to see what happens as you add more workers:
- Does execution time decrease?
- At what point does adding more workers stop helping?
- How do CPU and memory change?

For detailed analysis and conclusions, see **MT25036_Report.pdf**.

---

## What You Need

- A Linux computer (for fork and pthread support)
- GCC compiler
- Python 3 with pandas and matplotlib (for graphing)
- Basic command-line knowledge

---

## Next Steps

1. Read this file completely
2. Run `make` to compile
3. Run `./ProgramA cpu 2` or `./ProgramB cpu 2` to test manually
4. Run the bash scripts for automated testing
5. Run the Python scripts to see the graphs
6. Read the detailed report: **MT25036_Report.pdf**

---

**For detailed analysis and findings, please refer to MT25036_Report.pdf**
