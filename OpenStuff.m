%This script loads a data file of your choosing, then runs all the
%statistics you could ever want... if you want a finite number 
%of statistics


%Gives prompt asking what the variable being analyzed is
xAxis = input('What type of data is this? AKA what should the x-axis be'...
    ,'s');

% Create dialog box to find file first data set
[sFile1, sPath1] = uigetfile('*.txt', 'Select first data file');

%gives a promt asking what the name of data set one is
sDataName1 = input('what is the name for this data set?' ...
    ,'s');

% put file parts together for complete file address
sFullFile1 = fullfile(sPath1, sFile1);

% load first dataset from sFullFile
vData1 = load(sFullFile1);

% Create dialog box to find file for the Second data set
[sFile2, sPath2] = uigetfile('*.txt', 'Select second data file');

%gives a promt asking what the name of data set two is
sDataName2 = input('what is the name for this data set?' ...
    ,'s');

% put file parts together for complete file address
sFullFile2 = fullfile(sPath2, sFile2);

% load first dataset from sFullFile
vData2 = load(sFullFile2);


% Now begins the horrid day of looking at statistics

% calculate statisics of the first data set
dMean1 = mean(vData1);
dMedian1 = median(vData1);
dMode1 = mode(vData1);
dSD1 = std(vData1);
dVariance1 = var(vData1);
dSkewness1 = skewness(vData1);
dKurtosis1 = kurtosis(vData1);

% calculate the statisics of the second data set
dMean2 = mean(vData2);
dMedian2 = median(vData2);
dMode2 = mode(vData2);
dSD2 = std(vData2);
dVariance2 = var(vData2);
dSkewness2 = skewness(vData2);
dKurtosis2 = kurtosis(vData2);

% Plot histograms of each data sets with appropriate title and axis labels
f1 = figure('Color', 'white');
h1 = histogram(vData1);
    ax1 = gca;
    xlabel(xAxis, 'FontWeight','bold','FontSize', 14);
    ylabel("Number",'FontWeight','bold', 'FontSize', 14);
    title(sDataName1, 'FontWeight', 'bold','FontSize', 18);

f2 = figure('color', 'white');
h2 = histogram(vData2); 
    ax2 = gca;
    ax2.FontSize = 18;
    xlabel(xAxis, 'FontWeight','bold','FontSize', 14);     
    ylabel("Number", 'FontWeight','bold','FontSize', 14);   
    title(sDataName2, 'FontWeight', 'bold', 'FontSize', 18);
    

%print the statitis with an explaination, such as Mean = 2.34E 56
%I can get something to print the string "Mean =", and something else to
%print the sientific notation, but how do you print them together?

% Prints the statisics for the first data set
fprintf('\n -- Statistics for %s are printed below --\n', sDataName1)
fprintf("Mean = %.2E\n", dMean1)
fprintf("Median = %.2E\n",dMedian1)
fprintf("Mode = %.2E\n",dMode1)
fprintf("Standard Deviation = %.2E\n",dSD1)
fprintf("Variance = %.2E\n",dVariance1)
fprintf("Skewness = %.2E\n",dSkewness1)
fprintf("Kurtosis = %.2E\n\n",dKurtosis1)

% Prints the statisics for the second data set
fprintf('-- Statistics for %s are printed below --\n', sDataName2)
fprintf("Mean = %.2E\n",dMean2)
fprintf("Median = %.2E\n",dMedian2)
fprintf("Mode = %.2E\n",dMode2)
fprintf("Standard Deviation = %.2E\n",dSD2)
fprintf("Variance = %.2E\n",dVariance2)
fprintf("Skewness = %.2E\n",dSkewness2)
fprintf("Kurtosis = %.2E\n",dKurtosis2)

% This saves the values as a .MAT file in the same folder as the
% data
sSavePath = [sPath1, xAxis, '_analysis'];
save(sSavePath);

