%% Script accepts parameter settingd for holding period, portfolio asset type 
% proportions and runs all the functions for rolling ROC calcualtion and 
% portfolio optimisation.

% Clearing the workspace and the memmory for the new roll.
clear; close all; clc

%% Set Parameters.

%% 1. Parameter. Select data file. By default it is ETFDataCont.mat but some other
% can be set too.

datafile = 'ETFDataCont.mat';
load(datafile);

%% 2. Parameter: Select number of assets from each type.  
% Top ETF from each type are ranked by selected ROC method.
fixedIncome = 2;
equity = 4;
commodity = 1;
currency = 1;

%% 3. Setting maximum limit of Fixed Income type group in the portfolio. 
% (Total sum of portfolio asets weights = 1.0).
FImaxLimit = 0.4;

%% 4. Seeting asset holding period in weeks.
holdWinW = 2; 

%% 5. Parameter: Setting timeframe for Sharpe Ratio calculations.
% Time horizon can be set in weeks. 
% The period is taken from the beginning of available hitorical data and is
% rooling after each holding period.
indWinW = 26 ;

%% 6. Parameter. Setting risk free rate. 
% Default is 1 year US T-bill rate of 0.1 percent.

risk0 = 0.1 ; % Set the rate in percent.

risk0 = risk0 / 100; % Converting the rate to decimal.

%% 7. Parameter. Set Initial investment sum.
investStart = 100000;

%% End of Parameter setting.


%% Calculating ROC roll for all periods and assets.
calcROCRoll;

%% Separating ETFs by type and sorting by ROC indicator.
separateNsort;

%% Getting top ETFs by type for rolling portfolios  

portROCraw = []; %Resetting the ROC data array.

for t=indWinW:holdWinW:numPeriods
    
    getTopETFbyType;
    
end

fprintf('Set number of top assets from each type are ready for portfolio optimisation. \n');


%% Extracting selected asset historical data and constucting
% financial time series.

% The holding period fints takes holding period starting week 
% Friday close prices as assset buying prices and ending week Friday close prices
% as selling prices.

for t=indWinW:holdWinW:numPeriods
    
    fintsConstructRoll;
    
end

fprintf('Financial time series of porfolio assets ready.  \n');

%% Trimming fints for rolling holding periods.
% Fints used for periodic held portfolio returns calculation.

% Adjusting the end of fints roll for the last holding period.
numPeriodsHold = numPeriods - holdWinW;

for t=indWinW:holdWinW:numPeriodsHold
    
    fintsConstrHoldRoll;
    
end

fprintf('Financial time series of holding periods ready.  \n');


%% Adding dates to top asset period ROC array .
portROCraw = [portStatsA(:, 1), portROCraw];

nzi = find(portROCraw(:,1));
portROCraw = portROCraw(nzi,:);

% Calculating ROC mean.
ROCmat = portROCraw(:, 2:end);
ROCmean = mean(ROCmat, 2);


%% Calculating portfolio with maximum Sharpe Ratio.
for t=indWinW:holdWinW:numPeriods

    calcMaxSharpePortRoll;
    
    fprintf('Portfolio with max Sharpe ratio for week %d out of %d calculated.\n', t, numPeriods );

end

fprintf('Portfolios with max Sharpe ratio all periods calculated.\n');

% Removing empty lines from statistics array.
portStatsAnz = portStatsA(nzi,:);

portStatsAnz = [portStatsAnz, ROCmean];

dates = datestr(portStatsAnz(:,1));


% Creating table of Statistics for roliing portfolios.
portStatsTable = array2table(portStatsAnz, 'VariableNames', {'Date', 'Max_Sharpe_Ratio_Yearly', 'Return_Yearly_Prc', 'Volatility_Prc', 'ROC'});

% Gettting dates ready in readable format.

portStatsTable.Date = dates;

fprintf('The asset weights of all portfolios can be seen in PortfolioTableRoll.\n' );
fprintf('The statistical data for all portfolios can be seen in portStatsTable.\n' );


%% Calculating daily portfolio returns.

for t=indWinW:holdWinW:numPeriodsHold
    
    calcPortRetPeriodic;
    
end

fprintf('Periodic portfolio returns calcualted.  \n');


%% Plotting the results in 2D and 3D graphs.
plot2d3d;

fprintf('2D and 3D graphs of portfolio statistics are ready in Figures 1 to 8.\n' );

%% Saving the data and results in .mat file.
save('PortforlioCont.mat');

fprintf('The data is saved in PortfolioCont.mat file.\n');

