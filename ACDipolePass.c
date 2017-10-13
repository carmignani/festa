/* VerticalKickerPass.c
 * Accelerator Toolbox
 * 7/10/15
 * This pass method is for the spin depolarization simulations,
 * but it can be used for different simulations.
 * Nicola Carmignani
 *
 * 22/03/2017
 * Renamed in ACDipolePass.c
 * now it allows horizontal and vertical kicks
 * Nicola Carmignani
 *
 */
#include "atelem.c"
#include "atlalib.c"

#include <math.h>
#define TWOPI  6.28318530717959
#define C0  	2.99792458e8

struct elem
{
    double amplx;
    double amply;
    double freqx;
    double freqy;
    /* Optional fields */
    double phasex;
    double phasey;
};

void ACDipolePass(double *r_in, double amplx, double amply, double freqx,
        double freqy, double phasex, double phasey, int nturn,
        int num_particles)
        /* amp - amplitude of vertical kick in rad
         * freq - frequency in units of revolution freq
         * r is a 6-by-N matrix of initial conditions reshaped into
         * 1-d array of 6*N elements
         *
         * note that time variable is not currently taken into account
         * this is a problem for very high frequency kickers
         */
{
    int c;
    double *r6;
    for(c = 0;c<num_particles;c++)
    {
        r6 = r_in+c*6;
        if(!atIsNaN(r6[0]))
        {
            r6[1] += amplx*cos(TWOPI*freqx*(double)nturn+phasex);
            r6[3] += amply*cos(TWOPI*freqy*(double)nturn+phasey);
            /*printf("turn %06d; kick %06f;\n",nturn,ampl*cos(TWOPI*freq*(double)nturn+phase));*/
        }
    }
}


#if defined(MATLAB_MEX_FILE) || defined(PYAT)
ExportMode struct elem *trackFunction(const atElem *ElemData,struct elem *Elem,
        double *r_in, int num_particles, struct parameters *Param)
{
    int nturn=Param->nturn;
    if (!Elem)
    {
        double amplx, amply, freqx, freqy, phasex, phasey;
        amplx=atGetDouble(ElemData,"amplx"); check_error();
        amply=atGetDouble(ElemData,"amply"); check_error();
        freqx=atGetDouble(ElemData,"freqx"); check_error();
        freqy=atGetDouble(ElemData,"freqy"); check_error();
        /*optional fields*/
        phasex=atGetOptionalDouble(ElemData,"phasex",0);
        phasey=atGetOptionalDouble(ElemData,"phasey",0);
        Elem = (struct elem*)atMalloc(sizeof(struct elem));
        Elem->amplx=amplx;
        Elem->amply=amply;
        Elem->freqx=freqx;
        Elem->freqy=freqy;
        Elem->phasex=phasex;
        Elem->phasey=phasey;
    }
    ACDipolePass(r_in, Elem->amplx, Elem->amply, Elem->freqx,
            Elem->freqy, Elem->phasex, Elem->phasey, nturn, num_particles);
    return Elem;
}

MODULE_DEF(StrMPoleSymplectic4Pass)        /* Dummy module initialisation */

#endif /*defined(MATLAB_MEX_FILE) || defined(PYAT)*/

#if defined(MATLAB_MEX_FILE)
void mexFunction(	int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs == 2)
    {
        double *r_in;
        int nturn=0;
        const mxArray *ElemData = prhs[0];
        int num_particles = mxGetN(prhs[1]);
        double amplx, amply, freqx, freqy, phasex, phasey;
        amplx=atGetDouble(ElemData,"amplx"); check_error();
        amply=atGetDouble(ElemData,"amply"); check_error();
        freqx=atGetDouble(ElemData,"freqx"); check_error();
        freqy=atGetDouble(ElemData,"freqy"); check_error();
        /*optional fields*/
        phasex=atGetOptionalDouble(ElemData,"phasex",0); check_error();
        phasey=atGetOptionalDouble(ElemData,"phasey",0); check_error();
        /* ALLOCATE memory for the output array of the same size as the input  */
        plhs[0] = mxDuplicateArray(prhs[1]);
        r_in = mxGetPr(plhs[0]);
        ACDipolePass(r_in, amplx, amply, freqx,
            freqy, phasex, phasey, nturn, num_particles);
    }
    else if (nrhs == 0) {
        /* list of required fields */
        plhs[0] = mxCreateCellMatrix(4,1);
        mxSetCell(plhs[0],0,mxCreateString("amplx"));
        mxSetCell(plhs[0],1,mxCreateString("amply"));
        mxSetCell(plhs[0],2,mxCreateString("freqx"));
        mxSetCell(plhs[0],3,mxCreateString("freqy"));
        if (nlhs>1) {
            /* list of optional fields */
            plhs[1] = mxCreateCellMatrix(2,1);
            mxSetCell(plhs[1],0,mxCreateString("phasex"));
            mxSetCell(plhs[1],1,mxCreateString("phasey"));
        }
    }
    else {
        mexErrMsgIdAndTxt("AT:WrongArg","Needs 0 or 2 arguments");
    }
}
#endif /*MATLAB_MEX_FILE*/



