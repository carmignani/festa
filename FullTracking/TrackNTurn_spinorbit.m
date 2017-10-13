function [z1, rotmat, s1] = TrackNTurn_spinorbit( ring, z, s, nusp, indBendQuad, maskbend, N )
%   [z1, s1] = Track1Turn_spinorbit( ring, z, s )

% N=10;
ring=repmat(ring,N,1);
indBendQuad=repmat(indBendQuad,1,N);
ROUT0=linepass(ring,z,...
    indBendQuad+(length(ring)/N)*sort(repmat(0:(N-1),1,length(indBendQuad)/N)));
ROUT1=linepass(ring,z,...
    indBendQuad+1+(length(ring)/N)*sort(repmat(0:(N-1),1,length(indBendQuad)/N)));
maskbend=repmat(maskbend,N,1);
% ROUT=linepass(ring,z,sort([indBendQuad indBendQuad+1]));
% ROUT0=ROUT(:,1:2:end);
% ROUT1=ROUT(:,2:2:end);

thetatot=0;
SpinMat=eye(3);
for i=1:length(indBendQuad)
    if maskbend(i)
        delta=(ROUT0(5,i)+ROUT1(5,i))/2;
        dZ=ROUT1(:,i)-ROUT0(:,i);
        
        %we subtract dx' component to get total bending angle
        thetaBend=ring{indBendQuad(i)}.BendingAngle-dZ(2)/(1+delta);
        thetatot=thetatot+thetaBend;
        thetaSpin=(nusp*(1+delta)+1)*thetaBend;
        elemSpinMat=[cos(thetaSpin),0, -sin(thetaSpin) ;...
            0,             1,  0;...
            sin(thetaSpin),0,  cos(thetaSpin)];
    else
        % this should be a quadrupole
        % (or a sextupole if we track in sextupoles too)
        
        %compute change in x' for each element to get the orbital kick.
        %From the orbital kick thetaQuad
        
        dZ=ROUT1(:,i)-ROUT0(:,i);
        
        delta=(ROUT0(5,i)+ROUT1(5,i))/2;
        
        dpx=dZ(2);
        dpy=dZ(4);
        
        thetaQuad=sqrt(dpx^2+dpy^2)/(1+delta);%remember that px=x'*(1+delta)
        
        thetatot=thetatot+thetaQuad;
        
        if thetaQuad~=0
            u=[-dpy,dpx,0]/thetaQuad;
            theta=thetaQuad*(nusp*(1+delta)+1);
            ct=cos(theta);
            st=sin(theta);
            %formula from rotation matrix wikipedia
            %(rotation matrix from axis and angle)
            elemSpinMat=[ct + u(1)^2*(1-ct),    u(1)*u(2)*(1-ct),   u(2)*st;...
                u(1)*u(2)*(1-ct),      ct + u(2)^2*(1-ct), -u(1)*st;...
                -u(2)*st,              u(1)*st,            ct];
        else
            elemSpinMat=eye(3);
        end
        
    end
    SpinMat=elemSpinMat*SpinMat;
end

z1=ROUT1(:,end);
if nargout==3
    s1=SpinMat*s;
end
rotmat=SpinMat;
end