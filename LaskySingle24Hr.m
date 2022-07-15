function [empty] = LaskySingle24Hr(hourlyMatrix,hourlyTable,fileNameEDF,useTSV)

% Works with DannyDelta_v6.m to produce 24-hour graphs of both delta power
% and gamma power. If a TSV is present graphs will be produced for all
% sleep states, wake, NREM, and REM. If no TSV is present, the graphs will
% simply include all epochs not deemed artifact via the Z-score filter.

% Finalized 7/11/2022, Danny Lasky

if useTSV == 1
    runColumns = [3,6,9,12];
    gammaAdd = 12;
elseif useTSV == 0
    runColumns = 3;
    gammaAdd = 3;
end
    
for m = runColumns

n = m + gammaAdd;

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1 0.1 0.8 0.8]);    % Plots delta power
subplot(2,1,1)
plot(1:24,hourlyMatrix(:,m),'LineWidth',1.5);
graphTitle = strrep(fileNameEDF,'_',' ');
title(graphTitle, 'FontSize', 22)
xlabel('Zeitgeber Time (h)', 'FontSize', 16);
ylabel(hourlyTable.Properties.VariableNames{m}, 'FontSize', 16);
xlim([0.5,24.5]);
ylim tight

yLimit = get(gca,'YLim');
x = [0.5 12.5 12.5 0.5];            % Yellow box for lights-on hours
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'y','FaceAlpha',0.1)
x = [12.5 24.5 24.5 12.5];          % Gray box for lights-off hours
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'k','FaceAlpha',0.1)

subplot(2,1,2)                                      % Plots gamma power
plot(1:24,hourlyMatrix(:,n),'LineWidth',1.5);
xlabel('Zeitgeber Time (h)', 'FontSize', 16);
ylabel(hourlyTable.Properties.VariableNames{n}, 'FontSize', 16);
xlim([0.5,24.5])
ylim tight

yLimit = get(gca,'YLim');
x = [0.5 12.5 12.5 0.5];            % Yellow box for lights-on hours        
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'y','FaceAlpha',0.1)
x = [12.5 24.5 24.5 12.5];          % Gray box for lights-off hours
y = [yLimit(1,1) yLimit(1,1) yLimit(1,2) yLimit(1,2)];
patch(x,y,'k','FaceAlpha',0.1)

saveas(gcf, strcat('DG_',hourlyTable.Properties.VariableNames{m},'_',hourlyTable.Properties.VariableNames{n},'.png'))

end

empty = [];
