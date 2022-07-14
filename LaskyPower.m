function [avgMagArr,signalMax,signalMin,signalStd] = LaskyPower(normSignal,epochPts,fs)

% Quantify delta, theta, sigma, and gamma power for each epoch via Jones's method.
% Finalized 7/11/2022, Danny Lasky

deltaRange = [0.5 4];   % Defines bandpower frequency ranges
thetaRange = [6 9];   
sigmaRange = [10 14];   
gammaRange = [30 70];

bandRanges = [deltaRange; thetaRange; sigmaRange; gammaRange];
bandNames = {'Delta', 'Theta', 'Sigma', 'Gamma'}.';
bandCount = length(bandNames);

signalMax = max(normSignal);    % Prepares additional measurements of max, min, and std
signalMin = min(normSignal);
signalStd = std(normSignal);

epochCount = 0;
currPt = 1;
lastPt = length(normSignal);

freqBins = (0:epochPts-1);
freqHz = freqBins*fs/epochPts;
ssPSD = ceil(epochPts/2);

while currPt+epochPts-1 <= lastPt
    currEpoch = normSignal(currPt:currPt + epochPts-1,:);   % Loop for calculating band powers for each epoch      
    freqAxis  = freqHz(1:ssPSD)';
    
    % Spectrum as computed in Sunogawa paper
    X_mags = abs(fft(currEpoch)).^2/length(currEpoch);          % Simple Power Spectrum
    X_mags = X_mags(1:ssPSD);

    % Get measures for separate bands
    for band = 1:bandCount
        rangeLims = bandRanges(band,:);
        indxs = find(freqAxis >= rangeLims(1) & freqAxis <= rangeLims(2));
        avgMag(band)            = mean(X_mags(indxs));
    end                   

    % Collate and package data for this epoch
    epochCount = epochCount + 1;
        for band = 1:bandCount
            avgMagArr(epochCount, band)  = avgMag(band);
        end

    currPt = currPt + epochPts;
end
