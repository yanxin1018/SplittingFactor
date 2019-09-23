%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This simple script reads csv file of a IR spectrum, 
% plots the spectrum, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%% get data
NUMSP=4; % number of spectra
filename={'pigeonSHV1-3rd.csv';...
    'pigeonSD4-3rd.csv';...
    'pigeonZG6-3rd.csv';...
    'pigeonKSE7-3rd.csv'};
figure;
for i=1:NUMSP
    spaname=filename{i};% change the file name
    spectrum=xlsread(spaname);
    wavenumber=spectrum(:,1); % the 1st row is wavenumber
    absorbance=spectrum(:,2); % the 2nd row is absorbance
    maxA=max(absorbance);
    relatA=absorbance/maxA*(1/NUMSP-0.01)+(i-1)*(1/NUMSP-0.01);
    plot(wavenumber,relatA,'r','LineWidth',2);
    [SF,FW]=calculateSFnFW(spaname);   
    spashort=spaname(1:length(spaname)-4);
    txt=sprintf('%s, SF=%.4f, FWHM=%.2f',spashort,SF,FW);
    text(2900,max(relatA)-0.2/NUMSP,txt);
    hold on
end
%% adjustions
xlim([400,4000]);
ylim([0,max(relatA)+0.05]);
set(gca,'xdir','reverse'); % reverse the x axis
set(gca,'yTick',[]);
set(gca,'yTickLabel',[]);
xlabel('Wavenumbers (cm-1)');
ylabel('Absorbance (A.U.)');
hold off