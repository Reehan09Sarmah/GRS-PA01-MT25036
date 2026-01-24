CC = gcc
CFLAGS = -Wall -pthread
COMMON_SRC = MT25036_Part_B_Workers.c

all: ProgramA ProgramB

ProgramA: MT25036_Part_A_Program_A.c $(COMMON_SRC)
	$(CC) $(CFLAGS) MT25036_Part_A_Program_A.c MT25036_Part_B_Workers.c -o ProgramA

ProgramB: MT25036_Part_A_Program_B.c $(COMMON_SRC)
	$(CC) $(CFLAGS) MT25036_Part_A_Program_B.c MT25036_Part_B_Workers.c -o ProgramB

clean:
	rm -f ProgramA ProgramB

