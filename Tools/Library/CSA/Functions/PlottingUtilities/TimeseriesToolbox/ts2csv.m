% TS2CSV Writes a comma separated datafile for a timeseries or structure of timeseries
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ts2csv:
%   Writes a comma separated datafile (.csv, .txt, etc) for a MATLAB
%   timeseries or a structure of MATLAB timeseries.  Function will output
%   two files: the csv datafile itself and a log file that can be used as a
%   loader of the csv datafile.
% 
% SYNTAX:
%	[datafile, logfile] = ts2csv(cell_ts, filename, varargin, 'PropertyName', PropertyValue)
%	[datafile, logfile] = ts2csv(cell_ts, filename, varargin)
%	[datafile, logfile] = ts2csv(cell_ts, filename)
%
% INPUTS: 
%	Name    	Size            Units		Description
%	cell_ts     {timeseries}    [varies]    MATLAB timeseries or structure
%                                           of timeseries
%	filename	'string'        [char]      Either the outputted csv file's
%                                           full or partial filename
%                                           If file extension not
%                                           specified, '.txt' will be used
%	varargin	[N/A]           [varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
%
% OUTPUTS: 
%	Name    	Size            Units		Description
%   datafile    'string'        [char]      Full path to csv file created
%   logfile     'string'        [char]      Full path to log file for
%                                           created csv file
%
% NOTES:
%	This function is supported by the following CSA functions:
%   format_varargin, listStruct, cell2str, CenterChars, Interp1D, 
%   CreateNewFile_Defaults
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	Min                 [sec]           []          First timestamp to
%                                                   record (default is all)
%   Max                 [sec]           []          Last timestamp to
%                                                   record (default is all)
%   IncludeTime         [bool]          [1]         Record time?
%   TimeIndex           [int]           [1]         Timeseries member to
%                                                   use for time (if a
%                                                   structure is passed in)
%   TimeString          'string'        'Time'      String to use for time
%   Suffix              'string'        ''          Additional String to
%                                                   include on .csv filename
%   Precision           'string'        '%.15f'     Precision with which
%                                                   data will be saved
%   IncludeHeader       [bool]          [0]         Include the timeseries
%                                                   signal name on the
%                                                   first line of the csv
%                                                   file?
%   HeaderPrefix        'string'        ''          Additional string to
%                                                   include on the front
%                                                   side of each signal
%                                                   name if added to the
%                                                   csv file
%   IncludeUnitsInHeader [bool]         [0]         Include units in header
%                                                    if utilitied?
%   ArrayFormatType     [int]           [1]         Instructions on how to
%                                                    format signal name for
%                                                    arrays, where...
%                                                     0:  Signal_units(:,X)
%                                                    [1]: Signal_unitsX
%                                                     2:  SignalX_units
%
% EXAMPLES:
%   % See Driver_Test_SaveToBin.m' for full working example
%
%	% Example 1: Convert a sample structure of timeseries to csv file
%   %            Note that the timeseries will be 10 seconds in length, but
%   %            assume that we want only the data from t = 4 to t = 8
%   %            seconds to be saved to the csv file
%
%   % Step 1: Build the timeseries with 2 signals in it
%   t = [0:0.01:10]';  % [sec]
%   
%   % Signal #1 - Scalar Signal (e.g. ElevatorPos, [deg])
%   y1 = sin(t);
%   str = 'ElevatorPos_deg';
%   ts = timeseries(y1, t); ts.Name = str; ts.DataInfo.Units = '[deg]';
%   Results.(str) = ts;
%
%   % Signal #2 - Vectorized Signal (e.g. PQRb, [deg/sec])
%   y3 = [cos(t), cos(t/2), sin(t)];
%   str = 'PQRb_dps';
%   ts = timeseries(y3, t); ts.Name = str; ts.DataInfo.Units = '[deg/sec]';
%   Results.(str) = ts;
%   
%   % Convert the timeseries to csv
%	[datafile, logfile] = ts2csv(Results, 'test.txt', 'Min', 4, 'Max', 8);
%   % Open files for viewing:
%   edit(datafile);
%   edit(logfile);
%
%   % Load the data back into MATLAB and plot it (markers every 2 seconds)
%   [pathstr, loadfcn] = fileparts(logfile);
%   Results2 = eval(loadfcn);
%
%   figure();
%   h(1) = plotts(Results.ElevatorPos_deg, 'Decimation', 2); hold on;
%   h(2) = plotts(Results2.ElevatorPos_deg, 'Decimation', 2);
%   title('ts2csv example');
%   legend(h, {'Original';'Reloaded'});
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ts2csv.m">ts2csv.m</a>
%	  Driver script: <a href="matlab:edit Driver_ts2csv.m">Driver_ts2csv.m</a>
%	  Documentation: <a href="matlab:pptOpen('ts2csv_Function_Documentation.pptx');">ts2csv_Function_Documentation.pptx</a>
%
% See also format_varargin, listStruct, cell2str, CenterChars, Interp1D, CreateNewFile_Defaults
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/677
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/ts2csv.m $
% $Rev: 2298 $
% $Date: 2012-02-09 16:37:15 -0600 (Thu, 09 Feb 2012) $
% $Author: sufanmi $

function [datafile, logfile] = ts2csv(cell_ts, filename, varargin)

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
[PO.xmin, varargin]                 = format_varargin('Min', [], 2, varargin);
[PO.xmax, varargin]                 = format_varargin('Max', [], 2, varargin);
[PO.IncludeTime, varargin]          = format_varargin('IncludeTime', 1, 2, varargin);
[PO.TimeIndex, varargin]            = format_varargin('TimeIndex', 1, 2, varargin);
[flgVerbose, varargin]              = format_varargin('Verbose', 1, 2, varargin);
[strSuffix, varargin]               = format_varargin('Suffix', '', 2, varargin);
[strPrecision, varargin]            = format_varargin('Precision', '%.15f', 2, varargin);
[flgIncludeHeader, varargin]        = format_varargin('IncludeHeader', 0, 2, varargin);
[flgIncludeUnitsInHeader, varargin] = format_varargin('IncludeUnitsInHeader', 0, 2, varargin);
[strHeaderPrefix, varargin]         = format_varargin('HeaderPrefix', '', 2, varargin);
[strTime, varargin]                 = format_varargin('TimeString', 'Time', 2, varargin);
[TimestepDelay, varargin]           = format_varargin('TimestepDelay', 0, 2, varargin);
[ArrayFormatType, varargin]         = format_varargin('ArrayFormatType', 1, 2, varargin);

mat2save = []; icol = 0;
lstSavedData = {}; iInfo = 0;

%% Main Function:

% Determine filenameroot
ptrSlash = strfind(filename, filesep);
if(isempty(ptrSlash))
    filenameroot = filename;
    SaveFolder = pwd;
else
    filenameroot = filename(ptrSlash(end)+1:end);
    SaveFolder = filename(1:ptrSlash(end)-1);
end

ptrDot = strfind(filenameroot, '.');

if(isempty(ptrDot))
    fileext = '.csv';
else
    fileext = filenameroot(ptrDot(end):end);
    filenameroot = filenameroot(1:ptrDot(end)-1);
end
datafile = [SaveFolder filesep filenameroot strSuffix fileext];

if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end

if(isstruct(cell_ts))
    % A structure of timeseries has been enterred
    lst_ts = listStruct(cell_ts);
else
    % A single timeseries has been enterred
    lst_ts = { cell_ts };
end

% Grab Master Time
ts = cell_ts.(lst_ts{PO.TimeIndex,1});
arrTime = ts.Time;

if(~isempty(PO.xmin))
    imin = find(arrTime >= PO.xmin);
else
    imin = [1:length(arrTime)];
end

if(~isempty(PO.xmax))
    imax = find(arrTime <= PO.xmax);
else
    imax = [1:length(arrTime)];
end
idownselect = intersect(imin, imax);
arrTime = arrTime(idownselect);

iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['% Log Info for Data Saved in: ' filenameroot fileext] };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Note that this log file doubles as a file loader' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Data loaded in will be in a timeseries object' };

iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'if( (nargin == 0) || isempty(filename) )' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { [tab 'filename = [fileparts(mfilename(''fullpath'')) filesep ''' filenameroot strSuffix fileext '''];'] };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'end' };

iInfo = iInfo + 1;
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['matData = dlmread(filename, '','');' ] };
iInfoRef2 = iInfo;

if(PO.IncludeTime)
    icol = icol + 1;
    mat2save(:,icol) = arrTime;

    iInfo = iInfo + 2;
    curSignal = ['t = matData(:,1);  % ' strTime ' [sec]'];
    

    lstSavedData(iInfo,:) = { curSignal };
    if(flgIncludeUnitsInHeader)
        lstSignals(icol,1) = { [strTime ' [sec]'] };
    else
        lstSignals(icol,1) = { [strTime] };
    end
end

% Now go through each timeseries and add it to the master matrix to save
% off:
num_ts = size(lst_ts, 1);

iInfo = iInfo + 1;

for i_ts = 1:num_ts
    
    % Pick off the current timeseries
    ts = cell_ts.(lst_ts{i_ts,1});

    % Extract the time and data
    xdata = ts.Time;
    ydata = ts.Data;
    
    if(TimestepDelay > 0)
        ydata(1+TimestepDelay:end) = ydata(1:end-TimestepDelay);
        
    end
    
    % Determine the number of columns (e.g. is it vectorized?)
    num_ydata = size(ydata, 2);
        
    % Determine which column to pick off
    if(size(lst_ts, 2) > 1)
        % cell_ts has 2 columns, which means cell_ts(:,2) specifies which
        % columns of the timeseries to use:
        lines2use = lst_ts{i_ts, 2};
        if(isempty(lines2use))
            lines2use = [1:num_ydata];
        end
    else
         lines2use = [1:num_ydata];
    end

    % Add the selected columns to the matrix to record:
    numLines = length(lines2use);
    for iLine = 1:numLines;
        curline2use = lines2use(iLine);     % [idx]
        
        % Select off the data and interpolate it against the master time
        % vector.  This ensures that the total 'mat2write' is of a
        % uniformed shape and that each row has a consistent time (since
        % you could have a structure with timeseries of various times and
        % decimations)
        cur_ydata =  ydata(:,curline2use);  % [varies]
        ydata2save = Interp1D(xdata, cur_ydata, arrTime);
        
        icol = icol + 1;
        mat2save(:,icol) = ydata2save;

        curUnits = ts.DataInfo.Units;
        
        if(numLines == 1)
            curSignal = ts.Name;
        else
            switch ArrayFormatType
                case 0
                    % Signal_units(:,X)
                    curSignal = sprintf('%s(:,%d)', ts.Name, curline2use);
                case 1
                    % Signal_unitsX
                    curSignal = sprintf('%s%d', ts.Name, curline2use);
                case 2
                    % SignalX_units
                    ptrUnderscore = findstr(ts.Name, '_');
                    if(isempty(ptrUnderscore))
                        curSignal = sprintf('%s%d)', ts.Name, curline2use);
                    else
                        curSignal = sprintf('%s%d%s', ...
                            ts.Name(1:ptrUnderscore(end)-1), curline2use, ...
                            ts.Name(ptrUnderscore(end):end) );
                    end
            end
        end
        
        if(~flgIncludeUnitsInHeader)
            lstSignals(icol,1) = { [strHeaderPrefix curSignal] };
        end
        
        if(~isempty(curUnits))
            curSignal = [curSignal ' ' curUnits];
        end

         if(flgIncludeUnitsInHeader)
            lstSignals(icol,1) = { [strHeaderPrefix curSignal] };
        end
         
        curSignal = [filenameroot '(:,' num2str(icol) '): ' curSignal]; 
        iInfo = iInfo + 1;
        curSignal = ['y(:,' num2str(iLine) ') = matData(:,' num2str(icol) ');'];
        
        lstSavedData(iInfo,:) = { curSignal };
    end
    
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'ts = timeseries(y, t);  clear y;' };
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['ts.Name = ''' ts.Name ''';'] };
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['ts.DataInfo.Units = ''' ts.DataInfo.Units ''';'] };
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['Results.' ts.Name ' = ts; clear ts;'] };
    
    if(i_ts < num_ts)
        iInfo = iInfo + 1;
    end
end

[numRow, numCol] = size(mat2save);
numRow = numRow + flgIncludeHeader;

% Note, dlmread uses 0-based indexing
if(flgIncludeHeader)
    lstSavedData(iInfoRef2,:) = { sprintf('matData = dlmread(filename, '','', [%d 0 %d %d]);', ...
        flgIncludeHeader, numRow-1, numCol-1) };
end

if(flgIncludeHeader)
    fid = fopen(datafile, 'w');
    str2add = cell2str(lstSignals, ',');
    fprintf(fid, '%s\n', str2add);
    fclose(fid);
    dlmwrite(datafile, mat2save, '-append', 'precision', strPrecision );
else
    dlmwrite(datafile, mat2save, 'precision', strPrecision );
end

if(flgVerbose)
    [fldrSave, strName, strExt] = fileparts(datafile);
    disp(sprintf('%s : Wrote ''%s%s'' in ''%s''...', mfnam, strName, strExt, fldrSave));
end

%% Writes the Log File associated with the datafile
logroot = [filenameroot '_Info'];
logfile = [SaveFolder filesep logroot '.m'];

CNF_info = CreateNewFile_Defaults(1, mfnam);

% H1 Help Line
fstr = ['% ' upper(logroot) ' ICD and Loader for ' filenameroot fileext endl];

% Header Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Header ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Header Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

fstr = [fstr '% ' logroot ':' endl];
fstr = [fstr '%    ICD and Loader Function for ' filenameroot fileext endl];
fstr = [fstr '%' endl];
fstr = [fstr '% SYNTAX:' endl];
fstr = [fstr '%  Results = ' logroot '(filename);' endl];
fstr = [fstr '%  Results = ' logroot '();' endl];
fstr = [fstr '%' endl];
fstr = [fstr '% INPUTS:' endl];
fstr = [fstr '%' tab 'Name' tab tab 'Size' tab tab tab 'Units' tab tab tab 'Description' endl];
fstr = [fstr '%' tab 'filename' tab '''string''' tab tab '[char]' tab tab tab 'CSV file to parse' endl];
fstr = [fstr '%' endl];
fstr = [fstr '% OUTPUTS:' endl];
fstr = [fstr '%' tab 'Name' tab tab 'Size' tab tab tab 'Units' tab tab tab 'Description' endl];
fstr = [fstr '%' tab 'Results' tab tab '{timeseries}' tab '[varies]' tab tab 'Saved data in timeseries form' endl];
fstr = [fstr '%' endl];
fstr = [fstr '% NOTES:' endl];
fstr = [fstr '%' tab 'This function was auto-created CSA function by: ' mfnam '.m' endl];
fstr = [fstr '%' tab 'on ' datestr(now,'dddd, mmm dd, yyyy at HH:MM:SS AM') endl];
fstr = [fstr '%' endl];
fstr = [fstr '%' tab 'See also ' mfnam endl];
fstr = [fstr endl];
fstr = [fstr 'function Results = ' logroot '(filename)' endl];
fstr = [fstr endl];
fstr = [fstr '% Main Function:' endl];

strLog = cell2str(lstSavedData, char(10), '\n');
fstr = [fstr strLog endl endl];

fstr = [fstr 'end % << End of function ' logroot ' >>' endl endl];

% Footer
% Order is reversed from header
% DistributionStatement,ITARparagraph Proprietary ITAR, Classification
fstr = [fstr '%% FOOTER' endl];
% Distribution Statement
if ~isempty(CNF_info.DistibStatement)
    fstr = [fstr CNF_info.DistibStatement endl];
    fstr = [fstr endl];
end

% Itar Paragraph
if ~isempty(CNF_info.ITAR_Paragraph)
    fstr = [fstr '%' endl];
    fstr = [fstr CNF_info.ITAR_Paragraph];
    if(~strcmp(CNF_info.ITAR_Paragraph(end), endl))
        fstr = [fstr endl];
    end
    fstr = [fstr '%' endl];
end

% Footer Proprietary Lines
if ~isempty(CNF_info.Proprietary)
    fstr = [fstr '% ' CenterChars(CNF_info.Proprietary, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer ITAR Lines
if ~isempty(CNF_info.ITAR)
    fstr = [fstr '% ' CenterChars(CNF_info.ITAR, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end

% Footer Classified Lines
if ~isempty(CNF_info.Classification)
    fstr = [fstr '% ' CenterChars(CNF_info.Classification, CNF_info.HelpWidth, CNF_info.CentChar) endl];
end


fid = fopen(logfile, 'wt', 'native');
fprintf(fid, '%s', fstr);
fclose(fid);

if(flgVerbose)
    [fldrSave, strName, strExt] = fileparts(logfile);
    disp(sprintf('%s : Wrote ''%s%s'' in ''%s''...', mfnam, strName, strExt, fldrSave));
end

end % << End of function ts2csv >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110511 MWS: Created function using CreateNewFunc
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
