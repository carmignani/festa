function [ Pol_x, Pol_y, Pol_z, Coord_temp, Spin_temp ] = ...
    TrackSpinOrb_clorb( Particles,Spin,nturns,nukick,ampkick,fastringrad,OAM,nusp,clorb )
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
Particles_out=ringpass(fastringrad,Particles,nturns);
Coordinates=reshape([Particles,Particles_out],6,npart,nturns+1);
for turn=1:nturns
     for part=1:npart
%         SpinRot=SpinRotMatrix( Particles(:,(turn-1)*npart+part)-clorb,OAM,nusp );
        SpinRot=SpinRotMatrix( Coordinates(:,part,turn)-clorb,OAM,nusp );
        SpinRot=Rotatify(SpinRot);
        Spin(:,part)=SpinRot*Spin(:,part);
        
        [Spin(:,part) ]=...
            kicker_onlyspin(Coordinates(:,part,turn+1),...
            Spin(:,part),turn,nukick,ampkick,nusp);
     end
     if(mod(turn-1,ceil(nturns/1000))==0);
        ind=ind+1;
        Pol_x(ind)=mean(Spin(1,:));
        Pol_y(ind)=mean(Spin(2,:));
        Pol_z(ind)=mean(Spin(3,:));
     end
end
Coord_temp=Coordinates(:,:,end);
Spin_temp=Spin;