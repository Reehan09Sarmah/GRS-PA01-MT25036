#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>

void* cpu();
void* mem();
void* io();

int main(int argc, char* argv[]){

    if (argc != 2) {
        printf("No arguments passed! (for eg: cpu, mem, io)");
        return -1;
    }

    for(int i = 0; i<2; i++){
        pid_t pid = fork();

        if(pid == 0){
            if(strcmp(argv[1], "cpu") == 0){
                cpu();
            }else if(strcmp(argv[1], "mem") == 0){
                mem();
            }else if(strcmp(argv[1], "io") == 0){
                io();
            }else{
                printf("Invalid function type\n");
                return -1;
            }

            exit(0);
        }
    }

    for(int i = 0; i<2; i++){
        wait(NULL);
    }

    return 0;
}