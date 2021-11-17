function [guess, numBeach, numDune]  = prediction(mMiddenData, model, sIndex)

    
    switch sIndex
        case 'Neural-Network'
            yfit = model.predictFcn(mMiddenData);
    
        case 'Bagged-Trees'
            yfit = model.predictFcn(mMiddenData);
    
        case 'KNN'
            yfit = model.predictFcn(mMiddenData);
    
        otherwise 
            error('wrong spelling for sIndex. Options are Neural-Network, Bagged-Trees, KNN')
    
    end
    
    numBeach = count(yfit,'Beach');
    numDune = count(yfit,'Dune');
    
    if numBeach > numDune
        guess = 'Beach';
    else
        guess = 'Dune';
    end

end