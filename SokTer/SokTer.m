function FinPol=SokTer( Spins, nusp, PolTime, nturns, NoiseAmpRad, method )
%   FinPol=SokTer( Spins, nusp, PolTime, nturns, NoiseAmpRad, method )
%   
%   Spins is the initial spins distribution, use CreateInSpinCoordUnif
%   nusp is the spin tune
%   PolTime is the polarization time in turns
%   nturns is the number of turns of the simulation
%   NoiseAmpRad is the rms value of the noise in rad, that is a rotation 
%   around horizontal axis at each turn
%   method is a string and can be 'normal', 'prob10' or 'boaz'
%

switch method
    case 'normal'
        methodnum=1;
    case 'prob10'
        methodnum=2;
    case 'boaz'
        methodnum=3;
    case 'boaznoise'
        methodnum=4;
end
SpinRotAngle=nusp*2*pi;
for nt=1:nturns     %loop on turns
    for np=1:length(Spins(1,:))     %loop on particles
        %spin tune rotation
        Spins(2,np)=mod(Spins(2,np)+SpinRotAngle,6.283185307179586);
        switch methodnum
            case 1
                Prob=ProbFlip(Spins(:,np),PolTime);
                if rand<Prob
                    Spins(:,np)=SpinFlip(Spins(:,np));
                end
            case 2
                Prob=ProbFlip10(Spins(:,np),PolTime);
                if rand<Prob
                    Spins(:,np)=SpinFlip(Spins(:,np));
                end
            case 3
                Prob=ProbFlip(Spins(:,np),PolTime);
                if rand<Prob
                    if Spins(1,np)<=1.570796326794897
                        Spins(1,np)=pi;  % go to north pole
                    else
                        Spins(1,np)=0;  % go to south pole
                    end
                end
            case 4
                Prob=ProbFlip(Spins(:,np),PolTime);
                xi=2*sqrt(Prob);
                phi=rand*6.283185307179586;
                Spins(2,np)=Spins(2,np)+xi*cos(phi)/sin(Spins(1,np));
                Spins(1,np)=Spins(1,np)+xi*sin(phi);
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

