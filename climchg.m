function varargout = climchg(vTemp, vTime, sIndex, varargin)
% this will asses cirtain climate data sets and so that correct
% understanding of what the climatae is doing can be asertained.
%varagin allows more inputs that you put anything in



    switch sIndex
        case 'slope to target'
            %find target date
            dTarget = varargin{1};
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
                
                ft = fittype('poly1');
    
                fitresult = fit(xData, yData, ft);
    
                %get the data out of variables 
                vCoeffs = coeffvalues(fitresult);
                mConfInt =  confint(fitresult);
    
                %assign data to output vectors
    
                vStartTime(i) = vTiCut(i);
                vSlope(i) = vCoeffs(1) * 10;
                vLB(i) = mConfInt(1,1) * 10;
                vUB(i) = mConfInt(2,1) * 10;
            end
        
            % set up variables for plotting
            %vTimePlot = vTiCut(1:end-4);
        
            
            %plot data
            plot(vStartTime, vSlope, 'blue')
            hold on;
            plot(vStartTime, vUB, 'red')
            plot(vStartTime, vLB, 'red')
            hold off;

            %change data labels
                xlabel('Date', 'FontSize', 10);
                sTitle = sprintf('slope to target, %.0f', dTarget);
                title(sTitle);            
                dIfVariable = vTime(2) - vTime(1);
                    if dIfVariable == 1
                        sYLabel = sprintf('Slope from date to %.0f (C° per decade)\n annual data',...
                            dTarget);
                    else 
                        sYLabel = sprintf('Slope from date to %.0f (C° per decade)\n monthly data',...
                            dTarget);                
                    end
                ylabel(sYLabel, 'FontSize', 10);


            %below are the outputs for this case, make sure you call for 
            %4 variables
            varargout{1} = vStartTime;
            varargout{2} = vSlope;
            varargout{3} = vUB;
            varargout{4} = vLB;
    
        case 'slope of interval'
            %find end target 
            dInterval = varargin{1};
            
            %adjust intervals accept month or year data
            if vTime(2) - vTime(1) > 0.9
                iWin = dInterval;
            elseif vTime(2) - vTime(1) < 0.9
                iWin = dInterval*12;
            end

            %set up place holders for variable made in folowing loop
            vSlope = zeros(length(vTime) - iWin + 1, 1);
            vUB = zeros(length(vTime) - iWin + 1, 1);
            vLB = zeros(length(vTime) - iWin + 1, 1);
            vEndTime = zeros(length(vTime) - iWin + 1, 1);
            vEndCell = zeros(length(vTime) - iWin + 1, 1);

            %Create slope for each interval
            for i = 1:length(vTime) - iWin + 1

                %Cut off after target date
                vTiCut = vTime(i:iWin + i - 1);
                vTempCut = vTemp(i:iWin + i - 1);

                %prepare the data for fit
                [vxData, vyData] = prepareCurveData(vTiCut, vTempCut);

                %Fit type defined as first order polynomial
                ft = fittype( 'poly1' );

                %Fit model to data
                [fitresult, gof] = fit( vxData, vyData, ft);
                %extract data
                vCoeffs = coeffvalues(fitresult);
                mConfInt = confint(fitresult);

                %assign data to output vectors                 
                vSlope(i) = vCoeffs(1) * 10;          
                vUB(i) = mConfInt(2,1) * 10;
                vLB(i) = mConfInt(1,1) * 10;
                %Set up the end date for each interval
                vEndCell(i) = iWin + i - 1;
                vEndTime(i) = vTime(vEndCell(i));


            end

            %set up output variables... this order is important for calling
            %them in the function 
            varargout{1} = vEndTime;
            varargout{2} = vSlope;
            varargout{3} = vUB;
            varargout{4} = vLB;

            %plot (slope) vs (end date) and Confedence interval lines
            plot(vEndTime, vSlope, 'blue')
            hold on;
            plot(vEndTime, vUB, 'red')
            plot(vEndTime, vLB, 'red')
            hold off;
            %change data labels
                xlabel('Date', 'FontSize', 10);
                sTitle = sprintf('slope of interval size %.0f',dInterval);
                title(sTitle);            
                dIfVariable = vTime(2) - vTime(1);
                    if dIfVariable == 1
                        sYLabel = sprintf('Slope of interval size %.0f, C° per decade\n (yearly data)',...
                            dInterval);
                    else 
                        sYLabel = sprintf('Slope of interval size %.0f, C° per decade\n (monthly data)',...
                            dInterval);                
                    end
                ylabel(sYLabel, 'FontSize', 10);


        case 'trend since 1970'
            %find 1970, calculate till end
            dElNum = find(abs(vTime - 1970) == min(abs(vTime - 1970)), 1);
            vTiCut = vTime(dElNum:end);
            vTempCut = vTemp(dElNum:end);
            
            % set up curve fitting function
            [vxData, vyData] = prepareCurveData(vTiCut, vTempCut);
            %set up linear fit
            ft = fittype( 'poly1' );
            %fit model to the data
            [fitresult, gof] = fit( vxData, vyData, ft );

            %plot data and fit
            figure( "Name", 'Trend Since 1970');
                plot(fitresult, vxData, vyData, 'predobs');
            %change data labels
                xlabel('Date', 'FontSize', 10);
                sTitle = sprintf('Trend Since 1970');
                title(sTitle);            
                dIfVariable = vTime(2) - vTime(1);
                    if dIfVariable == 1
                        sYLabel = sprintf('Average Annual Temperature');
                    else 
                        sYLabel = sprintf('Average Monthly Temperature');                
                    end
                ylabel(sYLabel, 'FontSize', 10);

            
            %fitting stats
            vCoeffs = coeffvalues(fitresult);
            mConfInt = confint(fitresult);     

            dSlope = vCoeffs(1);
            dIntercept = vCoeffs(2);
            vUB = mConfInt(2,1);
            vLB = mConfInt(1,1);
            
            %fprintf('slope is %.3G\n --> 95 percent confindence interval of [%.3G, %.3G]\n',dSlope,vUB,vLB);
            
            %below are the outputs for this case, make sure you call for 
            %4 variables
            varargout{1} = dIntercept;
            varargout{2} = dSlope;
            varargout{3} = vUB;
            varargout{4} = vLB;

        otherwise           
            error('Your sIndex value is not supported. Try one of the following: -slope to target-slope of interval-trend since 1970-');
                        
         
    end

 
end