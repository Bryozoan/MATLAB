% This is for Part two of lab one geodata analysis class.
%__ This code will preform various statistical tests to determine if two
%samples of univariate data are from the same population.


%this is a random string variable describing test statistics
sExpl = 'If the Test stat is 0 you fail to reject the null hypothesis';
sLill = 'The null hypothesis for the lillifor test is that the population came from a normally distributed population';

%gives a prompt asking which data set to open matlab file
[sFileML, sPathML] = uigetfile('*.mat', 'Select matlab analysis file');

%preforms a lilliefor test to see if it is reasonable to assume a normal
%distribution.
[dTestStat1, dPValue1] = lillietest(vData1);
[dTestStat2, dPValue2] = lillietest(vData2);

%preform a two sample t-test at the 95% confidence level, also reports
%p-value
[dTTestStat, dPValTT] = ttest2(vData1, vData2);

%preforms a two sample KS test
[dKSStat, dKSPVal] = kstest2(vData1, vData2);

%Prints the values for teh statitics
fprintf('\n --Statistics for %s are printed below--\n', sFileML)
fprintf('p-value for %s lilliefor test = %.2d \n', sDataName1, dPValue1)
fprintf('p-value for %s lilliefor test = %.2d \n\n', sDataName2, dPValue2)
fprintf('%s lilliefor test statistic = %.2d \n',sDataName1, dTestStat1)
fprintf('%s lilliefor test statistic = %.2d \n',sDataName2, dTestStat2)
fprintf('--> %s \n ---> %s \n\n',sExpl, sLill)
fprintf('P-value for the Two sample T-Test = %d \n', dPValTT)
fprintf('The test stat for the two sample T-Test = %d \n\n', dTTestStat)
fprintf('The Kolmogrov-Smirnov P-value = %.2d \n', dKSPVal)
fprintf('The Kolmogrov-Smirnov test stat = %.2d \n --> %s \n', dKSStat, sExpl)

