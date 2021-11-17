%load the models with GUI
[sFile1, sPath1] = uigetfile('*.mat', 'Select "Models.mat" file');
sFullFile1 = fullfile(sPath1, sFile1);
load(sFullFile1);

%asks user which type of model they would like to use
sIndex = input('would you like to use "Neural-Network", "Bagged-Trees", or "KNN"?');

%Set up switch case based on model chosen
switch sIndex
    case 'Neural-Network'
        yfit = TrilayeredNeuralNetwork.predictFcn(mMiddenData);

    case 'Bagged-Trees'
        yfit = EnsambleBaggedTrees.predictFcn(mMiddenData);

    case 'KNN'
        yfit = WeightedKNN.predictFcn(mMiddenData);

    otherwise 
        error('wrong spelling for sIndex. Options are Neural-Network, Bagged-Trees, KNN')
end

%Results of number of beach and dune
numBeach = count(yfit,'Beach');
numDune = count(yfit,'Dune');

%output predicted result from the model
if numBeach > numDune
    guess = 'Beaches';
else
    guess = 'Dunes';
end

%Messages for the reader to understand model results
fprintf('This model predicts ');
fprintf(guess);
fprintf(' as the correct answer\n');
fprintf('see "numBeach" and "numDune for results"\n')