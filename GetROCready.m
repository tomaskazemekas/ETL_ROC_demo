%% Script accepts parameter settings and runs all the functions to prepare historical data for calcaulation of
% ROC of ETFs, separates them by type and ranks them by momentum.

%% Four parameters are also set in this script:
% 1. data file and data source container(Yahoo Finance or Interactive Brokers);
% 2. ROC periods;
% 3. back period ROC;
% 4. sorting ROC (set average ROC  or back period corrected ROC).

clear; close all; clc

%% 1. Parameter. Select data file. By default it is ETFDataCont.mat but some other can by
% set too.

datafile = 'ETFDataCont.mat';
load(datafile);

% Set the data container for calcualtions. It can by ETFDataContYF,
% ETFDataContIB of some new historical data container that was saved.

dataCont = ETFDataContYF;

% Converting historical data to Financial Time Series datatype.
convert2FinTimeSeries;

% Converting to weekly data. Only full weeks are taken. Weeks end on
% Friday.
convert2Weekly;

%% 2. Parameter. Set ROC Periods. Select ROC calcultion periods in weeks. Any number of weeks and combinations of
% week periods can be set. Setting [4, 8, 24] will gert ROC for 4, 8 and 24
% weeks. All four ROC series and the average will be calculated and
% displayed in ETFROC table.
% Warning! When selecting ROC periods, make sure that all the historical
% ETF data periods that you have are are longer than the longest selected
% ROC periods. Sometimes Interactive Brokers cuts the historical data short
% for some ETFs. Data for such incomplete ETFs will be eliminated from
% futher ranking.

rocPeriods = [4 8 24];

%% 3. Parmaeter. Set back period ROC in weeks. This ROC is subtracted from 
% the average ROC to get corrected ROC.

backPeriodROC = 4;

% Calculating ROC of all the ETFs.
%% DB calculateROConeP;

%% 4 Parameter. Select by which type of ROC the ETFs are ranked. 
% To sort by back period corrected ROC set ROCType to 'CorrectedROC',
% to sort by average ROC, to 'AverageROC'.
ROCType = 'CorrectedROC';

% Setting marker for ROC type

switch ROCType
    case 'CorrectedROC'
        ROCmark = 7;
    case 'AverageROC'        
        ROCmark = 5;
end

%% Saving all the settings in selected  .mat file. 
save(datafile);
% Outputting the finishing statement
fprintf('Data is ready for rolling ROC calculation & portfolio optimisation.  \n');

fprintf('Data is saved in %s file.\n', datafile);
