function [z1, rotmat, s1 ] = Track1Turn_spinorbit( ring, z, s, nusp, indBendQuad, maskbend )
%   [z1, s1] = Track1Turn_spinorbit( ring, z, s )

ROUT0=linepass(ring,z,indBendQuad);
ROUT1=linepass(ring,z,indBendQuad+1);

thetatot=0;
SpinMat=eye(3);
for i=1:length(indBendQuad)
    delta=(ROUT0(5,i)+ROUT1(5,i))/2;        
    dZ=ROUT1(:,i)-ROUT0(:,i);
    if maskbend(i)   %element i is a bending magnet
        BA=ring{indBendQuad(i)}.BendingAngle;
    else     %element i is not a bending magnet
        % this should be a quadrupole or a sextupole
        BA=0;
    end
    elemSpinMat=CalcSpRotMat(BA,dZ(2),dZ(4),delta,nusp);
    thetatot=thetatot-BA+dZ(2)/(1+delta);
    SpinMat=elemSpinMat*SpinMat;
end
thetatot;
% SpinMat=Rotatify(SpinMat);
z1=ROUT1(:,end);
if nargout==3
    s1=SpinMat*s;
end
rotmat=Rotatify(SpinMat);
end
