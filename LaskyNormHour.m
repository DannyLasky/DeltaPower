function [finalMatrix,finalTable,hourlyMatrix,hourlyTable,artDeltaSum,artGammaSum] = LaskyNormHour(epochLength, ...
    avgMagArr,sleepState,useTSV)

% Works with DannyDelta_v6.m to normalize the band power output, break into
% hourly sections and create full epoch and hourly output.

% Finalized 7/11/2022, Danny Lasky

%% Create filters for specific sleep states. If not using a TSV there is a separate loop after this one.
if useTSV == 1
wakeFilter = sleepState == 1;
NREMFilter = sleepState == 2;
REMFilter = sleepState == 3;
artifactFilter = sleepState == 0;

avgMagAll = avgMagArr;
avgMagAll((artifactFilter == 1),:) = NaN;   % Removes artifact from an all sleep state matrix

avgMagWake = avgMagArr;
avgMagWake((wakeFilter == 0),:) = NaN;  % Only keeps wake epochs

avgMagNREM = avgMagArr;
avgMagNREM((NREMFilter == 0),:) = NaN;  % Only keeps NREM epochs

avgMagREM = avgMagArr;
avgMagREM((REMFilter == 0),:) = NaN;    % Only keeps REM epochs

%% Break into individual arrays and normalize
deltaAvgAll  = avgMagAll(:,1);
deltaAvgWake = avgMagWake(:,1);     % Separates out delta power for each of the sleep states
deltaAvgNREM = avgMagNREM(:,1);
deltaAvgREM  = avgMagREM(:,1);

gammaAvgAll  = avgMagAll(:,4);
gammaAvgWake = avgMagWake(:,4);     % Separates out gamma power for each of the sleep states
gammaAvgNREM = avgMagNREM(:,4);
gammaAvgREM  = avgMagREM(:,4);  

for n = 1:86400/epochLength
    deltaAvgN(n,1)     = deltaAvgAll(n,1)/sum(avgMagAll(n,2:4));       % New matrices for normalized delta by dividing by theta + sigma + gamma
    deltaAvgWakeN(n,1) = deltaAvgWake(n,1)/sum(avgMagWake(n,2:4));
    deltaAvgNREMN(n,1) = deltaAvgNREM(n,1)/sum(avgMagNREM(n,2:4));
    deltaAvgREMN(n,1)  = deltaAvgREM(n,1)/sum(avgMagREM(n,2:4));

    gammaAvgN(n,1)     = gammaAvgAll(n,1)/sum(avgMagAll(n,1:3));       % New matrices for normalized gamma by dividing by delta + theta + sigma
    gammaAvgWakeN(n,1) = gammaAvgWake(n,1)/sum(avgMagWake(n,1:3));
    gammaAvgNREMN(n,1) = gammaAvgNREM(n,1)/sum(avgMagNREM(n,1:3));
    gammaAvgREMN(n,1)  = gammaAvgREM(n,1)/sum(avgMagREM(n,1:3));
end

%% Remove epochs if 3 standard deviations outside mean (Z-score filter of 3)
artDeltaAll = (deltaAvgN - mean(deltaAvgN, 'omitnan'))/std(deltaAvgN, 'omitnan');
artDeltaWake = (deltaAvgWakeN - mean(deltaAvgWakeN, 'omitnan'))/std(deltaAvgWakeN, 'omitnan');
artDeltaNREM = (deltaAvgNREMN - mean(deltaAvgNREMN, 'omitnan'))/std(deltaAvgNREMN, 'omitnan');
artDeltaREM = (deltaAvgREMN - mean(deltaAvgREMN, 'omitnan'))/std(deltaAvgREMN, 'omitnan');

artGammaAll = (gammaAvgN - mean(gammaAvgN, 'omitnan'))/std(gammaAvgN, 'omitnan');
artGammaWake = (gammaAvgWakeN - mean(gammaAvgWakeN, 'omitnan'))/std(gammaAvgWakeN, 'omitnan');
artGammaNREM = (gammaAvgNREMN - mean(gammaAvgNREMN, 'omitnan'))/std(gammaAvgNREMN, 'omitnan');
artGammaREM = (gammaAvgREMN - mean(gammaAvgREMN, 'omitnan'))/std(gammaAvgREMN, 'omitnan');

