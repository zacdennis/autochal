% CSV2TS Parses a Time History CSV file into a MATLAB timeseries structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% csv2ts:
%   Parses a time history CSV file into a MATLAB timeseries structure
%
% SYNTAX:
%	[Results] = csv2ts(filename, Results, varargin, 'PropertyName', PropertyValue)
%	[Results] = csv2ts(filename, Results, varargin)
%	[Results] = csv2ts(filename, Results)
%	[Results] = csv2ts(filename)
%
% INPUTS:
%	Name    	Size		Units           Description
%	filename	{'string'}  {[char]}        Can be either:
%                                           (1) Name of CSV file(s) to open
%                                           (2) Name of directories
%                                                containing .csv files to
%                                                open
%   Results     {struct}    [timeseries]    Structure of timeseries to add
%                                            new parsed data to
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
% OUTPUTS:
%	Name    	Size		Units           Description
%	Results     {struct}    [timeseries]    Parsed output in timeseries
%                                            format
%
% NOTES:
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'TimeColumn'        [int]           2           Column in CSV file
%                                                    containing simulation
%                                                    time
%   'RowStart'          [int]           2           Row with 1st timestep
%                                                    to retrieve (allows
%                                                    for skipping of
%                                                    header lines)
%   'flgVerbose'        [bool]          true        Show progress of
%                                                    function?
%   'SignalList'        {'string'}      {''}        List of signals to
%                                                    extract.  Leaving
%                                                    blank with extract all
%                                                    signals from file(s)
%   'IgnoreList'        {varies}        {''}        List of signals to
%                                                    ignore.  If element is
%                                                    a string, it will be
%                                                    assumed to be the
%                                                    signal name.  If
%                                                    element is numeric, it
%                                                    will be assumed to be
%                                                    the column index
%   'StartTime'         [1]             []          Desired start time for
%                                                    extracted data
%   'EndTime'           [1]             []          Desired end time for
%                                                    extracted data
%   'SaveOnly'          [bool]          false       Only save each
%                                                    timeseries object to
%                                                    its own .mat file?
%   'SaveIndividual'    [bool]          SaveOnly    Save each extracted
%                                                    timeseries object to
%                                                    its own .mat file?
%   'SaveFolder'        'string'        pwd         Folder in which to save
%                                                    inidividual
%                                                    timeseries, if desired
%   'TimeScalar'        [1]             [1]         Scale factor to apply
%                                                    to the reference time
%                                                    vector
%   'MatVersion'        'string'        '-v7.3'     Save format for matfile
%                                                    Note: -v7.3 is the
%                                                    HDF5 format
%
% Notes:
%   Note 1: If 'SaveOnly' is true, 'SaveIndividual' will be true.  This
%   means that each timeseries object will be saved to individual .mat
%   files.  However, if 'SaveOnly' is false (default) and 'SaveIndividual'
%   is true, both the .mat files and the populated 'Results' structure
%   will be produced.
%
% EXAMPLES:
%	% Example 1: Read in data from a .csv file with a single header row
%   % Step 1: Create the .csv file
%   filename = 'sample_csv_with_header.csv';
%   fid = fopen(filename, 'w'); fprintf(fid, 'Time,A,B,C,D\n');
%   fclose(fid); clear fid;
%   data = [...
%   %   Time,   A,  B,  C,  D
%       1,       4,  6, 10, 12;
%       2,       6, 12, 15, 18;
%       3,      10, 15, 20, 30;
%       4,      21, 28, 35, 42;
%       5,      22, 44, 55, 66;
%       6,      23, 55, 11, 23;
%       7,       0,  3,  5,  6;
%       8,      14, 15, 16, 17];
%   dlmwrite(filename, data, '-append');
%   edit(filename);
%
%	% Example 1a: Read in all the data
%   Results = csv2ts(filename, [], 'TimeColumn', 1)
%   % Returns 'Results'...
% 	%     A: [8x1 timeseries]
%   %     B: [8x1 timeseries]
%   %     C: [8x1 timeseries]
%   %     D: [8x1 timeseries]
%
%   % Example 1b: Read in only columns titled 'A' and 'B' and the rows
%   %             between time 3 and 5
%   Results = csv2ts(filename, [], 'SignalList', {'A';'B'}, ...
%     'TimeColumn', 1, 'StartTime', 3, 'EndTime', 5)
%   % Returns 'Results'...
% 	%     A: [3x1 timeseries]
%   %     B: [3x1 timeseries]
%   % where...
%   Results.A.Data
%   % returns...
%   %     10
%   %     21
%   %     22
%
%   % Example 1c: Same as Example 1a, but only save the data to timeseries
%   %             .mat files instead.
%   Results = csv2ts(filename, [], 'TimeColumn', 1, 'SaveOnly', 1)
%   % returns... Results = []
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit csv2ts.m">csv2ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_csv2ts.m">Driver_csv2ts.m</a>
%	  Documentation: <a href="matlab:pptOpen('csv2ts_Function_Documentation.pptx');">csv2ts_Function_Documentation.pptx</a>
%
% See also format_varargin, dir_list
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/675
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/csv2ts.m $
% $Rev: 3275 $
% $Date: 2014-10-17 14:52:53 -0500 (Fri, 17 Oct 2014) $
% $Author: sufanmi $

