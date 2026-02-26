function SPINDepOARrunner(inputdatafile)
%   SPINDepOARrunner(inputdatafile)
%   Detailed explanation goes here

load('./inputGeneralfile.mat','fastring','OAM','nusp','freq','Coord','Spin','kickampl','nturns');

a=load(inputdatafile, 'partindex','outfilename');
Coord_temp=Coord(:,a.partindex);
Spin_temp=Spin(:,a.partindex);
for indnukick=1:length(freq)
%     disp(indnukick);
    [Pol_x(:,indnukick),Pol_y(:,indnukick),Pol_z(:,indnukick),...
        Coord_temp,Spin_temp]=...
        TrackSpinOrb(Coord_temp,Spin_temp,a.partindex,...
        nturns,freq(indnukick),kickampl,fastring,OAM,nusp);
end
partindex=a.partindex;
save(a.outfilename,'Pol_x','Pol_y','Pol_z','freq','partindex');
if a.partindex==1
    CollectSPINDepOARData(pwd,[],0);
end

end
