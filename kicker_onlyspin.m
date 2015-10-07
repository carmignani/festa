function [ Spin1 ] = kicker_onlyspin( Coord,Spin,turn,nukick,Ampl,nusp )
%   [ Coord1,Spin1 ] = kicker( Coord,Spin,turn,Ampl,nusp )
%   This function computes the effect of the phase space coordinates and on
%   the spin vector due to a vertical kicker. 
%   Input:
%   Coord is the 6D phase space vector
%   Spin is the vector [sx;sy;sz]
%   turn is the turn number
%   freq is the frequency of the kicker in Hz
%   Ampl is the amplitude of the kicker, in radians
%   nusp is the spin tune
%   circ is the ring circumference in metre

thetaOrb=Ampl*cos(2*pi*nukick*(turn));    %Coord(6) effect to be added
% Coord1=Coord;
% Coord1(4)=Coord1(4)+thetaOrb;
thetasp=nusp*(1+Coord(5))*thetaOrb;  % 
rotspin=[1,0,0;...
         0,cos(thetasp),-sin(thetasp);...
         0,sin(thetasp),cos(thetasp)];
Spin1=rotspin*Spin;
end
