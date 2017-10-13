function OAM = OrbitAnglesMatrixThickWithSext_nuspp1( ring, nusp, rotatify )
%   OAM = OrbitAnglesMatrix( ring, nusp )
%   This function computes the OarbitAnglesMatrix in the initial position
%   of ring.
%   The spin vector [sx; sy; sz] will rotate around the y axis of an angle
%   nusp and then it will rotate arount x of thetax, arount y of thetay and
%   around z of thetaz.
%   This function computes thetax, thetay and thetaz given the 6-D phase
%   space coordinates of the electron.
%   OAM is a 3x6 matrix.
%   [thetax;thetay;thetaz]=OAM*[x;xp;y;yp;delta;s]
%
%   See also SpinRotMatrix.m

% nelem=length(ring);
clorb=findorbit6(ring,1)
indBendQuad=findcells(ring,'Class','Bend','Quadrupole','Sextupole');
%indBendQuad=findcells(ring,'Class','Bend','Quadrupole');

eps=1e-6;
Rin0=[0;0;0;0;0;0]+clorb;
Rin1=[1;0;0;0;0;0];
Rin2=[0;1;0;0;0;0];
Rin3=[0;0;1;0;0;0];
Rin4=[0;0;0;1;0;0];
Rin5=[0;0;0;0;1;0];
Rin6=[0;0;0;0;0;1];
Rin=[Rin1,Rin2,Rin3,Rin4,Rin5,Rin6]*eps+repmat(clorb,1,6);

ROUT0=linepass(ring,Rin0,indBendQuad);

for jj=1:6
    SpinMat0=eye(3);
    SpinMat1=eye(3);
    ROUT1=linepass(ring,Rin(:,jj),indBendQuad);
    for i=1:length(indBendQuad)
        Z0=linepass(ring(indBendQuad(i)),ROUT0(:,i));
        Z1=linepass(ring(indBendQuad(i)),ROUT1(:,i));
        dZ0=Z0-ROUT0(:,i);
        dZ1=Z1-ROUT1(:,i);
        dpx0=dZ0(2);
        dpy0=dZ0(4);
        dpx1=dZ1(2);
        dpy1=dZ1(4);
        delta0=(ROUT0(5,i)+Z0(5))/2;
        delta1=(ROUT1(5,i)+Z1(5))/2;
        if strcmp(ring{indBendQuad(i)}.Class,'Bend')
            BA=ring{indBendQuad(i)}.BendingAngle;
        else
            %this should be a quadrupole or a sextupole
            BA=0;
        end
        elemSpinMat0=CalcSpRotMat(BA,dpx0,dpy0,delta0,nusp);
        elemSpinMat1=CalcSpRotMat(BA,dpx1,dpy1,delta1,nusp);
        SpinMat0=elemSpinMat0*SpinMat0;
        SpinMat1=elemSpinMat1*SpinMat1;
    end
%     if jj==5
% %     thsptot0
% %     thsptot1
%     end
%     SpinMat0=Rotatify(SpinMat0);
%     SpinMat1=Rotatify(SpinMat1);
    R0=SpinMat0; 
    R1=SpinMat1;
    if jj==3
        R0
        R1
    end
    r1=R1*R0';
    thetax(jj)=-(r1(3,2)-r1(2,3))/2;
    thetay(jj)=-(r1(3,1)-r1(1,3))/2;
    thetaz(jj)=-(r1(2,1)-r1(1,2))/2;
    clear SpinMat1 SpinMat0 ROUT1
end
OAM=[thetax;thetay;thetaz]/eps;
end
