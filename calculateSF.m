%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This simple script reads csv file of a IR spectrum, 
% plots the spectrum, 
% plots the baseline, peaks a, b and valley c,
% plots the baseline, 1035 peak, and FWHM
% and calculates the splitting factor & FWHM.
% Just put the csv file in the same path as this script,
% change the variable 'filename', and click on "RUN".
% for more personalized settings about baseline, 
% simply change the values of SFL, SFR, FWL, FWR.
% Have fun!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%% get data
filename='chicken fresh-3rd.csv';% change the file name
spectrum=xlsread(filename);
wavenumber=spectrum(:,1); % the 1st row is wavenumber
absorbance=spectrum(:,2); % the 2nd row is absorbance
%% defining baseline
SFL=[740,760]; % feel free to change
% put the range of left point of baseline for splitting factor
% suggested range is [740, 760]
% make sure the number goes from small to big
SFR=[480,500]; % feel free to change
% put the range of right point of baseline for splitting factor
% suggested range is [480, 500]
% make sure the number goes from small to big
FWL=[1900,2000]; % feel free to change
% put the range of left point of baseline for 1035 peak
% suggested range is [1900, 2000]
% make sure the number goes from small to big
FWR=[400,500]; % feel free to change
% put the range of right point of baseline for 1035 peak
% suggested range is [400, 500]
% make sure the number goes from small to big

%% plot spectrum
figure;
plot(wavenumber,absorbance);
xlim([400,4000]);
ylim([0,max(absorbance)+0.05]);
set(gca,'xdir','reverse'); % reverse the x axis
xlabel('Wavenumbers (cm-1)');
ylabel('Absorbance');
hold on
%% find baseline
baselineStartRegion=find(wavenumber<SFL(2)&wavenumber>SFL(1));
[baselineStartA,posStart]=min(absorbance(baselineStartRegion));
baselineStartWN=wavenumber(baselineStartRegion(posStart));
% find the lowest point between 2 elements of SFL 
% set as the starting point of the baseline
baselineEndRegion=find(wavenumber<SFR(2)&wavenumber>SFR(1));
[baselineEndA,posEnd]=min(absorbance(baselineEndRegion));
baselineEndWN=wavenumber(baselineEndRegion(posEnd));
% find the lowest point between 2 elements of SFR
% set as the end point of the baseline
k=(baselineEndA-baselineStartA)/(baselineEndWN-baselineStartWN);
b=baselineEndA-k*baselineEndWN;
% k and b are parameters of the baseline function y=kx+b
% where y is absorbace, x is the wavenumber
plot([baselineStartWN,baselineEndWN],[baselineStartA,baselineEndA],'r-');
% plot the baseline between the 2 points
%% find peaks a and b
peakARegion=find(wavenumber<610&wavenumber>600);
[peakA,pospeakA]=max(absorbance(peakARegion));
peakAWN=wavenumber(peakARegion(pospeakA));
% find the highest point between 600 and 610 cm-1
% this is the peak a
peakBRegion=find(wavenumber<590&wavenumber>550);
[peakB,pospeakB]=max(absorbance(peakBRegion));
% find the highest point between 550 and 590 cm-1
% this is the peak b
peakBWN=wavenumber(peakBRegion(pospeakB));
plot([peakAWN,peakBWN],[peakA,peakB],'r*');
% put stars at peaks a and b
%% find valley c
valleyCRegion=find(wavenumber<600&wavenumber>560);
[valleyC,posvalleyC]=min(absorbance(valleyCRegion));
valleyCWN=wavenumber(valleyCRegion(posvalleyC));
% find the lowest point between 560 and 600 cm-1
% this is the valley c
plot(valleyCWN,valleyC,'r*');
% put a star at peaks c
%% calculate heights
baselineA=k*peakAWN+b;
HeightA=peakA-baselineA;
plot([peakAWN,peakAWN],[peakA,baselineA],'r');
% draw a vertical line from peak a to the baseline
% store the length to variable 'HeightA'
baselineB=k*peakBWN+b;
HeightB=peakB-baselineB;
plot([peakBWN,peakBWN],[peakB,baselineB],'r');
% draw a vertical line from peak b to the baseline
% store the length to variable 'HeightB'
baselineC=k*valleyCWN+b;
HeightC=valleyC-baselineC;
plot([valleyCWN,valleyCWN],[valleyC,baselineC],'r');
% draw a vertical line from valley to the baseline
% store the length to variable 'HeightC'
SF=(HeightA+HeightB)/HeightC; % calculate the splitting factor
comment=sprintf('Splitting Factor: %.4f',SF);
text(max(wavenumber)-200,max(absorbance),comment);% put the SF in the plot
%% find baseline for ph
baselinePhStartRegion=find(wavenumber<FWL(2)&wavenumber>FWL(1));
[baselinePhStartA,posPhStart]=min(absorbance(baselinePhStartRegion));
baselinePhStartWN=wavenumber(baselinePhStartRegion(posPhStart));
% find the lowest point between 2000 and 1900 cm-1
% set as the starting point of the baseline
baselinePhEndRegion=find(wavenumber<FWR(2)&wavenumber>FWR(1));
[baselinePhEndA,posPhEnd]=min(absorbance(baselinePhEndRegion));
baselinePhEndWN=wavenumber(baselinePhEndRegion(posPhEnd));
% find the lowest point between 400 and 500 cm-1
% set as the end point of the baseline
kPh=(baselinePhEndA-baselinePhStartA)/(baselinePhEndWN-baselinePhStartWN);
bPh=baselinePhEndA-kPh*baselinePhEndWN;
% k and b are parameters of the baseline function y=kx+b
% where y is absorbace, x is the wavenumber
plot([baselinePhStartWN,baselinePhEndWN],...
    [baselinePhStartA,baselinePhEndA],'g-');
