function [vFrequency, vPower, vTimelin] = mlvcy1(vData, vTime, sIndex)

% This function will preform both autospectal and cross-spectral analysis
% to look at periodicity in oxygen isotope data and summer insolation at
% 65°N latitude. Please read documentation on how to properly use this
% function.

%interpolate data to make it evenly spaced in time, without changing total
%# of data points.
vTimelin = linspace(min(vTime),max(vTime),length(vTime));
vInData = interp1(vTime, vData, vTimelin);

%this section will detrend data
vDtData = detrend(vInData);
dSamFreq = 1/(vTimelin(2) - vTimelin(1));


%this section will calculate the power spectrum of the type indicated, and
%plot it
    %note: the plot should be adjusted so that you only focus on important
    %peaks

    
switch sIndex
    case 'Blackman-Tukey'
        
        % produce the autospectrum
        dNPT = 2^nextpow2(length(vInData)); 
        [vPower, vFrequency] = periodogram(vDtData,[], dNPT, dSamFreq);
%plot and adjust the axis to show relevant information
        figure('color', 'white')
            plot(vFrequency, vPower), grid
            dMaxPower = max(vPower);
            vHighPower = find(vPower >= dMaxPower/100);
            iLastHigh = vHighPower(end);
            dXLim = vFrequency(iLastHigh) + (0.1 * vFrequency(iLastHigh));
            xlim([0, dXLim]);
            xlabel('Frequency')
            ylabel('Power')
            title('Auto-Spectrum')

            
    case 'wavelet'
        % Does wavelet analysis on the data
        [mWT, vFrequency] = cwt(vDtData, 'amor', dSamFreq);
       
        % Will createfigure of the wavelet analysis
        figure('position', [100 300 800 300],... 
            'Color',[1 1 1]); ...
        contour(vTimelin,vFrequency,abs(mWT), ...
            'LineStyle', 'none',...
            'LineColor', [0 0 0],...
            'Fill', 'on')
        xlabel ('time(kyr)')
        ylabel('Frequency(1/kyr)')
        title('Wavelet Power Spectrum')
        
        % determine a good ending place for the chart
        vMaxMatrix = max(abs(mWT));
        dMaxPower = max(vMaxMatrix);
        dHighFcell = find(vFrequency >= dMaxPower/10, 1, 'last');
        dLimFrequency = vFrequency(dHighFcell) + (0.2 * vFrequency(dHighFcell));
        %finish setting up the apearence fo the graph
        set(gcf, 'Colormap', jet)
        set(gca, 'XLim', [0 vTimelin(end)],...
            'YLim', [0.005 dLimFrequency],...
            'XGrid', 'On',...
            'YGrid', 'On')
        colorbar

    otherwise 
        error('your sIndex variable was wrong. please check spelling and try again')
end