
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "tp2.h"
#include "tiempo.h"
#include "opencv_wrapper.h"
#include "utils.h"

DECLARAR_FILTRO(tiles)
DECLARAR_FILTRO(popart)
DECLARAR_FILTRO(ldr)
DECLARAR_FILTRO(temperature)

filtro_t filtros[] = {
	DEFINIR_FILTRO(tiles) ,
	DEFINIR_FILTRO(popart) ,
	DEFINIR_FILTRO(ldr) ,
	DEFINIR_FILTRO(temperature) ,
	{0,0,0,0}
};

void correr_filtro_video(configuracion_t *config, aplicador_fn_t aplicador);
void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador);
int cmpfunc (const void * a, const void * b);

int main( int argc, char** argv ) {

	configuracion_t config;
	unsigned long long int start, end, cuenta = 0;

	procesar_opciones(argc, argv, &config);
	// Imprimo info
	if (!config.nombre)
	{
		printf ( "Procesando...\n");
		printf ( "  Filtro             : %s\n", config.nombre_filtro);
		printf ( "  Implementación     : %s\n", C_ASM( (&config) ) );
		printf ( "  Archivo de entrada : %s\n", config.archivo_entrada);
		printf ( "  Cantidad de iter.  : %d\n", config.cant_iteraciones);
	}
	
	filtro_t *filtro = detectar_filtro(&config);

	filtro->leer_params(&config, argc, argv);

	
	if(config.cant_iteraciones < 1) config.cant_iteraciones = 1;

	unsigned long long int *v = malloc(config.cant_iteraciones*sizeof(unsigned long long int));
	
	if (config.es_video){
		for(unsigned int i = 0; i < config.cant_iteraciones; i++){
			MEDIR_TIEMPO_START(start);
			correr_filtro_video(&config, filtro->aplicador);
			MEDIR_TIEMPO_STOP(end);
			v[i] = end - start;
			cuenta = cuenta + v[i];
		}
	}else{
		for(unsigned int i = 0; i < config.cant_iteraciones; i++){
			MEDIR_TIEMPO_START(start);
			correr_filtro_imagen(&config, filtro->aplicador);
			MEDIR_TIEMPO_STOP(end);
			v[i] = end - start;
			cuenta = cuenta + v[i];
		}
	}
	
	qsort(v, config.cant_iteraciones, sizeof(unsigned long long int), cmpfunc);

	if (!config.nombre)
		imprimir_tiempos_ejecucion(cuenta, v[config.cant_iteraciones/2], config.cant_iteraciones);

	return 0;
}

filtro_t* detectar_filtro(configuracion_t *config)
{
	for (int i = 0; filtros[i].nombre != 0; i++)
	{
		if (strcmp(config->nombre_filtro, filtros[i].nombre) == 0)
			return &filtros[i];
	}

	perror("Filtro desconocido");
	return NULL; // avoid C warning
}

void correr_filtro_imagen(configuracion_t *config, aplicador_fn_t aplicador)
{
	snprintf(config->archivo_salida, sizeof(config->archivo_salida), "%s/%s.%s.%s%s.bmp",
                 config->carpeta_salida, basename(config->archivo_entrada), 
                 config->nombre_filtro, C_ASM(config), config->extra_archivo_salida );
	
	if (config->nombre)
	{
		printf("%s\n", basename(config->archivo_salida));
	}
	else
	{
		opencv_abrir_imagenes(config);
		aplicador(config);
		opencv_liberar_imagenes(config);
	}
}

void correr_filtro_video(configuracion_t *config, aplicador_fn_t aplicador)
{
    if (!config->frames) {
        snprintf(config->archivo_salida, sizeof(config->archivo_salida), "%s/%s.%s.%s%s.avi",
                 config->carpeta_salida, basename(config->archivo_entrada),
                 config->nombre_filtro, C_ASM(config), config->extra_archivo_salida );
	}
	
	if (config->nombre)
	{
		printf("%s\n", basename(config->archivo_salida));
	}
	else
	{
		opencv_abrir_video(config);
		opencv_frames_do(config, aplicador);
		opencv_liberar_video(config);
	}
}



void imprimir_tiempos_ejecucion(unsigned long long int cuenta, unsigned long long int min, int cant_iteraciones) {

	printf("Tiempo de ejecución:\n");
	//printf("  Comienzo                          : %llu\n", start);
	//printf("  Fin                               : %llu\n", end);
	printf("  # iteraciones                                : %d\n", cant_iteraciones);
	printf("  # de ciclos insumidos totales                : %llu\n", cuenta);
	printf("  # de ciclos insumidos por llamada mediana    : %llu\n", min);
}



int cmpfunc (const void * a, const void * b){
   return ( *(int*)a - *(int*)b );
}
