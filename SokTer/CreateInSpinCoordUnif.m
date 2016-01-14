function [ Spins ] = CreateInSpinCoordUnif( nPart )
%
%   [ Spins ] = CreateInSpinCoordUnif( nPart )
%   Spins are the coordinates of the spins, it's a 2*nPart vector
%   (theta;phi)

costheta=rand(1,nPart)*2-1;
theta=acos(costheta);
phi=rand(1,nPart)*2*pi;

Spins=[theta;phi];

end

