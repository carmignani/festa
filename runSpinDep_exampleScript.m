if ~exist('neededvariables.mat','file')
    %     load('esrf.mat');
    ring=atSetRingProperties(esrf);
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
nturns=5e4;
npart=100;
halfsize=8e-3;
nsteps=19;
freq=.707+(-halfsize:2*halfsize/(nsteps-1):halfsize);
kickampl=5e-6;
nproc=100;
InPol=.90;
oarspecstring='-l walltime=1 -q asd';
DirectoryLabel='OAM';
tic
datafolder = RunSpinDepArray(...
    fastringrad,...
    SigmaMat,...
    OAM,...
    nusp,...
    nturns,...          
    npart,...           
    freq,...           
    kickampl,...
    nproc,...           
    InPol,...              
    oarspecstring,...
    DirectoryLabel);
AllPol=CollectSPINDepOARData(datafolder,DirectoryLabel,0);
toc
