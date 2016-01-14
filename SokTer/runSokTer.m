% Script for Sok Ter
PolTime=20;
nparts=100000;
nturns=1000;
nusp=0.707;
Spins=CreateInSpinCoordUnif(nparts);
tic
SokTer(Spins,nusp,PolTime,nturns,0);
toc