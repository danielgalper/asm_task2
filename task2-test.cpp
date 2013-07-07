#include <iostream>
#include <cmath>
#include <time.h>  
#include <cstdio>
extern "C"
{

	void fdct(float* data, float* res, int n);
	void idct(float* data, float* res, int n);

}

const int N = 1000000;
const int SIZE = 8;

float cur[] = {-16342,   2084, -10049,  10117,   2786,   -659,  -4905,  12975,
	10579,   8081, -10678,  11762,   6898,    444,  -6422, -15892,
	-13388,  -4441, -11556, -10947,  16008,  -1779, -12481, -16230,
	-16091,  -4001,   1038,   2333,   3335,   3512, -10936,   5343,
	-1612,  -4845, -14514,   3529,   9284,   9916,    652,  -6489,
	12320,   7428,  14939,  13950,   1290, -11719,  -1242,  -8672,
	11870,  -9515,   9164,  11261,  16279,  16374,   3654,  -3524,
	-7660,  -6642,  11146, -15605,  -4067, -13348,   5807, -14541};

float res1[64 * N];
float res2[64 * N];
float data[64 * N];

int main () {
	clock_t t;
	int f;
	for (int i = 0; i < 64 * N; i++)
		data[i] = cur[i % (64)];
	t = clock();
	fdct(data, res1, N);
	idct(res1, res2, N);
	t = clock() - t;
	std::cout << t << " time" << std::endl;
	freopen("res.out","wt",stdout);
	/*for (int k = 0; k < N; k++) {
		std::cout << "matrix num" << std::endl; 
		for (int i = 0; i < SIZE; i++) {
			for (int j =0; j < SIZE; j++) {
				printf("%.2f ", res2[k * 64 + i * 8 + j]);
			}
			std::cout << std::endl;
		}
	}*/

}