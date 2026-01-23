CC = gcc
CFLAGS = -Wall -pthread
COMMON_SRC = src/MT25036_Part_B_Workers.c

all: ProgramA ProgramB

ProgramA: src/MT25036_Part_A_Program_A.c $(COMMON_SRC)
	$(CC) $(CFLAGS) src/MT25036_Part_A_Program_A.c src/MT25036_Part_B_Workers.c -o out/ProgramA

ProgramB: src/MT25036_Part_A_Program_B.c $(COMMON_SRC)
	$(CC) $(CFLAGS) src/MT25036_Part_A_Program_B.c src/MT25036_Part_B_Workers.c -o out/ProgramB

clean:
	rm -f out/ProgramA out/ProgramB

