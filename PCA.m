

%load the data with GUI
[sFile1, sPath1] = uigetfile('*.mat', 'Select matlab data file');
sFullFile1 = fullfile(sPath1, sFile1);
load(sFullFile1);


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
plot(mMidden(:,1), mMidden(:,2), 'mo', ...
    mBeachCC(:,1), mBeachCC(:,2), 'b+', ...
    mBeachCNG(:, 1), mBeachCNG(:, 2), 'g+', ...
    mDuneCC(:, 1), mDuneCC(:,2), 'b^', ...
    mDuneCNG(:, 1), mDuneCNG(:, 2), 'g^');
    hold on
    xlabel('Principal Component 1')
    ylabel('Principal component 2')
    title('2 Main Principal Components')
    legend2D = legend('Midden', 'Beach at CC', 'Beach at CNG',...
        'Dune at CC', 'Dune at CNG');
    set(legend2D,...
    'Position',[0.148214285714286 0.707936507936508 0.230357142857143 0.196825396825397]);
    hold off

%3D plot of 
figure('Color', 'white');
plot3(mMidden(:,1), mMidden(:,2), mMidden(:,3), 'mo', ...
    mBeachCC(:,1), mBeachCC(:,2), mBeachCC(:,3), 'b+', ...
    mBeachCNG(:,1), mBeachCNG(:,2), mBeachCNG(:,3), 'g+', ...
    mDuneCC(:,1), mDuneCC(:,2), mDuneCC(:,3), 'b^', ...
    mDuneCNG(:,1), mDuneCNG(:,2), mDuneCNG(:,3), 'g^');
    hold on
    xlabel('Principal Component 1')
    ylabel('Principal component 2')
    zlabel('Principal Component 3')
    title('First Three Principal Components')
    legend('Midden', 'Beach at CC', 'Beach at CNG',...
        'Dune at CC', 'Dune at CNG');
    hold off

%Separate out all dune and beach data (don't distiguish location)
mTrain = mData(vBeachDune ~= 0, : );
vClass = vBeachDune(vBeachDune ~= 0);

mMiddenData = mData(vMidden == 0, : );

cClass = cell(size(vClass));

for i = 1:length(cClass)
    if vClass(i) == 1
        cClass{i} = 'Beach';
    else 
        cClass{i} = 'Dune';
    end
end

fprintf('You are now ready to train a model with mTrain and cClass \n');
fprintf('than run mMiddenData through your model\n\n');
fprintf('Or, you can choose between the included models by running "Medel_PCA"');
fprintf(' script and selecting your chosen model when prompted.');
