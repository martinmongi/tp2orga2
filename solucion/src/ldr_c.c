
#include "tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )

#define P 2



void ldr_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size,
	int alfa)
{	
	int max = 5*5*255*3*255;
    
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
	
    for (int i = 0; i < filas; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            rgb_t *p_d = (rgb_t*) &dst_matrix[i][j * 3];
            rgb_t *p_s = (rgb_t*) &src_matrix[i][j * 3];
		
				if(i < 2 || j < 2 || i + 2 >= filas || j + 2 >= cols){
					*p_d = *p_s;
				}else{ 
				int sumargb = 0;
				 for(int is = -2; is <= 2; is++){
					 for(int js = -6; js <= 6; js+=3){
						 rgb_t *pixelActual = ((rgb_t*)&src_matrix[i + is][j * 3 + js]);
						 sumargb = sumargb + (*pixelActual).r +(*pixelActual).g +(*pixelActual).b;
						 }
					 }
				
			int varb = ((*p_s).b * alfa * sumargb);
			varb = varb/max;
			int varg = ((*p_s).g * alfa * sumargb);
			varg = varg/max;
			int varr = ((*p_s).r * alfa * sumargb);	
			varr = varr/max;
			(*p_d).b = MIN(MAX((*p_s).b + varb, 0), 255);
			(*p_d).g = MIN(MAX((*p_s).g + varg, 0), 255);
			(*p_d).r = MIN(MAX((*p_s).r + varr, 0), 255);
			}
        }
    }
}
