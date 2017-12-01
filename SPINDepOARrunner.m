function SPINDepOARrunner(generalinputfile, specinputfile)
%   SPINDepOARrunner(inputdatafile)
%   Detailed explanation goes here

load(generalinputfile,'fastring','OAM','nusp','freq','Coord','Spin','kickampl','nturns');

load(specinputfile, 'partindex','outfilename');
Coord_temp=Coord(:,partindex);
Spin_temp=Spin(:,partindex);
for indnukick=1:length(freq)
%     disp(indnukick);
    [Pol_x(:,indnukick),Pol_y(:,indnukick),Pol_z(:,indnukick),...
        Coord_temp,Spin_temp]=...
        TrackSpinOrb(Coord_temp,Spin_temp,...
        nturns,freq(indnukick),kickampl,fastring,OAM,nusp);
end
save(outfilename,'Pol_x','Pol_y','Pol_z','freq','partindex');
end
