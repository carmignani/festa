function PlotDep( datafolder, string, export )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load([datafolder '/Results.mat']);

figure;
plot(nturns*(1:1000)/1000,AllPol)
grid on
xlabel('n turns');
ylabel('average vertical polarization');
title([ string ' - polarization versus time']);
if(export)
    mkdir imm
    export_fig('-transparent',['imm/PolTime_' string '.pdf'])
end
nfreq=length(freq);
FinPol=zeros(nfreq,1);
for i=1:nfreq
    FinPol(i)=mean(AllPol(900:1000,i));
end

figure;
plot(freq-(freq(ceil(nfreq/2))),FinPol,'*-');
grid on;
xlabel('nu kicker - nu centre');
ylabel('Final polarization');
title([ string ' - final polarization versus kicker frequency']);
if(export)
    export_fig('-transparent',['imm/FinPolFreq_' string '.pdf'])
end
end

