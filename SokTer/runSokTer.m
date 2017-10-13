% Script for Sok Ter
PolTime=100;
nparts=1000;
nturns=10000;
nusp=0.707;
Spins=CreateInSpinCoordUnif(nparts);
% tic
% SokTer(Spins,nusp,PolTime,nturns,0,'normal');
% toc
% tic
% SokTer(Spins,nusp,PolTime,nturns,0,'prob10');
% toc
% tic
% SokTer(Spins,nusp,PolTime,nturns,0,'boaz');
% toc
tic
SokTer(Spins,nusp,PolTime,nturns,0,'boaznoise');
toc