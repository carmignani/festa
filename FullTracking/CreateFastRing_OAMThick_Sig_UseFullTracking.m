function [fastring,fastringrad,ringrad,OAM,SigmaMat]=...
    CreateFastRing_OAMThick_Sig_UseFullTracking(...
    ring,RFVolt,hnum,nusp,filename,EmitRatio,rotatify,radflag,subdir)
%
%
%
%

ring=atsetcavity(ring,RFVolt,0,hnum);
ringrad=atsetcavity(atradon(ring),RFVolt,1,hnum);

if ~exist([subdir '/fastrings.mat'],'file')
    [fastring,fastringrad]=atfastring(ring);
    save([subdir '/fastrings.mat'],'fastring','fastringrad');
else
    load([subdir '/fastrings.mat'])
end

% OAM_rad = OrbitAnglesMatrixThickWithSext_UseFullTracking( ringrad, nusp, rotatify);
% OAM_norad = OrbitAnglesMatrixThickWithSext_UseFullTracking( ring, nusp, rotatify);
OAM_rad = OrbitAnglesMatrixThickWithSext_nuspp1( ringrad, nusp );
OAM_norad = OrbitAnglesMatrixThickWithSext_nuspp1( ring, nusp );

if radflag
    OAM=OAM_rad;
else
    OAM=OAM_norad;
end

[a,b]=atx(atradoff(ring),1);

% SigmaMat=a.beam66;
SigmaMat=atsigma(a.beta(1),a.alpha(1),b.modemittance(1),...
    a.beta(2),a.beta(2),b.modemittance(1)*EmitRatio,b.espread,b.blength);

save([ subdir '/' filename '.mat' ],'ring','ringrad',...
    'fastring','fastringrad','SigmaMat','OAM_rad','OAM_norad','nusp');
end 

