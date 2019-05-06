#include <stdio.h>
#include <stdlib.h>
#include <math.h>

__global__ 
void mult(int *d_a,int *d_b, int *d_c, int m)
{ 
    int row = blockIdx.y * blockDim.y + threadIdx.y; 
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int sum = 0;

    if( col < m && row < m) 
    {
        for(int i = 0; i < m; i++) 
        {
            sum += d_a[row * m + i] * d_b[i * m + col];
        }
        d_c[row * m + col] = sum;
    }
} 



int main(int argc, char* argv[]) {
	
	int m;
    printf("Ingresa el tamaño de la matrix cuadrada \n");
    scanf("%d", &m);
	 //int blockSize = 256;
	//int numBlocks = (N + blockSize - 1) / blockSize;
	
	// Allocate memory space on the device 
	  int *d_a, *d_b, *d_c;
	  // Allocate Unified Memory – accessible from CPU or GPU
	  cudaMallocManaged(&d_a, sizeof(int)*m*m);
	  cudaMallocManaged(&d_b, sizeof(int)*m*m); 
	  cudaMallocManaged(&d_c, sizeof(int)*m*m); 
		
	
	int i, j;
    //initialize matrix A
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
            d_a[i * m + j] = 1; 
        }
    }

    //initialize matrix B
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
            d_b[i * m + j] = 2; 
        }
    }
	
	// some events to count the execution time
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
	
    // start to count execution time of GPU version
    cudaEventRecord(start, 0);
	
	int N = m;
	dim3 threadsPerBlock(N, N);
    dim3 blocksPerGrid(1, 1);
        if (N*N > 512){
            threadsPerBlock.x = 512;
            threadsPerBlock.y = 512;
            blocksPerGrid.x = ceil(double(N)/double(threadsPerBlock.x));
            blocksPerGrid.y = ceil(double(N)/double(threadsPerBlock.y));
        }
		

    mult<<<blocksPerGrid,threadsPerBlock>>>(d_a, d_b, d_c, m);

    
     // Wait for GPU to finish before accessing on host
	cudaDeviceSynchronize();	

    // time counting terminate
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);

    // compute time elapse on GPU computing
    cudaEventElapsedTime(&gpu_elapsed_time_ms, start, stop);
    printf("Time elapsed on matrix multiplication of %dx%d . %dx%d on GPU: %f ms.\n\n", m, m, m, m, gpu_elapsed_time_ms);

	printf("\n Resultado \n");
	/* Check for errors (all values should be 3.0f) */ 
	int res = m*2;
	int maxError = 0;
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
			maxError = fmax(maxError, fabs( d_c[i * m + j]-res));
            printf("%d ", d_c[i * m + j] ); 
        }
		printf("\n");
    }
	
	  printf("Max error: %d \n", maxError);
	
	
	// free memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

	return 0;
}