
#include <math.h>
#include "tp2.h"


bool between(unsigned int val, unsigned int a, unsigned int b)
{
	return a <= val && val <= b;
}


void temperature_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i_d = 0, i_s = 0; i_d < filas; i_d++, i_s++) {
		for (int j_d = 0, j_s = 0; j_d < cols; j_d++, j_s++) {
			rgb_t *p_d = (rgb_t*)&dst_matrix[i_d][j_d*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i_s][j_s*3];
			int temp = ((*p_s).g + (*p_s).b + (*p_s).r)/3;
			if( temp < 32){
					(*p_d).r = 0;
					(*p_d).g = 0;
					(*p_d).b = 128 + 4*temp;
							 
				}else{
						if(32<= temp && temp < 96){
							(*p_d).r = 0;
							(*p_d).g = (temp-32)*4;
							(*p_d).b = 255;
							
							}else{
								if(96 <= temp && temp < 160){
									(*p_d).r = (temp -96)*4;
									(*p_d).g = 255;
									(*p_d).b = 255 - (temp-96)*4;
							
									}else{
										if(160 <= temp && temp < 224){
											(*p_d).r = 255;
											(*p_d).g = 255 - (temp -160)*4;
											(*p_d).b = 0;
							
											} else{
												(*p_d).r = 255 - (temp-224)*4;
												(*p_d).g = 0;
												(*p_d).b = 0;
							 
												
												}
										}
								
								}
					
					}
		}
	}
}
