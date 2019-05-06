#include <stdio.h>
#include <stdlib.h>

void mult(int *h_a, int *h_b, int *h_c, int m) {
    int i;
	int j;
	int h;
	for (i = 0; i < m; ++i) 
    {
        for (j = 0; j < m; ++j) 
        {
            int tmp = 0.0;
            for ( h = 0; h < m; ++h) 
            {
                tmp += h_a[i * m + h] * h_b[h * m + j];
            }
            h_c[i * m+ j] = tmp;
        }
    }
}


int main(int argc, char* argv[]) {
	
	int m;
    printf("Ingresa el tamaño de la matrix cuadrada \n");
    scanf("%d", &m);
	

    int *h_a = (int *)malloc(sizeof(int)*m*m);
	int *h_b = (int *)malloc(sizeof(int)*m*m);
	int *h_c = (int *)malloc(sizeof(int)*m*m);
	
	int i, j;
    //initialize matrix A
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
            h_a[i * m + j] = 1; 
        }
    }

    //initialize matrix B
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
            h_b[i * m + j] = 2; 
        }
    }


    mult(h_a, h_b, h_c, m);   
    
	printf("\n Resultado \n");
	// print matrix
    for (i = 0; i < m; ++i) {
        for (j = 0; j < m; ++j) {
            printf("%d ", h_c[i * m + j] ); 
        }
		printf("\n");
    }

	return 0;
}