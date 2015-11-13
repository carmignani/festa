function [AllPol_x,AllPol_y,AllPol_z]=...
    CollectSPINDepOARData(datafolder, string, export)
%
%   [AllPol_x,AllPol_y,AllPol_z]=...
%       CollectSPINDepOARData(datafolder, string, export)
%
%   This function collects the many output files from the spin
%   depolarization code.
%
%   see also: RunSpinDepArray, SPINDepOARrunner, TrackSpinOrb
%

cd(datafolder)

a=dir('specfile*.mat');
totproc=length(a);
b=dir('outfile*.mat');
finproc=length(b);
% load('latticefile.mat');
% wait for processes to finish
while finproc~=totproc
    b=dir('outfile*.mat');

    disp(['waiting for ' num2str(totproc-finproc) '/' num2str(totproc) ...
        ' processes to finish.'])
    
    % % % count runnning processes
    b=dir('outfile*.mat');
    finproc=length(b);

    % wait
    pause(10);
    
end
load('inputGeneralfile.mat');
nfreq=length(freq);
AllPol_x=zeros(1000,nfreq);
AllPol_y=zeros(1000,nfreq);
AllPol_z=zeros(1000,nfreq);

for iproc=1:totproc
    load(['outfile_' num2str(iproc,'%0.4d') '.mat'],...
        'freq','partindex','Pol_x','Pol_y','Pol_z');
    nPart(iproc)=length(partindex);
    AllPol_x=AllPol_x+Pol_x*nPart(iproc);
    AllPol_y=AllPol_y+Pol_y*nPart(iproc);
    AllPol_z=AllPol_z+Pol_z*nPart(iproc);
end
nPartTot=sum(nPart);
AllPol_x=AllPol_x/nPartTot;
AllPol_y=AllPol_y/nPartTot;
AllPol_z=AllPol_z/nPartTot;

save('Results.mat','freq','AllPol_x','AllPol_y','AllPol_z','nturns');
system('rm *.stderr');
system('rm *.stdout');
system('rm outfile*');
system('rm specfile*');

cd ..

PlotDep(datafolder, string, export)
