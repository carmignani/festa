if ~exist('neededvariables.mat','file')
    load('esrf.mat');
    ring=esrf;
    RFVolt=9e6;
    hnum=992;
    nusp=13.707;
    filename='neededvariables';
    CreateFastRing_OAMThick_Sig(ring,RFVolt,hnum,nusp,filename);
    load('neededvariables.mat');
else
    load('neededvariables.mat');
end

fastringOAMSigfile='neededvariables.mat';
%OAM=zeros(3,6);

nusp=13.707;
nturns=1e5;
npart=100;
halfsize=8e-3;
nsteps=51;
freq=.707+(-halfsize:2*halfsize/(nsteps-1):halfsize);
kickampl=1.5e-6;
nproc=100;
InPol=.90;
oarspecstring='-l walltime=2 -q asd';
DirectoryLabel='OAM';
tic
datafolder = RunSpinDepArray(...
    fastring,...
    Sig,...
    OAM,...
    nusp,...
    nturns,...          
    npart,...           
    freq,...           
    kickampl,...
    nproc,...           
    InPol,...              
    oarspecstring,...
    DirectoryLabel )  
AllPol=CollectSPINDepOARData(datafolder);
toc