for n = 1:21600
    if abs(artDeltaAll(n)) >= 3
        artDeltaAll(n) = 1;
    else
        artDeltaAll(n) = 0;
    end
    
    if abs(artDeltaWake(n)) >= 3
        artDeltaWake(n) = 1;
    else
        artDeltaWake(n) = 0;
    end
    
    if abs(artDeltaNREM(n)) >= 3
        artDeltaNREM(n) = 1;
    else
        artDeltaNREM(n) = 0;
    end       
    
    if abs(artDeltaREM(n)) >= 3
        artDeltaREM(n) = 1;
    else
        artDeltaREM(n) = 0;
    end       
    
    if abs(artGammaAll(n)) >= 3
        artGammaAll(n) = 1;
    else
        artGammaAll(n) = 0;
    end       
        
    if abs(artGammaWake(n)) >= 3
        artGammaWake(n) = 1;
    else
        artGammaWake(n) = 0;
    end      
    
    if abs(artGammaNREM(n)) >= 3
        artGammaNREM(n) = 1;
    else
        artGammaNREM(n) = 0;
    end      
    
    if abs(artGammaREM(n)) >= 3
        artGammaREM(n) = 1;
    else
        artGammaREM(n) = 0;
    end      
end

artDeltaSum = sum(artDeltaAll);     % Sums and displays delta power epochs removed
artGammaSum = sum(artGammaAll);     % Sums and displays gamma power epochs removed

disp(artDeltaSum)
disp(artGammaSum)

deltaAvgNA     = deltaAvgN;         % Creates matrices for the normalized and Z-score filtered delta and gamma powers
deltaAvgWakeNA = deltaAvgWakeN;
deltaAvgNREMNA = deltaAvgNREMN;
deltaAvgREMNA  = deltaAvgREMN;

gammaAvgNA     = gammaAvgN;
gammaAvgWakeNA = gammaAvgWakeN;
gammaAvgNREMNA = gammaAvgNREMN;
gammaAvgREMNA  = gammaAvgREMN;

for n = 1:21600
    if artDeltaAll(n) == 1
        deltaAvgNA(n) = NaN;
    end
    if artDeltaWake(n) == 1
        deltaAvgWakeNA(n) = NaN;
    end    
    if artDeltaNREM(n) == 1
        deltaAvgNREMNA(n) = NaN;
    end     
    if artDeltaREM(n) == 1
        deltaAvgREMNA(n) = NaN;
    end     
    if artGammaAll(n) == 1
        gammaAvgNA(n) = NaN;
    end
    if artGammaWake(n) == 1
        gammaAvgWakeNA(n) = NaN;
    end
    if artGammaNREM(n) == 1
        gammaAvgNREMNA(n) = NaN;
    end
    if artGammaREM(n) == 1
        gammaAvgREMNA(n) = NaN;
    end    
end

%% Create master matrix and table (N = normalized, NA = normalized and artifact removed)
finalMatrix = [deltaAvgAll,deltaAvgN,deltaAvgNA,deltaAvgWake,deltaAvgWakeN,deltaAvgWakeNA,deltaAvgNREM,deltaAvgNREMN, ...
    deltaAvgNREMNA,deltaAvgREM,deltaAvgREMN,deltaAvgREMNA,gammaAvgAll,gammaAvgN,gammaAvgNA,gammaAvgWake,gammaAvgWakeN, ...
    gammaAvgWakeNA,gammaAvgNREM,gammaAvgNREMN,gammaAvgNREMNA,gammaAvgREM,gammaAvgREMN,gammaAvgREMNA];
finalTable = array2table(finalMatrix,'VariableNames',{'Delta All','Delta All N','Delta All NA','Delta Wake','Delta Wake N', ...
    'Delta Wake NA','Delta NREM','Delta NREM N','Delta NREM NA','Delta REM','Delta REM N','Delta REM NA','Gamma All' ...
    'Gamma All N','Gamma All NA','Gamma Wake','Gamma Wake N','Gamma Wake NA','Gamma NREM','Gamma NREM N','Gamma NREM NA', ...
    'Gamma REM', 'Gamma REM N', 'Gamma REM NA'});

