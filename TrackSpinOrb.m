function [ Pol_x, Pol_y, Pol_z, Coord_temp, Spin_temp ] = ...
    TrackSpinOrb( Particles,Spin,nturns,nukick,ampkick,fastringrad,OAM,nusp )
%
%   [ Pol_x, Pol_y, Pol_z ] = ...
%       TrackSpinOrb( Coord,Spin,nturns,nukick,ampkick,fastringrad,OAM,nusp )
%
%       This function performs the spin and orbit tracking of many
%       particles for many turns and returns the polarization vector every
%       nturns/1000 
%
%   see also: SpinRotMatrix, kicker_onlyspin, atfastring

Kicker=atbaselem('Kicker','ACDipolePass','freqy',nukick,...
    'amply',ampkick,'phasey',0,...
    'freqx',0,'amplx',0,'phasex',0);
fastringrad=[fastringrad;Kicker];
npart=size(Particles,2);
ind=0;
Particles=ringpass(fastringrad,Particles,nturns);
for turn=1:nturns
     for part=1:npart
        SpinRot=SpinRotMatrix( Particles(:,(turn-1)*npart+part),OAM,nusp );
        Spin(:,part)=SpinRot*Spin(:,part);
     
        [Spin(:,part) ]=...
            kicker_onlyspin(Particles(:,(turn-1)*npart+part),...
            Spin(:,part),turn,nukick,ampkick,nusp);
     end
     if(mod(turn-1,ceil(nturns/1000))==0);
        ind=ind+1;
        Pol_x(ind)=mean(Spin(1,:));
        Pol_y(ind)=mean(Spin(2,:));
        Pol_z(ind)=mean(Spin(3,:));
     end
end
Coord_temp=Particles(:,end-npart+1:end);
Spin_temp=Spin;