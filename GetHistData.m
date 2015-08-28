%% Set Source and Parameters for Historical Data download 

clear; close all; clc

%% 1. Parameter: Data Source. Set source for historical data download (use ''):
% 'IB' for Interactive Brokers; !(Make sure IB TWS app is running on your PC)
% 'YF' for Yahoo Finance;

source = 'YF' ;


%% 2. Parameter: Duration. Set start date and end date for download.
% Now is today.
startdate = floor(now) - 1000;
enddate = floor(now);

% Read ETF data from ETFdata.xlsx file

ETFData = readtable('.\ETFData.xlsx');

% Saving ETFData table in a file.

save('ETFDataCont.mat', 'ETFData'); % File ETFDataCont.mat created.


% Set number of downloads
% If you want to test downloads with a smaller number of ETFs, 
% uncomment and set the number of downloads in a following line and comment
% out the next line (numDwnld = size(ETFdata, 1);
%numDwnld = 40; 
numDwnld = size(ETFData, 1);


% Switch operator for data download.

switch source
    case 'IB'
        ColumnNames = {'Date', 'Open', 'High', 'Low', 'Close', 'Vol', 'Bar Count', 'WAP', 'OI'};
        getETFHistoryIB;
    
    case 'YF'
        ColumnNames = {'Date', 'Open', 'High', 'Low', 'Close', 'Vol', 'Adj Close'};
        getETFHistoryYF;
end



% Wrapping up

fprintf('Done.  \n');

fprintf('The data is saved in ETFDataCont.mat file.  \n');
