function FinPol=SokTer( Spins, nusp, PolTime, nturns, NoiseAmpRad )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

SpinRotAngle=nusp*2*pi;
for nt=1:nturns
    for np=1:length(Spins(1,:))
        Spins(2,np)=mod(Spins(2,np)+SpinRotAngle,6.283185307179586);
        Prob=ProbFlip(Spins(:,np),PolTime);
        if rand<Prob
            Spins(:,np)=SpinFlip(Spins(:,np));
        end
    end
    if NoiseAmpRad>0
        Spins=AddRotxNoise(Spins,NoiseAmpRad);
    end
    %disp(nt);
end
FinPol=mean(cos(Spins(1,:)));
disp(FinPol);
end

