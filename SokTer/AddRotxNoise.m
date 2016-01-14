function Spins = AddRotxNoise(Spins,NoiseAmpRad)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
npart=length(Spins(1,:));
for ii=1:npart
    S=[ sin(Spins(1,ii))*cos(Spins(2,ii));...
        sin(Spins(1,ii))*sin(Spins(2,ii));...
        cos(Spins(1,ii))];
    Snoise=RotMatx(NoiseAmpRad*randn)*S;
    Spins(1,ii)=acos(Snoise(3));
    Spins(2,ii)=atan(Snoise(2)/Snoise(1));
end
end

function RM=RotMatx(angle)
ca=cos(angle);
sa=sin(angle);
RM=...
    [   1   0   0   ;...
        0   ca  -sa ;...
        0   sa  ca  ];
end