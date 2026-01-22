#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>


void* cpu();
void* mem();
void* io();

void* thread_worker(void* arg){
    char* func = (char*)arg;

    if(strcmp(func, "cpu") == 0){
        cpu();
    }else if(strcmp(func, "mem") == 0){
        mem();
    }else if(strcmp(func, "io") == 0){
        io();
    }else{
        printf("Invalid function type\n");
        return NULL;
    }

    return NULL;
}

int main(int argc, char* argv[]){

    pthread_t threads[2];
    int K = atoi(argv[2]);

    for(int i = 0; i<K; i++){
        int th = pthread_create(&threads[i], NULL, thread_worker, argv[1]);
        if(th != 0){
            printf("Thread creation failed!");
            return -1;
        }
    }

    for(int i = 0; i < K; i++){
        pthread_join(threads[i], NULL);
    }



    return 0;
}