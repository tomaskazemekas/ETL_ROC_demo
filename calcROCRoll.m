%% Calculating ROC of ETFs rolling in selected holding periods.

% Getting the number of periods in the historical data. 
symbols = fields(WeeklyContFTS);
firstSymb = symbols{1};
numPeriods = numel(WeeklyContFTS.(firstSymb).dates);


% Rollinf the ROC calculations for all the ETFs and all backtest periods.
fprintf('Starting rolling ROC calculation for %d weeks. \n', numPeriods);
fprintf('First %d weeks are left for Sharpe Ratio calculation . \n', indWinW);
fprintf('Period increase step is equal to holding period of %d weeks. \n', holdWinW);

for t=indWinW:holdWinW:numPeriods
    
    calculateROC;
    
    % Saving the output in a cell array.
    ROCRoll{t} = ETFROCRoll;
    
    % Outputting the period finishing statement.
    fprintf('ROC for week %d out of %d calculated. \n', t, numPeriods);
    
end

%Outputting the process finishing statement.
fprintf('Rolling ROC for all holding periods calculated. \n');
