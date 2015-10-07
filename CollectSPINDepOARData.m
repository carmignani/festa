function [AllPol]=CollectSPINDepOARData(datafolder, string, export)




cd(datafolder)

a=dir('specfile*.mat');
totproc=length(a);
b=dir('outfile*.mat');
finproc=length(b);
% load('latticefile.mat');
% wait for processes to finish
while finproc~=totproc
    b=dir('outfile*.mat');

    disp(['waiting for ' num2str(totproc-finproc) '/' num2str(totproc) ' processes to finish.'])
    
    % % % count runnning processes
    b=dir('outfile*.mat');
    finproc=length(b);

    % wait
    pause(10);
    
end
load('inputGeneralfile.mat');
nfreq=length(freq);
AllPol=zeros(1000,nfreq);

for iproc=1:totproc
    load(['outfile_' num2str(iproc,'%0.4d') '.mat'],'freq','partindex','Pol');
    nPart(iproc)=length(partindex);
    AllPol=AllPol+Pol*nPart(iproc);
end
nPartTot=sum(nPart);
AllPol=AllPol/nPartTot;

save('Results.mat','freq','AllPol','nturns');
system('rm *.stderr');
system('rm *.stdout');
system('rm outfile*');
system('rm specfile*');

cd ..

PlotDep(datafolder, string, export)
