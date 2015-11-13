function SPINDepOARrunner(inputdatafile)
%   SPINDepOARrunner(inputdatafile)
%   Detailed explanation goes here

load('inputGeneralfile.mat','fastring','OAM','nusp','freq','Coord','Spin','kickampl','nturns');

load(inputdatafile, 'partindex','outfilename');

for indnukick=1:length(freq)
%     disp(indnukick);
    [Pol_x(:,indnukick),Pol_y(:,indnukick),Pol_z(:,indnukick)]=...
        TrackSpinOrb(Coord(:,partindex),Spin(:,partindex),...
        nturns,freq(indnukick),kickampl,fastring,OAM,nusp);
end
save(outfilename,'Pol_x','Pol_y','Pol_z','freq','partindex');
end
