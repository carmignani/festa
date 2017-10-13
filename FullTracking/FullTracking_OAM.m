clear all; close all;
addpath('/mntdirect/_users/carmigna/ESRF/SPIN/festa/')
% load('../esrf.mat');

% ring=esrf;
ring=getESRF1;

RFVolt=9e6;
hnum=992;
E0=atenergy(ring);
gamma=E0/510998.93;
a=0.00115965218;
nusp=a*gamma;
% nusp=13.707;

radflag=1;
filename='neededvariables';
[~,~,~,OAM,~]=CreateFastRing_OAMThick_Sig_UseFullTracking(ring,RFVolt,hnum,nusp,filename,1,radflag,'.');
% [~,~,~,OAM_rot,~]=CreateFastRing_OAMThick_Sig(ring,RFVolt,hnum,nusp,filename,0,radflag);
load(filename);
% ring=ringrad;%atsetcavity(atradon(ring),9e6,1,992);
if radflag
    ring=ringrad;
else
    ring=ring;
end

%find all dipoles and quadrupoles (and sextupoles?)
indBendQuad=findcells(ring,'Class','Bend','Quadrupole','Sextupole');
indBendQuad=[indBendQuad length(ring)];
maskbend=atgetcells(ring(indBendQuad),'Class','Bend');
clorb=findorbit6(ring,1);
offset=[0.0002;0.000;0.0001;0.000;0.0001;0.0001];
z0=clorb+offset; 
z=z0;
s0=[sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];
s=s0;
nturns=10000;
tic
rotmattot1=eye(3);
sOAM_nt=zeros(3,nturns);
sFull_nt=zeros(3,nturns);
% sOAM_nt(:,1)=s0;
% sFull_nt(:,1)=s0;
spinnorm=zeros(1,nturns);
for ii=1:nturns;
    [z,rotmat,s]=Track1Turn_spinorbit(ringrad,z,s,nusp,indBendQuad,maskbend);
    rotmattot1=rotmat*rotmattot1;
    sFull_nt(:,ii)=rotmattot1*s0;
    spinnorm(ii)=norm(sFull_nt(:,ii));
end
toc
z1=z;
s1=s;
nukick=0;
ampkick=0;
RFVolt=9e6;
hnum=992;
% nusp=13.707;

tic
fastringrad(3)=[];
if radflag
    fastr=fastringrad;
else
    fastr=fastring;
end

clorb=findorbit6(fastr);
z_oam=clorb+offset;%z0;
s_oam=s0;

for ii=1:nturns
    [ Pol_x, Pol_y, Pol_z , z_oam, s_oam] = ...
        TrackSpinOrb_clorb( z_oam,s_oam,1,nukick,ampkick,fastr,...
        -OAM,nusp,clorb );
%     [ Pol_x, Pol_y, Pol_z , z_oam, s_oam] = ...
%         TrackSpinOrb_clorb( z0,s0,ii,nukick,ampkick,fastringrad,...
%         OAM_rot,nusp,clorb );
    sOAM_nt(1,ii)=s_oam(1);%Pol_x(end);%
    sOAM_nt(2,ii)=s_oam(2);%Pol_y(end);%
    sOAM_nt(3,ii)=s_oam(3);%Pol_z(end);%
end
toc

nuxFull=abs(fft(sFull_nt(1,:)));
nuxOAM=abs(fft(sOAM_nt(1,:)));
nuyFull=abs(fft(sFull_nt(2,:)-mean(sFull_nt(2,:))));
nuyOAM=abs(fft(sOAM_nt(2,:)-mean(sOAM_nt(2,:))));

figure;
plot((1:length(nuxFull))/length(nuxFull),nuxFull,'DisplayName','Full')
grid on; hold on;
plot((1:length(nuxOAM))/length(nuxOAM),nuxOAM,'DisplayName','OAM')
legend('Location','NorthEast');
xlabel('spin tune');
ylabel('fft of horizontal spin vector')

figure;
plot((1:length(nuyFull))/length(nuyFull),nuyFull,'DisplayName','Full')
grid on; hold on;
plot((1:length(nuyOAM))/length(nuyOAM),nuyOAM,'DisplayName','OAM')
legend('Location','NorthEast');
xlabel('spin tune');
ylabel('fft of vertical spin vector')

if nturns>1000
    to=1000;
else
    to=nturns;
end
figure;
subplot(3,1,1)
plot(sFull_nt(1,1:to),'DisplayName','Full')
hold on; grid on;
plot(sOAM_nt(1,1:to),'DisplayName','OAM')
legend('Location','NorthEast');
ylabel('xPol');
subplot(3,1,2)
plot(sFull_nt(2,1:to),'DisplayName','Full')
hold on; grid on;
plot(sOAM_nt(2,1:to),'DisplayName','OAM')
legend('Location','NorthEast');
ylabel('yPol');
subplot(3,1,3)
plot(sFull_nt(3,1:to),'DisplayName','Full')
hold on; grid on;
plot(sOAM_nt(3,1:to),'DisplayName','OAM')
legend('Location','NorthEast');
ylabel('zPol');

return;
sOAM_norot=[Pol_x(end);Pol_y(end);Pol_z(end)]
sFull=rotmattot1*s0
