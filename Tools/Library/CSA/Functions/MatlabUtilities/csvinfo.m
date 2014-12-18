% CSVINFO Retrieves basic information on a .csv file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% csvinfo:
%     Retrieves basic information on a .csv file with an emphasis on
%     minimizing MATLAB memory footprint and execution time.  Function
%     returns information on the number of columns, column titles (if any),
%     and number of rows.
% 
% SYNTAX:
%   [fileinfo, arrSignalsToGet] = csvinfo(filename, lstSignals)
%   [fileinfo, arrSignalsToGet] = csvinfo(filename)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	filename	'string'    [char]      CSV file to scan
%   lstSignals {'string'}   {[char]}    List of signals to search for
%                                        (Optional)
%
% OUTPUTS: 
%	Name                Size		Units		Description
%	fileinfo            struct      N/A         CSV File Information
%    .filename          'string'    [char]      Name of file
%    .column_names      {'string'}  {[char]}    List of column names
%    .num_columns       [1]         [int]       Number of columns
%    .row_data_start    [1]         [int]       Row at which data starts
%                                               (either 1 or 2)
%    .num_rows          [1]         [int]       Number of full rows (See
%                                                Note 1)
%
% NOTES:
%   Note #1: The function will drop the last row of data if it is found to
%   be of unequal length from the previous rows.  Main example is if the
%   .csv file was recording data and the data was cut off mid-stream.
%   Since there is incomplete data, the last row is dropped.
%
% EXAMPLES:
%	% Example 1: Derive info for a sample .csv file with a single header row
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
%   % Example 1a: Get info on the file
%   fileinfo = csvinfo(filename)
%
%   % Example 1b: Using a list of signals, get info on the file.  Note that
%   %             the info is only completely valid if any of the signals
%   %             in 'lstSignals' are found to be in the file.
%   tic
%   lstSignals = {'A'; 'C'};
%   [fileinfo, arrSignalsToGet] = csvinfo(filename, lstSignals)
%   toc
%
%   % Example 1c: Same as Example 1b, but show that using a list of signals
%   %             that are NOT contained in the .csv file will ignore the
%   %             computation for 'num_rows' and will result in function
%   %             executing a little faster.
%   tic 
%   lstSignals = {'E'; 'F'};
%   [fileinfo, arrSignalsToGet] = csvinfo(filename, lstSignals)
%   toc
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit csvinfo.m">csvinfo.m</a>
%	  Driver script: <a href="matlab:edit Driver_csvinfo.m">Driver_csvinfo.m</a>
%	  Documentation: <a href="matlab:winopen(which('csvinfo_Function_Documentation.pptx'));">csvinfo_Function_Documentation.pptx</a>
%
% See also dlmread 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/739
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/csvinfo.m $
% $Rev: 2308 $
% $Date: 2012-02-14 10:50:27 -0600 (Tue, 14 Feb 2012) $
% $Author: sufanmi $

function [fileinfo, arrSignalsToGet] = csvinfo(filename, lstSignals)

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

%% Main Function:
if( (nargin < 2) )
    lstSignals = {};
end

%% Main Function:

% Open the file:
fid = fopen(filename, 'r');
fileinfo.filename = filename;

% Read the first line:
tline = fgetl(fid);

% Parse the line to figure out column names:
lstTitles = str2cell(tline, ',');
fileinfo.column_names = lstTitles;

% Count the commas to determine the number of columns:
numCommas = length(strfind(tline, ','));
numSignals = numel(lstTitles);
fileinfo.num_columns = numSignals;

% Double check that first row has header information:
flgFirstRowIsText = 1;
try
    rawCol = dlmread(filename, [0, 0, 0, numSignals-1]);
    flgFirstRowIsText = 0;
catch
end

if(~flgFirstRowIsText)
    fileinfo.column_names = {};
    fileinfo.row_data_start = 1;
else
    for icol = 1:fileinfo.num_columns
        fileinfo.column_names{icol} = strtrim(fileinfo.column_names{icol});
    end
    fileinfo.row_data_start = 2;
end  

if(isempty(lstSignals))
    arrSignalsToGet = [1:fileinfo.num_columns];
else
    if(isnumeric(lstSignals))
        arrSignalsToGet = lstSignals;
    else
        arrSignalsToGet = [];
        
        if(ischar(lstSignals))
            lstSignals = { lstSignals };
        end
        
        numSignals = size(lstSignals, 1);
        for iSignal = 1:numSignals
            curSignal = lstSignals{iSignal};
            idx2get = max((strcmp(fileinfo.column_names, curSignal)).*[1:fileinfo.num_columns]');
            if(idx2get > 0)
                arrSignalsToGet = [arrSignalsToGet idx2get];
            end
        end
    end
end

if(~isempty(arrSignalsToGet))
    % Figure out how many rows are in file:
    i = 0;
    while ischar(tline)
        i = i + 1;
        prev_tline = tline;
        tline = fgetl(fid);
    end
    clear tline;
    numCommasLast = length(strfind(prev_tline, ','));
    clear prev_tline;
    
    if(numCommasLast == numCommas)
        % CSV file is complete (ie square)
    else
        % File was cut off mid-write... therefore drop the last row
        i = i - 1;
    end
    
    numRows = i;
    fileinfo.num_rows = numRows;
else
    fileinfo.num_rows = [];
end

fclose(fid);

end % << End of function csvinfo >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 120118 <INI>: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName            : Email     : NGGN Username 
% <initials>: <Fullname>   : <email>   : <NGGN username> 

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
