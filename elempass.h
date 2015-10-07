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
	
ExportMode int* passFunction(const mxArray *ElemData, int *FieldNumbers,
				double *r_in, int num_particles, int mode);


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

void getT0andTurnFromMatlab(double *T0, double *nturn)
/*
 *	This function gets the values of T0 and Turn number created in ringpass 
 *	or linepass and stored in the matlab global variables T0 and xturn.
 */
{
	mxArray *mxT0, *mxnturn;
	mxT0 = mexGetVariable("global", "T0");
	mxnturn = mexGetVariable("global", "xturn");
/*	printf("mxturn = %p \n", mxnturn);*/
	if(mxT0!=NULL)
		*T0=mxGetScalar(mxT0);
	else
		*T0=0.0;
	if(mxnturn!=NULL)
		*nturn=mxGetScalar(mxnturn);
	else
		*nturn=0.0;
}

double getTurnFromMatlab()
/*
 *	This function gets the turn number stored in the matlab global variable xturn
 *
 */
{
	double nturn;
	mxArray *mxnturn;
	mxnturn = mexGetVariable("global", "xturn");
	if(mxnturn!=NULL)
		nturn=mxGetScalar(mxnturn);
	else
		nturn=0.0;
	return nturn;
}

