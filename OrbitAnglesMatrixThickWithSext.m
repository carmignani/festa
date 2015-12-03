function OAM = OrbitAnglesMatrixThickWithSext_nuspp1_nspE( ring, nusp )
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

%get energy to compute spin tune
%E0=2.978715e9;
E0=atenergy(ring);
gamma=E0/510998.93;
a=0.00115965218;
nusp=a*gamma;

nelem=length(ring);

%find all dipoles, quadrupoles and sextupoles
indBendQuad=findcells(ring,'Class','Bend','Quadrupole','Sextupole');

%compute closed orbit and orbits starting with eps variation in each
%direction
clorb=findorbit6(ring);
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
    thetatot0=0;
    thetatot1=0;
    SpinMat0=eye(3);
    SpinMat1=eye(3);
    ROUT1=linepass(ring,Rin(:,jj),indBendQuad);
    for i=1:length(indBendQuad)
        if strcmp(ring{indBendQuad(i)}.Class,'Bend')
            Z0=linepass(ring(indBendQuad(i)),ROUT0(:,i));
            Z1=linepass(ring(indBendQuad(i)),ROUT1(:,i));
            delta0=ROUT0(5,i);
            delta1=ROUT1(5,i);
            dZ0=Z0-ROUT0(:,i);
            dZ1=Z1-ROUT1(:,i);
            
            %we subtract dx' component to get total bending angle
            thetaBend0=ring{indBendQuad(i)}.BendingAngle-dZ0(2)/(1+delta0);
            thetaBend1=ring{indBendQuad(i)}.BendingAngle-dZ1(2)/(1+delta1);
            thetatot0=thetatot0+thetaBend0;
            thetatot1=thetatot1+thetaBend1;
            thetaSpin0=(nusp*(1+delta0)+1)*thetaBend0;
            elemSpinMat0=[cos(thetaSpin0),0, -sin(thetaSpin0) ;...
                0,             1,  0;...
                sin(thetaSpin0),0,  cos(thetaSpin0)];
            thetaSpin1=(nusp*(1+delta1)+1)*thetaBend1;
            
            elemSpinMat1=[cos(thetaSpin1),0, -sin(thetaSpin1) ;...
                0,             1,  0;...
                sin(thetaSpin1),0,  cos(thetaSpin1)];
        else
            %this should be a quadrupole or a sextupole
            Z0=linepass(ring(indBendQuad(i)),ROUT0(:,i));
            Z1=linepass(ring(indBendQuad(i)),ROUT1(:,i));
            %compute change in x' for each element to get the orbital kick.
            %From the orbital kick, thetaQuad0 and thetaQuad1
            
            dZ0=Z0-ROUT0(:,i);
            dZ1=Z1-ROUT1(:,i);
           
          
            delta0=ROUT0(5,i);
            delta1=ROUT1(5,i);
            
            dpx0=dZ0(2);
            dpy0=dZ0(4);
            dpx1=dZ1(2);
            dpy1=dZ1(4);
         
            thetaQuad0=sqrt(dpx0^2+dpy0^2)/(1+delta0);%remember that px=x'*(1+delta)
            thetaQuad1=sqrt(dpx1^2+dpy1^2)/(1+delta1);
            thetatot0=thetatot0+thetaQuad0;
            thetatot1=thetatot1+thetaQuad1;
            if thetaQuad0~=0
                u=[-dpy0,dpx0,0]/thetaQuad0;
                theta=thetaQuad0*(nusp*(1+delta0)+1);
                ct=cos(theta);
                st=sin(theta);
                %formula from rotation matrix wikipedia
                %(rotation matrix from axis and angle)
                elemSpinMat0=[ct + u(1)^2*(1-ct),    u(1)*u(2)*(1-ct),   u(2)*st;...
                    u(1)*u(2)*(1-ct),      ct + u(2)^2*(1-ct), -u(1)*st;...
                    -u(2)*st,              u(1)*st,            ct];
            else
                elemSpinMat0=eye(3);
            end
            if thetaQuad1~=0
                u=[-dpy1,dpx1,0]/thetaQuad1;
                theta=thetaQuad1*(nusp*(1+delta1)+1);
                ct=cos(theta);
                st=sin(theta);
                %formula from rotation matrix wikipedia
                %(rotation matrix from axis and angle)
                elemSpinMat1=[ct + u(1)^2*(1-ct),    u(1)*u(2)*(1-ct),   u(2)*st;...
                    u(1)*u(2)*(1-ct),      ct + u(2)^2*(1-ct), -u(1)*st;...
                    -u(2)*st,              u(1)*st,            ct];
            else
                elemSpinMat1=eye(3);
            end
        end
        SpinMat0=elemSpinMat0*SpinMat0;
        SpinMat1=elemSpinMat1*SpinMat1;
    end
    R0=SpinMat0;
    R1=SpinMat1;
    r1=R1*R0';
    thetax(jj)=(r1(3,2)-r1(2,3))/2;
    thetay(jj)=(r1(3,1)-r1(1,3))/2;
    thetaz(jj)=(r1(2,1)-r1(1,2))/2;
%     if jj==5
%         disp(thetatot0/2/pi)
%         disp(thetatot1/2/pi)
%     end
    clear SpinMat1 SpinMat0 ROUT1
end
OAM=[thetax;thetay;thetaz]/eps;

% S1=[1;0;0]; S2=[0;1;0];
%
% R1*S1-R0*S1
% R1*S2-R0*S2

end
