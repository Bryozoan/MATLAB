function varagout = climchg(vTemp, vTime, sIndex, varagin)
% this will asses cirtain climate data sets and so that correct
% understanding of what the climatae is doing can be asertained.
%varagin allows more inputs that you put anything in

%if sIndex == 'slope to target';   
%elseif sIndex == 'slope of interval'    
%elseif sIndex == 'trend since 1970';
%else 
%    fprintf('climchg function needs a valid imput for sIndex')
 %   fprintf('otherwise it will print all data from 1850')
  %  fprintf('the following are valid options for sIndex in climchg')
   % fprintf('slope to target\slope of interval\trend since 1970')
%end



switch sIndex
    case 'slope to target'
        %find target date
        dTarget = varagin{1};
        %dDate = find(vTime==dTarget);
        iElNum = find(abs(vTime - dTarget) == min(abs(vTime - dTarget)), 1);
        %cut off data after target date
        vTiCut = vTime(1:iElNum);
        vTempCut = vTemp(1:iElNum);
        
        %preallocating memory
        vStartTime = zeros(length(vTiCut) - 4, 1);
        vSlope = zeros(length(vTiCut) - 4, 1);
        vUB = zeros(length(vTiCut) - 4, 1);
        vLB = zeros(length(vTiCut) - 4, 1);
        
        for i = 1:length(vTiCut) - 4
            [xData, yData] = prepareCurveData( vTiCut(i:end), vTempCut(i:end));
            
            ft = fittype('poly');

            [fitresult, gof] = fit(xData, yData, ft);

            %get the data out of variables 
            vCoeffs = coeffvalues(fitresult);
            mConfInt =  confint(fitresult);

            %assign data to output vectors

            vStartTime(i) = vTiCut(i);
            vSlope(i) = vCoeffs(1);
            vLB = mConfInt(1,1);
            vUB = mconfInt(2,1);
        end
        
        %plot data

    %below are the outputs for this case, make sure you call for 
    % 4 variables
        varagout(1) = vStartTime;
        varagout(2) = vSlope;
        varagout(3) = vUB;
        varagout(4) = vLB;

    case 'slope of interval'
        

    case 'trend since 1970'

    otherwise
        error('Your sIndex value is not supported')
        
        
end


end