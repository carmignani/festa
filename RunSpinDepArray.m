function datafolder = RunSpinDepArray(...
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
% 
% function datafolder = RunSpinDepArray_KickerPassMethod(...
%     fastring,...
%     Sig,...
%     OAM,...
%     nusp,...
%     nturns,...          
%     npart,...           
%     freq,...           
%     kickampl,...
%     nproc,...           
%     InPol,...              
%     oarspecstring,...
%     DirectoryLabel )  
%

routine='SPINDepOARrunner'; % compiled routine file name.
[pathtoroutine,~,exte]=fileparts(which(routine));

if ~exist(fullfile(pathtoroutine,[routine exte]),'file')
     error([routine ' does not exist in: ' pathtoroutine...
        ' . If this is not the correct directory,'...
        ' you may need to add the directory that contains'...
        routine ' to the path.']);
end

%create initial coordinates
Coord=atbeam(npart,Sig);    
nup=ceil((InPol+1)*npart/2);
Spin=[zeros(1,npart);ones(1,nup),-1*ones(1,npart-nup);zeros(1,npart)];

nfreq=length(freq);
commonwork=...
    ['SPIN_fr' num2str(nfreq) '_' num2str(freq(1)) '_' num2str(freq(nfreq)) ...
    '_proc' num2str(nproc) '_' DirectoryLabel ...
    ];%
commonworkdir=fullfile(pwd,commonwork);%
mkdir(commonworkdir);

cd(commonworkdir);

datafolder=pwd;

% I save many input files here
save('inputGeneralfile.mat','fastring','OAM','nusp','freq','Coord','Spin','kickampl','nturns');

totprocnum=1;

workdir=pwd;
pfile=fopen('params.txt','w+');

pts=npart; %  points to scan
if (nproc>pts)
    nproc=pts;
end
[pointsperprocess]=DivideOARJobs(pts,nproc);
AllPartIndex=1:npart;

for indproc=1:nproc %
    % prepare SpecsFile
    inputFile=fullfile(workdir,'inputGeneralfile.mat');          %#ok<*NASGU> % AT lattice
    numberofturns=nturns;     % number of turns for tracking
    outfilename=fullfile(pwd,['outfile_' num2str(indproc,'%0.4d') '.mat']);
        
    partindex=AllPartIndex(sum(pointsperprocess(1:indproc-1))+1:sum(pointsperprocess(1:indproc)));
       
    spfn=['specfile_' num2str(indproc,'%0.4d') '.mat'];
    save(spfn,'inputFile','outfilename',...
        'partindex');
    
    % prepare OAR script to run TolErrorSetEvaluatorOARrunner
    % put here the matlab version you are using
    script=[' /opt/matlab_2013a ' fullfile(pwd,spfn) '\n']; 
    
    %fopen(fullfile(workdir,'params.txt'),'w+')
    fprintf(pfile,script');
    
end% END LOOP processes
%
routinetorun=[pathtoroutine '/run_' routine '.sh' ];
addlabel=DirectoryLabel;
label=[ 'sp_' addlabel]; % label for files.
oarcmd=['oarsub -n ' label ' ' oarspecstring ' --array-param-file ./params.txt ' routinetorun];
fprintf(fopen(['RunOAR_Script_' routine '_' label '.sh'],'w+'),oarcmd');
system(['chmod u+x RunOAR_Script_' routine '_' label '.sh']);
fclose('all');
% run on OAR
system(['./RunOAR_Script_' routine '_' label '.sh']);
cd('..') % back to Parent of Working Directory
disp([num2str(nproc) ' processes with label: ' label ' are running on OAR (' oarspecstring ')']);

end
