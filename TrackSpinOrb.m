function [ Pol ] = TrackSpinOrb( Particles,Spin,nturns,nukick,ampkick,fastringrad,OAM,nusp )
%
%   [ Pol ] = TrackSpinOrb( Coord,Spin,nturns,nukick,ampkick,fastringrad,OAM,nusp )
%
%
% CoordLoc=Coord;
% SpinLoc=Spin;

Kicker=atbaselem('Kicker','VerticalKickerPass','Frequency',nukick,'Amplitude',ampkick,'Phase',0);
fastringrad=[fastringrad;Kicker];
npart=size(Particles,2);
ind=0;
Particles=ringpass(fastringrad,Particles,nturns);
for turn=1:nturns
     for part=1:npart
        SpinRot=SpinRotMatrix( Particles(:,(turn-1)*npart+part),OAM,nusp );
        Spin(:,part)=SpinRot*Spin(:,part);
     
        [Spin(:,part) ]=...
            kicker_onlyspin(Particles(:,(turn-1)*npart+part),Spin(:,part),turn,nukick,ampkick,nusp);
     end
     if(mod(turn-1,ceil(nturns/1000))==0);
        ind=ind+1;
        Pol(ind)=mean(Spin(2,:));
     end
end