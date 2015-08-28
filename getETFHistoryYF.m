% Helper script that activated by main scrtipt GetHistoricalData,
% get parameters from there. It downloads historical data from Yahoo Finance and
% saves the data in a .mat file
%
% By Tomas Kazemekas, 2014 06
% Email: tomaskazemekas@gmail.com

% Creating Historical Data Download Status array. Value 1 will
% mean OK, value 0 - Not Available.
HDStatus = zeros(size(ETFData, 1), 1);

% Change Source column to 'Yahoo' 
replsource = repmat('Yahoo', size(ETFData ,1),  1);
ETFData.Source = replsource;


% Create Data Container

ETFDataContYF = struct; 


% Starting download of ETF Data from Yahoo Finance, one position at a time,
% one connection at a time, as stated in specification.

count = 0;

for i=1:numDwnld

    symb = ETFData.Symbol{i};
            
    fprintf('Trying to download %s ...\n', symb);
    
    try
      conn = yahoo;
      d = fetch(conn, symb, startdate, enddate);
    catch ME
      fprintf('Unable to download data for %s. Continuing \n', symb);
      continue
    end
    
    close(conn);
    clear conn;
    
    % Converting downloded data matrix to dataset 
    
    if size(d, 2) == 7
      d = mat2dataset(d, 'VarNames', ColumnNames);
      ETFDataContYF.(symb) = d;
      HDStatus(i) = 1;
      fprintf('Download: OK \n');
    else
      fprintf('Registering download status: Not Available \n');
    end  
            
    fprintf('Tried downloads %d out of %d ETF ...\n', i, numDwnld);
    
    count = count + 1;
    if count < 50
        continue
    else
        fprintf( 'Pausing for 1 min after a block of 50 symbols download ...\n'); 
        countdownTimer(60); % Pausing for 60 sec.
        count = 0; % Reseting counter.
    end     
end

% Wraping up

fprintf('Download from Yahoo Finance done. \n');

% Adding Historical Data Download Status as ETFData column
ETFData.HDStatus = HDStatus;

% Saving data container in .mat file.
save('ETFDataCont.mat', 'ETFDataContYF', 'ETFData', '-append');


% Getting and printing out the number of successful downloads.
HDpos = sum(HDStatus);
fprintf('Succesfull downloads: %d out of %d \n', HDpos, numDwnld);



