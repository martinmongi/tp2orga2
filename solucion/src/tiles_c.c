#include "tp2.h"
#include "tiempo.h"
#include "stdio.h"

void tiles_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols, 
	int filas,
	int src_row_size,
	int dst_row_size,
	int tamx,
	int tamy,
	int offsetx,
	int offsety)
{

	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
	
	for (int i_d = 0, i_s = offsety; i_d < filas; i_d++, i_s++) {

		if (i_s == offsety + tamy){
			i_s = offsety;
		}
		
		for (int j_d = 0, j_s = offsetx; j_d < cols; j_d++, j_s++) {

			if (j_s == offsetx + tamx){
				j_s = offsetx;
			}
			
			rgb_t *p_d = (rgb_t*)&dst_matrix[i_d][j_d*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i_s][j_s*3];
			*p_d = *p_s;
		}
	}

}