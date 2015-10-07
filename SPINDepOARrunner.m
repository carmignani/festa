function SPINDepOARrunner(inputdatafile)
%   SPINDepOARrunner(inputdatafile)
%   Detailed explanation goes here

load('inputGeneralfile.mat','fastring','OAM','nusp','freq','Coord','Spin','kickampl','nturns');

load(inputdatafile, 'partindex','outfilename');

for indnukick=1:length(freq)
    disp(indnukick);
    Pol(:,indnukick)=TrackSpinOrb_KickerPassMethod(Coord(:,partindex),Spin(:,partindex),...
        nturns,freq(indnukick),kickampl,fastring,OAM,nusp);
end

save(outfilename,'Pol','freq','partindex');
end