% plot the baseline between the 2 points

%% find peak ph
peakPhRegion=find(wavenumber<1100&wavenumber>1000);
[peakPh,pospeakPh]=max(absorbance(peakPhRegion));
peakPhWN=wavenumber(peakPhRegion(pospeakPh));
% find the lowest point between 1000 and 1100 cm-1
% this is the peak ph
plot(peakPhWN,peakPh,'g*');
% put a star at peaks ph
baselinePh=kPh*peakPhWN+bPh;
HeightPh=peakPh-baselinePh;
plot([peakPhWN,peakPhWN],[peakPh,baselinePh],'g');
% draw a vertical line from ph peak to the baseline

%% find width
halfMax=HeightPh/2+baselinePh;
% calculate the half maxium
FWStartRegion=find(wavenumber<1050&wavenumber>800);
FWEndRegion=find(wavenumber>1050&wavenumber<1300);
% set the region for searching
FWStart=find(absorbance(FWStartRegion)<halfMax+0.005&...
    absorbance(FWStartRegion)>halfMax-0.005);
FWStartWN=wavenumber(FWStartRegion(FWStart(end)));
FWStartA=absorbance(FWStartRegion(FWStart(end)));
% find the start point of calculating FW
% is the biggest wavenumber around halfMax in the region
plot(FWStartWN,FWStartA,'g*');
% put a star at the beginning of FW
FWEnd=find(absorbance(FWEndRegion)<halfMax+0.005&...
    absorbance(FWEndRegion)>halfMax-0.005);
FWEndWN=wavenumber(FWEndRegion(FWEnd(1)));
FWEndA=absorbance(FWEndRegion(FWEnd(1)));
% find the start point of calculating FW
% is the smallest wavenumber around halfMax in the region
plot(FWEndWN,FWEndA,'g*');
% put a star at the end of FW
FW=FWEndWN-FWStartWN;
% calculate the FW at HM
plot([FWEndWN,FWStartWN],[FWEndA,FWStartA],'g');
% draw the horizontal line of FWHM
commentFW=sprintf('FWHM:%.4f',FW);
text(max(wavenumber)-200,max(absorbance)-0.05,commentFW);
% write FWHM on the plot
hold off