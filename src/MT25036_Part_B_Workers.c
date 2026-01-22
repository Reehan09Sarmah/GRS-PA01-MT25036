#include <stdio.h>
#include <stdlib.h>


// Roll Number: MT25036 -> Last digit is 6
#define LOOP 6000

// Matrix Multiplication
void* cpu(){
    int N = 50;
    double a[N][N], b[N][N], res[N][N];

    for(int i = 0; i< N; i++){
        for(int j = 0; j<N; j++){
            a[i][j] = 2.5;
            b[i][j] = 3.8;
            res[i][j] = 0.0;
        }
    }

    for(int i = 0; i < LOOP; i++){
        for(int x = 0; x<N; x++){
            for(int y = 0; y<N; y++){
                res[x][y] = 0.0;
                for(int z = 0; z<N; z++){
                    res[x][y] += a[x][z] * b[z][y];
                }
            }
        }
    }

    return NULL;
}

// Dynamic Allocation + Accessing memory place many times
void* mem(){
    size_t length = 1024 * 360;
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

// Writing into a file in big chunks - 65536 Bytes ~ 64KB
void* io(){
    int buffer_size = 65536;
    char buffer[buffer_size];
    for(int i = 0; i < buffer_size; i++){
        buffer[i] = 'R';
    }

    for(int j = 0; j < LOOP; j++){
        FILE *fp = fopen("test.bin", "wb");
        if(fp == NULL){
            printf("Could not open file!");
            return NULL;
        }

        fwrite(buffer, sizeof(char), buffer_size, fp);
        fclose(fp);
    }

    remove("test.bin");
    return NULL;
}