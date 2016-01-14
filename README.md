# festa
Fast Electron Spin Tracking based on AT

Ciao.

To set up at ESRF:

1. compile mex function by running `compileMexPassMethod` (make sure to exit Matlab to release compiler license) 
2. compile matlab function by running `compileMatlabFunction` script (make sure the path is included in pathdef.m by saving it, rather than included in startup.m.  Otherwise compilation won't actually include all the functions.)
3. run script with parameters, e.g. `runSpinDep_exampleScript`
