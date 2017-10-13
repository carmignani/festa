function [fastring,fastringrad,ringrad,OAM,SigmaMat]=...
    CreateFastRing_OAMThick_Sig_UseFullTracking(...
    ring,RFVolt,hnum,nusp,filename,rotatify,radflag,subdir)
%
%
%
%

% ringrad=atsetcavity(atradon(ring),RFVolt,1,hnum)
indcav=findcells(ring,'Class','RFCavity');
cav=ring(indcav(1));
ring(indcav)=[];
ring=[cav;ring];
ring=atsetcavity(ring,RFVolt,0,hnum);
ringrad=atsetcavity(atradon(ring),RFVolt,1,hnum);

if ~exist([subdir '/fastrings.mat'],'file')
    [fastring,fastringrad]=atfastring(ring);
    save([subdir '/fastrings.mat'],'fastring','fastringrad');
else
    load([subdir '/fastrings.mat'])
end

% [ringrad,RADINDEX,~,~]=atradon(ring);
% ringrad=atsetcavity(ringrad,RFVolt,1,hnum);
OAM_rad = OrbitAnglesMatrixThickWithSext_UseFullTracking( ringrad, nusp, rotatify);
OAM_norad = OrbitAnglesMatrixThickWithSext_UseFullTracking( ring, nusp, rotatify);
if radflag
    OAM=OAM_rad;
else
    OAM=OAM_norad;
end

% OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ring, nusp, rotatify);
%envelope=ohmienvelope(ringrad,RADINDEX,1);
[a,~]=atx(ring,0,1);
%SigmaMat=envelope.R;
SigmaMat=a.beam66;
save([ subdir '/' filename '.mat' ],'ring','ringrad',...
    'fastring','fastringrad','SigmaMat','OAM_rad','OAM_norad','nusp');
end 

