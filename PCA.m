

%load the data with GUI
%[sFile1, sPath1] = uigetfile('*.mat', 'Select matlab data file');
%sFullFile1 = fullfile(sPath1, sFile1);
%mData = load(sFullFile1);
 
%z-score the data
mDataZ = zscore(mData);

%Calculates and displays in a plot a correlation matrix among the variables.
mCorrCo = corrcoef(mDataZ);
mCorrCo = flipud(mCorrCo);
heatmap(mCorrCo,...
    'Title', 'Correlation Mattrix',...
    'XDisplayLabels', cLabels,...
    'YDisplayLabels', flipud(cLabels));

%preform Principal Component analysis on data
[mPCeq,mScore,vVariance,~,vExplained] = pca(mDataZ);

% separat out the midden sands
mMidden = mScore(vMidden == 0, : );
% Separate out the beaches at CC
mBeachCC = mScore(vBeachDune == 1 & vMidden == 1, : );
% Separate out the Beach sand at CNG
mBeachCNG = mScore(vBeachDune == 1 & vMidden == 2, : );
% Separate out dune sands at CC
mDuneCC = mScore(vBeachDune == 2 & vMidden == 1, : );
% Separate out dune sands at CNG
mDuneCNG = mScore(vBeachDune == 2 & vMidden == 2, : );


%2D plot of PC2 vs PC1 distiguishing catagories 
figure('Color', 'white');
plot(mMidden(:,1), mMidden(:,2), ...
    'bo', mBeachCC(:,1), mBeachCC(:,2), 'gx', ...
    mBeachCNG(:, 1), mBeachCNG(:, 1), 'mx', ...
    mDuneCC(:, 1), mDuneCC(:,2), '^g', ...
    mDuneCNG(:, 1), mDuneCNG(:, 2), '^m');
%3D plot of 
%figure('Color', 'white');
%plot3()