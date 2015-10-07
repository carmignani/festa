function SpinRot = SpinRotMatrix( coord,OAM,nusp )
%   SpinRot = SpinRotMatrix( coord,OAM,nusp )
%   This function computes the spin rotation matrix given the 6-D phase
%   space coordinates (coord), the OrbitAngleMatrix (OAM) and the spin tune
%   OAM can be computed with function OrbitAnglesMatrix
%
%   See also OrbitAnglesMatrix.m

theta=OAM*coord;
tx=theta(1);
ty=theta(2);
tz=theta(3);

SmallRot=[ cos(ty)*cos(tz),-cos(ty)*sin(tz),-sin(ty);...
    -cos(tz)*sin(tx)*sin(ty)+cos(tx)*sin(tz),cos(tx)*cos(tz)+sin(tx)*sin(ty)*sin(tz),-cos(ty)*sin(tx);...
    cos(tx)*cos(tz)*sin(ty)+sin(tx)*sin(tz),cos(tz)*sin(tx)-cos(tx)*sin(ty)*sin(tz),cos(tx)*cos(ty)];

nuspdelta=nusp;%*(1+coord(5));
BigRot=[cos(2*pi*nuspdelta),0,-sin(2*pi*nuspdelta);...
        0,1,0;...
        sin(2*pi*nuspdelta),0,cos(2*pi*nuspdelta)];
SpinRot=SmallRot*BigRot;
end

