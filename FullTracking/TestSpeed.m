load('../esrf.mat');
ring=esrf;
%get energy to compute spin tune
%E0=2.978715e9;
E0=atenergy(ring);
gamma=E0/510998.93;
a=0.00115965218;
nusp=a*gamma;

% nelem=length(ring);

%find all dipoles and quadrupoles (and sextupoles?)
indBendQuad=findcells(ring,'Class','Bend','Quadrupole');
%indBendQuad=findcells(ring,'Class','Bend','Quadrupole','Sextupole');
indBendQuad=[indBendQuad length(ring)];
maskbend=atgetcells(ring(indBendQuad),'Class','Bend');


% z=[0.00;0;0.00001;0;0;0]; 
% s=[0;1;0];
% tic
% rotmattotN=eye(3);
% for ii=1:10;
%     [z,rotmat,s]=TrackNTurn_spinorbit(esrf,z,s,nusp,indBendQuad,maskbend,100);
%     rotmattotN=rotmat*rotmattotN;
% end
% toc
% zN=z;
% sN=s;
z=[0.00;0;0.000;0;0;0]; 
s=[0;1;0];
tic
rotmattot1=eye(3);
for ii=1:250;
    [z,rotmat,s]=Track1Turn_spinorbit(esrf,z,s,nusp,indBendQuad,maskbend);
    rotmattot1=rotmat*rotmattot1;
end
toc
z1=z;
s1=s
% sN
% s1
% rotmattotN
rotmattot1
