#include <stdio.h>
#include <stdlib.h>


// Roll Number: MT25036 -> Last digit is 6
#define LOOP 6000

// Matrix Multiplication
void* cpu(){
    int N = 100;
    int size = N * N;

    double *a   = (double *)malloc(N * N * sizeof(double));
    double *b   = (double *)malloc(N * N * sizeof(double));
    double *res = (double *)malloc(N * N * sizeof(double));

    if (a == NULL || b == NULL || res == NULL) {
        printf("Memory not allocated!\n");
        return NULL;
    }

      for (int i = 0; i < size; i++) {
        a[i] = 2.5;
        b[i] = 3.8;
        res[i] = 0.0;
    }

    for (int k = 0; k < LOOP; k++) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                double sum = 0.0;
                for (int t = 0; t < N; t++) {
                    sum += a[i*N + t] * b[t*N + j];
                }
                res[i*N + j] = sum;
            }
        }
    }


    free(a);
    free(b);
    free(res);

    return NULL;
}

// Dynamic Allocation + Accessing memory place many times
void* mem(){
    size_t length = 1024 * 1024;
    int* buffer = (int *)malloc(length * sizeof(int));

    if(buffer == NULL){
        printf("Allocation failed!");
        return NULL;
    }

    for(size_t i = 0; i<length; i++){
        buffer[i] = i+1;
    }

    for(int i = 0; i < LOOP; i++){
        for(size_t j = 0; j < length; j++){
            buffer[j] += 5;
        }
    }

    free(buffer);
    return NULL;
}

// Writing into a txt file in big chunks - 16384 Bytes ~ 16KB
void* io(){
    int buffer_size = 16384;
    char *buffer = (char *)malloc(buffer_size * sizeof(char));
    if(buffer == NULL){
        printf("Memory Allocation Failed!");
        return NULL;
    }

    for(int i = 0; i < buffer_size; i++){
        buffer[i] = 'R';
    }

    for(int j = 0; j < LOOP; j++){
        FILE *fp = fopen("test.txt", "w");
        if(fp == NULL){
            printf("Could not open file!");
            free(buffer);
            return NULL;
        }

        fprintf(fp, "%s ", buffer);
        fclose(fp);
    }

    remove("test.txt");
    free(buffer);
    return NULL;
}