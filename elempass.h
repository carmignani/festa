/* Header file for the element pass-functions */

#ifndef NOMEX
#if defined(PCWIN)
#define ExportMode __declspec(dllexport)
#include <float.h>
#elif defined(GLNX86)
#define ExportMode
#elif defined(GLNXA64)
#define ExportMode
#elif defined(ALPHA)
#define ExportMode
#elif defined(SOL2)
#define ExportMode
#elif defined(SOL64)
#define ExportMode
#elif defined(MAC)
#define ExportMode
#elif defined(MACI)
#define ExportMode
#elif defined(MACI64)
#define ExportMode
#else 
/* Default - Windows */
#define ExportMode __declspec(dllexport)
#endif

struct parameters
{
	int mode;
	int nturn;
	double RingLength;
	double T0;
};

ExportMode int* passFunction(const mxArray *ElemData, int *FieldNumbers,
				double *r_in, int num_particles, int mode);
ExportMode int* trackFunction(const mxArray *ElemData, int *FieldNumbers,
				double *r_in, int num_particles, struct parameters *Param);

#define NO_LOCAL_COPY 		0	/* function retieves element data from MATLAB workspace
								   each time it is called and reterns NULL pointer
								*/

#define MAKE_LOCAL_COPY 	1 	/* function retieves element data from MATLAB workspace
								   allocates memory and makes a persistent local copy
								   of the fields it uses for use on subsequent calls. 
								   Returns a pointer to that structure
                                */

#define USE_LOCAL_COPY		2  /*  Uses the previously stored local copy of the element data */

#endif