%% Find hourly band powers (N = normalized, NA = normalized and artifact removed)
hourlyEpochs = 3600/epochLength;

for j = 1:24
    for k = 1:24
        tempMatrix = finalMatrix(1+(k-1)*hourlyEpochs:k*hourlyEpochs,j);
        tempLength = length(tempMatrix(~isnan(tempMatrix)));
        if tempLength > 0
            hourlyMatrix(k,j) = mean(finalMatrix((1+(k-1)*hourlyEpochs:k*hourlyEpochs),j),'omitnan');
        elseif tempLength <= 0
            hourlyMatrix(k,j) = nan;
        end
    end
end

hourlyTable = array2table(hourlyMatrix,'VariableNames',{'Delta All','Delta All N','Delta All NA','Delta Wake','Delta Wake N', ...
    'Delta Wake NA','Delta NREM','Delta NREM N','Delta NREM NA','Delta REM','Delta REM N','Delta REM NA','Gamma All' ...
    'Gamma All N','Gamma All NA','Gamma Wake','Gamma Wake N','Gamma Wake NA','Gamma NREM','Gamma NREM N','Gamma NREM NA', ...
    'Gamma REM', 'Gamma REM N', 'Gamma REM NA'});
end

%% Option for no TSV
if useTSV == 0
    deltaAvg = avgMagArr(:,1);
    gammaAvg = avgMagArr(:,4);

    for n = 1:86400/epochLength
        deltaAvgN(n,1)     = deltaAvg(n,1)/sum(avgMagArr(n,2:4));   % New matrices for normalized delta by dividing by theta + sigma + gamma
        gammaAvgN(n,1)     = gammaAvg(n,1)/sum(avgMagArr(n,1:3));   % New matrices for normalized gamma by dividing by theta + sigma + gamma
    end

    artDelta = (deltaAvgN - mean(deltaAvgN, 'omitnan'))/std(deltaAvgN, 'omitnan');
    artGamma = (gammaAvgN - mean(gammaAvgN, 'omitnan'))/std(gammaAvgN, 'omitnan');

for n = 1:21600                 % Z-score filter of 3 for removing outliers
    if abs(artDelta(n)) >= 3
        artDelta(n) = 1;
    else
        artDelta(n) = 0;
    end
    
    if abs(artGamma(n)) >= 3
        artGamma(n) = 1;
    else
        artGamma(n) = 0;
    end
end

artDeltaSum = sum(artDelta);    % Sums and displays delta power epochs removed
artGammaSum = sum(artGamma);    % Sums and displays gamma power epochs removed

disp(artDeltaSum)
disp(artGammaSum)

deltaAvgNA = deltaAvgN;         % Creates matrices for the normalized and Z-score filtered delta and gamma powers
gammaAvgNA = gammaAvgN;

for n = 1:21600
    if artDelta(n) == 1
        deltaAvgNA(n) = NaN;
    end
    
    if artGamma(n) == 1
        gammaAvgNA(n) = NaN;
    end
end

%% Create master matrix and table (N = normalized, NA = normalized and artifact removed)
finalMatrix = [deltaAvg,deltaAvgN,deltaAvgNA,gammaAvg,gammaAvgN,gammaAvgNA];
finalTable = array2table(finalMatrix,'VariableNames',{'Delta','Delta N','Delta NA','Gamma','Gamma N','Gamma NA'});

%% Find hourly band powers (N = normalized, NA = normalized and artifact removed)
hourlyEpochs = 3600/epochLength;

for j = 1:6
    for k = 1:24
        tempMatrix = finalMatrix(1+(k-1)*hourlyEpochs:k*hourlyEpochs,j);
        tempLength = length(tempMatrix(~isnan(tempMatrix)));
        if tempLength > 45
            hourlyMatrix(k,j) = mean(finalMatrix((1+(k-1)*hourlyEpochs:k*hourlyEpochs),j),'omitnan');
        elseif tempLength <= 45
            hourlyMatrix(k,j) = nan;
        end
    end
end

hourlyTable = array2table(hourlyMatrix,'VariableNames',{'Delta','Delta N','Delta NA','Gamma','Gamma N','Gamma NA'});
end
