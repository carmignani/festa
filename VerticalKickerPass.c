/* VerticalKickerPass.c
   Accelerator Toolbox 
   7/10/15
   This pass method is for the spin depolarization simulations, 
   but it can be used for different simulations.
   Nicola Carmignani
*/

#include "mex.h"
#include "elempass.h"
#include <math.h>
#define TWOPI  6.28318530717959
#define C0  	2.99792458e8 


void KickerPass(double *r_in, double ampl, double freq, double phase, int num_particles)
/* amp - amplitude of vertical kick in rad
   freq - frequency in units of revolution freq
   r is a 6-by-N matrix of initial conditions reshaped into 
   1-d array of 6*N elements 
 *
 *note that time variable is not currently taken into account
 *this is a problem for very high frequency kickers
*/
{	
  	double turn;
  	double kick;
  	int c, c6;
  	turn=getTurnFromMatlab(); /* this function is in elempass.h */
  	for(c = 0;c<num_particles;c++)
    {
      	c6 = c*6;
      	if(!mxIsNaN(r_in[c6]))
			r_in[c6+3] += ampl*cos(TWOPI*freq*turn+phase);
    }
}

#ifndef NOMEX

ExportMode int* passFunction(const mxArray *ElemData,int *FieldNumbers,
			     double *r_in, int num_particles, int mode)
#define NUM_FIELDS_2_REMEMBER 5  
{
  double ampl, freq, phase;
  int *returnptr;
  int *NewFieldNumbers, fnum;
  switch(mode)
    {	
    case NO_LOCAL_COPY:	/* Obsolete in AT1.3  */
      {
	
      }	break;
      
    case MAKE_LOCAL_COPY: 	/* Find field numbers first 
				   Save a list of field number in an array
				   and make returnptr point to that array
				*/
      {	
	NewFieldNumbers = (int*)mxCalloc(NUM_FIELDS_2_REMEMBER,sizeof(int));
	
	fnum = mxGetFieldNumber(ElemData,"Frequency");
	if(fnum<0) 
	  mexErrMsgTxt("Required field 'Frequency' was not found in the element data structure"); 
	NewFieldNumbers[0] = fnum;
	
	fnum = mxGetFieldNumber(ElemData,"Amplitude");
	if(fnum<0) 
	  mexErrMsgTxt("Required field 'Amplitude' was not found in the element data structure"); 
	NewFieldNumbers[1] = fnum;
	
	fnum = mxGetFieldNumber(ElemData,"Phase");
	if(fnum<0) 
	  mexErrMsgTxt("Required field 'Phase' was not found in the element data structure"); 
	NewFieldNumbers[2] = fnum;
	
	freq = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[0]));
	ampl = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[1]));
	phase = mxGetScalar(mxGetFieldByNumber(ElemData,0,NewFieldNumbers[2]));
	
	returnptr = NewFieldNumbers;
      }	break;
      
    case	USE_LOCAL_COPY:	/* Get fields from MATLAB using field numbers
				   The second argument ponter to the array of field 
				   numbers is previously created with 
				   QuadLinPass( ..., MAKE_LOCAL_COPY)
				*/
      
      {	
	freq = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[0]));
	ampl = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[1]));
	phase = mxGetScalar(mxGetFieldByNumber(ElemData,0,FieldNumbers[2]));
	
	returnptr = FieldNumbers;
      }	break;
      
    default:
      {	mexErrMsgTxt("No match found for calling mode in function KickerPass\n");
      }
    }
  KickerPass(r_in, freq, ampl, phase, num_particles);
  return(returnptr);
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 	
  double freq, ampl, phase;
  int m,n;
  double *r_in;   
  mxArray *tmpmxptr;
  
  if(nrhs)
    {
      
      /* ALLOCATE memory for the output array of the same size as the input */
      m = mxGetM(prhs[1]);
      n = mxGetN(prhs[1]);
      if(m!=6) 
	mexErrMsgTxt("Second argument must be a 6 x N matrix");
      
      
      tmpmxptr=mxGetField(prhs[0],0,"Frequency");
      if(tmpmxptr)
	freq = mxGetScalar(tmpmxptr);
      else
	mexErrMsgTxt("Required field 'Frequency' was not found in the element data structure"); 
      
      
      tmpmxptr=mxGetField(prhs[0],0,"Amplitude");
      if(tmpmxptr)
	ampl = mxGetScalar(tmpmxptr);
      else
	mexErrMsgTxt("Required field 'Amplitude' was not found in the element data structure");
      
      tmpmxptr=mxGetField(prhs[0],0,"Phase");
      if(tmpmxptr)
	phase = mxGetScalar(tmpmxptr);
      else
	mexErrMsgTxt("Required field 'Phase' was not found in the element data structure");
      
      plhs[0] = mxDuplicateArray(prhs[1]);
      r_in = mxGetPr(plhs[0]);
      KickerPass(r_in, freq, ampl, phase, n);
    }
  else
    {   /* return list of required fields */
      plhs[0] = mxCreateCellMatrix(3,1);
      mxSetCell(plhs[0],0,mxCreateString("Frequency"));
      mxSetCell(plhs[0],1,mxCreateString("Amplitude"));
      mxSetCell(plhs[0],2,mxCreateString("Phase"));
      if(nlhs>1) /* optional fields */ 
	{   
	  plhs[1] = mxCreateCellMatrix(1,1); 
	  mxSetCell(plhs[1],0,mxCreateString("TimeLag"));
	}
    }
  
}
#endif
