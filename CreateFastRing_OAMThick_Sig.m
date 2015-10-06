function [fastring,fastringrad,esrfrad,OAM,Sig]=CreateFastRing_OAMThick_Sig(ring,RFVolt,hnum,nusp,filename)

indcav=findcells(ring,'Class','RFCavity');
cav=ring(indcav(1));
ring(indcav)=[];
ring=[cav;ring];
ring=atsetcavity(ring,RFVolt,0,hnum);
[fastring,fastringrad]=atfastring(ring);
indlin=findcells(fastring,'FamName','lin_elem');
indlinrad=findcells(fastringrad,'FamName','lin_elem');
M66=fastring{indlin}.M66;
M66rad=fastringrad{indlinrad}.M66;
M66sympl=symplectify(M66);
M66symplrad=symplectify(M66rad);
fastring{indlin}.M66=M66sympl;
fastringrad{indlinrad}.M66=M66symplrad;
[esrfrad,RADINDEX,~,~]=atradon(ring);
esrfrad=atsetcavity(esrfrad,RFVolt,1,hnum);
OAM = OrbitAnglesMatrixThickWithSext( ring, nusp );
envelope=ohmienvelope(esrfrad,RADINDEX,1);
Sig=envelope.R;
save([ filename '.mat' ],'esrfrad','fastring','fastringrad','Sig','OAM');
end 

