function [fastring,fastringrad,ringrad,OAM,SigmaMat]=CreateFastRing_OAMThick_Sig(ring,RFVolt,hnum,nusp,filename)

indcav=findcells(ring,'Class','RFCavity');
cav=ring(indcav(1));
ring(indcav)=[];
ring=[cav;ring];
ring=atsetcavity(ring,RFVolt,1,hnum);
[fastring,fastringrad]=atfastring(ring);
% indlin=findcells(fastring,'FamName','lin_elem');
% indlinrad=findcells(fastringrad,'FamName','lin_elem');
% M66=fastring{indlin}.M66;
% M66rad=fastringrad{indlinrad}.M66;
% M66sympl=symplectify(M66);
% M66symplrad=symplectify(M66rad);
% fastring{indlin}.M66=M66sympl;
% fastringrad{indlinrad}.M66=M66symplrad;
[ringrad,RADINDEX,~,~]=atradon(ring);
ringrad=atsetcavity(ringrad,RFVolt,1,hnum);
OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ring, nusp );
%envelope=ohmienvelope(ringrad,RADINDEX,1);
[a,~]=atx(ring,0,1);
%SigmaMat=envelope.R;
SigmaMat=a.beam66;
save([ filename '.mat' ],'ringrad','fastring','fastringrad','SigmaMat','OAM');
end 

