function [fastring,fastringrad,ringrad,OAM,SigmaMat]=CreateFastRing_OAMThick_Sig(ring,RFVolt,hnum,nusp,filename,rotatify,radflag)
% ringrad=atsetcavity(atradon(ring),RFVolt,1,hnum)
indcav=findcells(ring,'Class','RFCavity');
cav=ring(indcav(1));
ring(indcav)=[];
ring=[cav;ring];
ring=atsetcavity(ring,RFVolt,0,hnum);
ringrad=atsetcavity(atradon(ring),RFVolt,1,hnum);

if ~exist('./fastrings.mat','file')
    [fastring,fastringrad]=atfastring(ring);
    save('./fastrings.mat','fastring','fastringrad');
else
    load('./fastrings.mat')
end

% [ringrad,RADINDEX,~,~]=atradon(ring);
% ringrad=atsetcavity(ringrad,RFVolt,1,hnum);
if radflag
    OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ringrad, nusp, rotatify);
else
    OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ring, nusp, rotatify);
end
%OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ringrad, nusp, rotatify);
%envelope=ohmienvelope(ringrad,RADINDEX,1);
[a,~]=atx(ring,0,1);
%SigmaMat=envelope.R;
SigmaMat=a.beam66;
save([ filename '.mat' ],'ringrad','ring','fastring','fastringrad','SigmaMat','OAM');
end 

