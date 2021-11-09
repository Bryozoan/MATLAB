function [vResponseTime, vCohere, vNewTime, vFreqofCPSPeaks,...
    pxy, f] = mlvcy2(vTime1, vData1, vTime2, vData2)
%This function will compare two time series and produces a cross spectrum
%and phase spectrum. (it will only analyze over period that vectors have 
%in common)

%find out which time vector has the longest sampling period
dDif1 = mean(diff(vTime1));
dDif2 = mean(diff(vTime2));

%use the longer period as the new time
if dDif1 >= dDif2
    %vTimelin = linspace(min(vTime1),max(vTime1), length(vTime1));
    dDif = dDif1;
else 
    %vTimelin = linspace(min(vTime2),max(vTime2), length(vTime2));
    dDif = dDif2;
end

%determine the starting time of our new time vector
if vTime1(1) >= vTime2(1)
    dStartTime = min(vTime1);
else
    dStartTime = min(vTime2);
end

% determine the ending time of our new time vector
if vTime1(end) <= vTime2(end)
    dEndTime = max(vTime1);
else
    dEndTime = max(vTime2);
end

vNewTime = dStartTime:dDif:dEndTime;
vInData1 = detrend(interp1(vTime1, vData1, vNewTime));
vInData2 = detrend(interp1(vTime2, vData2, vNewTime));
dSamFreq = 1/(vNewTime(2) - vNewTime(1));

% run cross spectral analysis
dNPT = 2^nextpow2(length(vNewTime));
[pxy, f] = cpsd(vInData1, vInData2, [], 0, dNPT, dSamFreq);
%find peaks in the CPSD that are significant
[vPks, vLocs] = findpeaks(abs(pxy));
dAve = mean(pxy);
dSD = std(pxy);
dThreshold = dAve + (2*dSD);
vWantedPks = vPks > dThreshold;
%vPksAccepted = vPks(vWantedPks);
vFreqofCPSPeaks = vLocs(vWantedPks);

%plot the cross spectrum
figure('Color', 'white', 'Name', 'cross-spectral analysis' )
    plot(f, abs(pxy))
        xlabel('frequency')
        ylabel('Power')
        title('Cross-Spectral Analysis')

% phase spectrum analysis
phase = angle(pxy);
vPhaseAngle = phase(vFreqofCPSPeaks);
figure('Color', 'white', 'Name', 'phase spectrum analysis')
    plot(f,phase), grid
    xlabel('Frequency')
    ylabel('Phase Angle')
    title('Phase Spectrum')
hold on
stem(f(vFreqofCPSPeaks), vPhaseAngle, 'Color', 'red')
hold off
%calculation with the phase angle
vf = f(vWantedPks);
vPeriod = 1./vf;
vResponseTime = ((vPhaseAngle)/(2*pi)) .* vPeriod;

% Coherence analysis and plotting
[Cxy,f] = mscohere(vInData1,vInData2,[],0,dNPT,dSamFreq);
vCohere = Cxy(vFreqofCPSPeaks);
figure("Name", 'Coherence', 'Color', 'white')
plot(f,Cxy), grid
    xlabel('Frequency')
    ylabel('Coherence')
    title('Coherence')
hold on
    stem(f(vFreqofCPSPeaks), vCohere)
hold off
