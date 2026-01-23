#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


// Roll Number: MT25036 -> Last digit is 6
#define LOOP 6000

// Matrix Multiplication
void* cpu(){
    int N = 50;
    double a[N][N], b[N][N], res[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            a[i][j] = 2.5;
            b[i][j] = 3.8;
            res[i][j] = 0.0;
        }
    }

    for (int k = 0; k < LOOP; k++) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                res[i][j] = 0.0;
                for (int t = 0; t < N; t++) {
                    res[i][j] += a[i][t] * b[t][j];
                }
            }
        }
    }

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

// Writing into a txt file in big chunks - 65536 Bytes ~ 64KB
void* io(){
    int buffer_size = 65536; 
    char *buffer = malloc(buffer_size);

    for (int i = 0; i < buffer_size; i++){
        buffer[i] = 'R';
    }
        

    FILE *file = fopen("test.txt", "w");
    if (!file) return NULL;

    for (int k = 0; k < LOOP; k++) {
        fwrite(buffer, 1, buffer_size, file);
        fflush(file);
        fsync(fileno(file));
    }

    fclose(file);
    remove("test.txt");
    free(buffer);
    return NULL;
}