function [Results] = csv2ts(filename, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[TimeColumn, varargin]          = format_varargin('TimeColumn', 2, 2, varargin);
[RowStart, varargin]            = format_varargin('RowStart', 2, 2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', 1, 2, varargin);
[lstSignals, varargin]          = format_varargin('SignalList', {}, 2, varargin);
[lstIgnore, varargin]           = format_varargin('IgnoreList', {}, 2, varargin);
[StartTime, varargin]           = format_varargin('StartTime', [], 2, varargin);
[EndTime, varargin]             = format_varargin('EndTime', [], 2, varargin);
[ExtList, varargin]             = format_varargin('ExtList', {'*.csv'}, 2, varargin);
[SaveOnly, varargin]            = format_varargin('SaveOnly', 0, 2, varargin);
[SaveIndividual, varargin]      = format_varargin('SaveIndividual', SaveOnly, 2, varargin);
[SaveFolder, varargin]          = format_varargin('SaveFolder', pwd, 2, varargin);
[TimeScalar, varargin]          = format_varargin('TimeScalar', 1, 2, varargin);
[numColumnsPerLoop, varargin]   = format_varargin('ColumnsPerLoop', 25, 2, varargin);
[lstFileExclude, varargin]      = format_varargin('FileExclude',  '', 2, varargin);
[MatVersion, varargin]          = format_varargin('MatVersion',  '-v7.3', 2, varargin);
[flgAllowOverwrite, varargin]   = format_varargin('AllowOverwrite',  true, 2, varargin);
[flgCheckNaN, varargin]         = format_varargin('CheckNaN',  true, 2, varargin);

if( ismcc || isdeployed )
    SaveOnly = 1;
end

if(SaveOnly)
    SaveIndividual = SaveOnly;
end

if( mod(numel(varargin), 2) )
    Results = varargin{1};
else
    Results = [];
end

if(iscell(filename))
    lstFiles = filename;
else
    lstFiles = { filename };
end

%%
lstFilesRaw = lstFiles;
if(ischar(lstFilesRaw))
    lstFilesRaw = { lstFilesRaw };
end
numFilesRaw = size(lstFilesRaw, 1);

lstFiles = {};
for iFileRaw = 1:numFilesRaw
    curFileRaw = lstFilesRaw{iFileRaw};
    if(isdir(curFileRaw))
        lstFiles2Add = dir_list(ExtList, 0, 'Root', curFileRaw, ...
            'FileExclude', lstFileExclude);
        numFiles2Add = size(lstFiles2Add, 1);
        
        for iFile2Add = 1:numFiles2Add
            lstFiles = [lstFiles; [curFileRaw filesep lstFiles2Add{iFile2Add}]];
        end
    else
        % It's the full path to the file
        lstFiles = [lstFiles; curFileRaw];
    end
end

%% Main Function:
numFiles = size(lstFiles, 1);
for iFile = 1:numFiles
    cur_filename = lstFiles{iFile, :};
    ref_path = fileparts(cur_filename);
    if( ismcc || isdeployed )
        SaveFolder = ref_path;
    end
    disp(sprintf('%s : [%d/%d] : Processing file %s...', mfnam, iFile, numFiles, cur_filename));
    
    [fileinfo, arrSignalsToGet] = csvinfo(cur_filename, lstSignals);
    
    % Explicitly add time
    arrSignalsToGet = unique([arrSignalsToGet TimeColumn]);
    
    % Prevent function from grabbing signals that aren't there
    arrSignalsToGet = intersect([1:fileinfo.num_columns], arrSignalsToGet);
    
    % Remove the Time Column as a desired ts
    arrSignalsToGet = setxor(arrSignalsToGet, TimeColumn);
    
    % Remove User Defined Signals
    if(~isempty(lstIgnore))
        for iIgnore = 1:size(lstIgnore,1)
            curIgnore = lstIgnore{iIgnore};
            if(isnumeric(curIgnore))
                % Actual index was provided
                idxToRemove = curIgnore;
            else
                % Signal name was provided.  Must look-up the index.
                idxToRemove = max(strcmp(fileinfo.column_names, curIgnore).*[1:fileinfo.num_columns]');
            end
            
            if(ismember(idxToRemove, arrSignalsToGet))
                % Only remove the index if it actually exists.
                arrSignalsToGet = setxor(arrSignalsToGet, idxToRemove);
            end
        end
    end
    
    flgAllowFullLoad = 0;
    if(~flgAllowFullLoad)
        flgParseIndividual = 1;
    else
    try
        % Load everything if you can
        [~, ~, matRaw] = xlsread(cur_filename);
        
        tRaw = cell2mat(matRaw([fileinfo.row_data_start:fileinfo.num_rows],TimeColumn));
        
        if(isempty(StartTime))
            idxStart = 1;
        else
            idxStart = max(find(tRaw <= StartTime));
        end
        
        if(isempty(EndTime))
            idxEnd = length(tRaw);
        else
            idxEnd = min(find(tRaw >= EndTime));
        end
        
        t = tRaw(idxStart:idxEnd);
        t = t * TimeScalar;
        clear tRaw;
        
        if(~isempty(t))
            numSignals = length(arrSignalsToGet);
            idxRows = [idxStart:idxEnd]+fileinfo.row_data_start-1;
            
            for idxSignal = 1:numSignals
                iSignal = arrSignalsToGet(idxSignal);
                curSignal = fileinfo.column_names{iSignal};
                
                if(flgVerbose)
                    disp(sprintf('%s        [%d/%d]: Processing ''%s''...', ...
                        mfspc, idxSignal, numSignals, curSignal));
                end
                
                y = t * 0;
                y = cell2mat(matRaw(idxRows, iSignal));
                %             [y, txt] = xlsread(cur_filename, xlsRange);
                txt = '';
                if( (~isempty(txt)) || isempty(y) )
                    disp(sprintf('%s : WARNING : ''%s'' (Column %s) contains text, NOT numerical data!  Ignoring.', ...
                        mfnam, curSignal, xls_colstr));
                    
                else
                    ts = timeseries(y, t);
                    ts.Name = curSignal;
                    
                    ptrUnderScr = strfind(curSignal, '_');
                    if(isempty(ptrUnderScr))
                        yunits = '';
                    else
                        yunits = ['[' curSignal(ptrUnderScr(end)+1:end) ']'];
                    end
                    
                    ts.DataInfo.Units = yunits;
                    
                    %% Save to file
                    if(SaveIndividual)
                        SaveFilename =  sprintf('%s%s%s.mat', SaveFolder, filesep, curSignal);
                        save(SaveFilename, MatVersion, 'ts');
                    end
                    
                    if(~SaveOnly)
                        % Note: Can't do Results.(curSignal) if curSignal has dots in it
                        % (e.g. 'A.B.C')
                        ec = sprintf('Results.%s = ts;', curSignal);
                        eval(ec);
                        
                    end
                end
            end
            
        end
        clear matRaw;
        flgParseIndividual = 0;
        
    catch
        lasterr
        flgParseIndividual = 1;
    end
    end
    
    if(flgParseIndividual)
        
        % Grab Time
        lTC = xls_num2letter(TimeColumn);
        
        try
            xlsRange = sprintf('%s%d:%s%d', lTC, ...
                fileinfo.row_data_start, lTC, fileinfo.num_rows);
            tRaw = xlsread(cur_filename, xlsRange);
            
            if(isempty(StartTime))
                idxStart = 1;
            else
                idxStart = max(find(tRaw <= StartTime));
            end
            
            if(isempty(EndTime))
                idxEnd = length(tRaw);
            else
                idxEnd = min(find(tRaw >= EndTime));
            end
            
            t = tRaw(idxStart:idxEnd);
            t = t * TimeScalar;
            numTRows = size(t, 1);
            clear tRaw;
            
            % zero based
            %                 row_start = fileinfo.row_data_start + idxStart - 2;
            %                 row_end   = row_start + length(t) - 1;
            
            % one based
            row_start = fileinfo.row_data_start + idxStart - 1;
            row_end   = row_start + length(t) - 1;
            
        catch
            disp(lasterr);
            t = [];
        end
        
        if(~isempty(t))
            % Chunk it up in groups
            numSignals = fileinfo.num_columns;
            numLoops = ceil(fileinfo.num_columns / numColumnsPerLoop);
            iSignalStart = 1;
            for iLoop = 1:numLoops
                iSignalEnd = iSignalStart + numColumnsPerLoop - 1;
                iSignalEnd = min(iSignalEnd, fileinfo.num_columns);
%                 numSubSignals = iSignalEnd - iSignalStart;
                
                xls_colstrStart = xls_num2letter(iSignalStart);
                xls_colstrEnd = xls_num2letter(iSignalEnd);
                
                if(flgVerbose)
                    disp(sprintf('%s        Processing %d to %d in ''%s''...', ...
                        mfspc, iSignalStart, iSignalEnd, cur_filename));
                end
                
                xlsRange = sprintf('%s%d:%s%d', xls_colstrStart, row_start, ...
                    xls_colstrEnd, row_end);
                yRaw = xlsread(cur_filename, xlsRange);
                numRawRows = size(yRaw, 1);
                arrText = [];
                
                if(numTRows ~= numRawRows)
                    disp(sprintf('%s        Warning!  Text (e.g. inf/nan) found in extracted data.  Starting additional filtering...', ...
                        mfspc));
                    
                    [~,~,yRawCell] = xlsread(cur_filename, xlsRange);
                    
                    [numRows, numCols] = size(yRawCell);
                    yRaw = zeros(numRows, numCols);
                    
                    for iCol = 1:numCols
                        flgWarningShown = 0;
                        
                        for iRow = 1:numRows
                            curVal = yRawCell{iRow, iCol};
                            if(isnumeric(curVal))
                                yRaw(iRow, iCol) = curVal;
                            else
                                yRaw(iRow, iCol) = nan;
                                if(flgWarningShown == 0)
                                      arrText = [arrText iSignalStart+iCol-1];
                                    flgWarningShown = 1;
                                end
                            end
                        end
                    end
                    
                    clear yRawCell;
                end
                
                for iSignalCur = [iSignalStart:iSignalEnd]
                    curSignal = fileinfo.column_names{iSignalCur};

                    if(flgVerbose)
                        strNum = sprintf('[%d/%d]: ', iSignalCur, numSignals);
                        disp(sprintf('%s        %s Processing ''%s''...', ...
                            mfspc, strNum, curSignal));
                        
                        if(find(arrText == iSignalCur))
                           % Show Warning
                           disp(sprintf('%s        %s WARNING : Signal (Column %s) contains text (e.g. Inf/NaN).  Replacing text with NaN.', ...
                               mfspc, spaces(length(strNum)), xls_num2letter(iSignalCur)));
                        end
                    end
                    
                    y = t * 0;
                    y = yRaw(:, iSignalCur - iSignalStart + 1);
                    if(flgCheckNaN)
                        iNaN = isnan(y);
                        if(any(iNaN))
                            y(iNaN) = 0;
                        end
                    end

                    ptrPound = strfind(curSignal, '#');

                    if(~isempty(ptrPound))
                        % Example with .#
                        % Note going from zero to one-based indexing
                        i = str2num(curSignal(ptrPound+1:end))+1;
                        % Take everything up to the '.' before the '#'
                        curSignal = curSignal(1:ptrPound-2);
                        SaveFilename =  sprintf('%s%s%s.mat', SaveFolder, filesep, curSignal);
                        
                        % Vector Detected
                        if(SaveIndividual)                           
                            % Check to see if the .mat already exists
                            if(exist(SaveFilename))
                                % Append Existing
                                load(SaveFilename);
                                
                                if(length(ts.Time) ~= length(t))
                                    % Attempting to overwrite stale data
                                    % which was run for different amount of
                                    % time.  So just blank it and start
                                    % over.
                                    clear yOut;
                                    yOut(:,i) = y;
                                    ts = timeseries(yOut, t);
                                    ts.Name = curSignal;
                                    ptrUnderScr = strfind(curSignal, '_');
                                    if(isempty(ptrUnderScr))
                                        yunits = '';
                                    else
                                        yunits = ['[' curSignal(ptrUnderScr(end)+1:end) ']'];
                                    end
                                    ts.DataInfo.Units = yunits;
                                else
                                    % Append it
                                    ts.Time = t;
                                    ts.Data(:,i) = y;
                                end
                            else
                                clear yOut;
                                yOut(:,i) = y;
                                ts = timeseries(yOut, t);
                                ts.Name = curSignal;
                                ptrUnderScr = strfind(curSignal, '_');
                                if(isempty(ptrUnderScr))
                                    yunits = '';
                                else
                                    yunits = ['[' curSignal(ptrUnderScr(end)+1:end) ']'];
                                end
                                ts.DataInfo.Units = yunits;
                            end
                        else
                            try
                                ec = sprintf('ts = Results.%s;', curSignal);
                                eval(ec);
                                ts.Data(:,i) = y;
                                
                            catch
                                clear yOut;
                                yOut(:,i) = y;
                                ts = timeseries(yOut, t);
                                ts.Name = curSignal;
                                ptrUnderScr = strfind(curSignal, '_');
                                if(isempty(ptrUnderScr))
                                    yunits = '';
                                else
                                    yunits = ['[' curSignal(ptrUnderScr(end)+1:end) ']'];
                                end
                                ts.DataInfo.Units = yunits;
                            end

                        end
                    else
                        SaveFilename =  sprintf('%s%s%s.mat', SaveFolder, filesep, curSignal);
                        ts = timeseries(y, t);
                        ts.Name = curSignal;
                        ptrUnderScr = strfind(curSignal, '_');
                        if(isempty(ptrUnderScr))
                            yunits = '';
                        else
                            yunits = ['[' curSignal(ptrUnderScr(end)+1:end) ']'];
                        end
                        ts.DataInfo.Units = yunits;
                    end

                    %% Save to file
                    if(SaveIndividual)
                        save(SaveFilename, MatVersion, 'ts');
                    end
                    
                    if(~SaveOnly)
                        % Note: Can't do Results.(curSignal) if curSignal has dots in it
                        % (e.g. 'A.B.C')
                        ec = sprintf('Results.%s = ts;', curSignal);
                        eval(ec);
                    end
                    
                end
                iSignalStart = iSignalEnd + 1;
                clear yRaw;
            end
        end
    end
end

end % << End of function csv2ts >>


%% REVISION HISTORY
% YYMMDD INI: note
% 110201 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi

%% FOOTER
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
