% PARSERECORDEDDATA2TS Parses a mat file of time history data into timeseries
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ParseRecordedData2ts:
%   Parses a mat file of time history data into timeseries.
% 
% SYNTAX:
%	[Results] = ParseRecordedData2ts(Results, strMatFile, ListMatFile, OutputStruct, flgVerbose)
%	[Results] = ParseRecordedData2ts(Results, strMatFile, ListMatFile, OutputStruct)
%	[Results] = ParseRecordedData2ts(Results, strMatFile, ListMatFile)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	Results         {struct}    N/A         Results Structure to add parsed
%                                            data to
%	strMatFile      'string'    [char]      String of Mat File containing
%                                           run results from a Simulink 
%                                           'To File' block
%	ListMatFile     {[Mx3]}                 Cell list defining recorded
%                                            data where:
%                                            Column 1: String identifier of data
%                                            Column 2: Size of data
%                                            Column 3: Data units in string form
%   OutputStruct    'string'     [char]     Additional Struct Name (Optional)
%                                            Default: '' (empty string)
%   flgVerbose      [1]         [bool]      Display Parsing? (Optional)
%                                           Default: 1 (true)
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%   Results       [various] [various]    Input Results Structure with added data
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	Results	     <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
%  EXAMPLE
%   Suppose that a single signal (e.g. StateBus.P_i) was recorded for
%   100 timesteps from a simulink model using a 'To File' block.
%
%   Assumptions:    The Filename (strMatFile) is 'StateBus.mat'
%                   The Variable name is 'StateBus'
%
%   Because the 'To File' block automatically saves the timestep along with
%   the desired signal, ListMatFile becomes:
%    
%   ListMatFile = {'P_i'    3   '[ft]'};
%
%   Results = ParseRecordedData([], 'StateBus', ListMatFile, 'StateBus');
%
%   When parsed, the returned Results structure becomes:
%
%   Results.StateBus
%               P_i:    [100x3 timeseries]
%   where...
%   Results.StateBus.P_i
%       .Time           [100x1 double]
%       .TimeInfo.Units 'seconds'
%       .Data           [100x3 double]  <-- P_i
%       .DataInfo.Units '[ft]'
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ParseRecordedData2ts.m">ParseRecordedData2ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_ParseRecordedData2ts.m">Driver_ParseRecordedData2ts.m</a>
%	  Documentation: <a href="matlab:pptOpen('ParseRecordedData2ts_Function_Documentation.pptx');">ParseRecordedData2ts_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/520
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/ParseRecordedData2ts.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Results] = ParseRecordedData2ts(Results, strMatFile, ListMatFile, OutputStruct, flgVerbose, varargin)

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

%% Input Argument Checking:
if nargin < 5
    flgVerbose = 1;
end

if nargin < 4
    OutputStruct = '';
end

%% Input Error Checking:
%   Remove '.mat' from strMatFile, if it exists
ptrMat = findstr(strMatFile, '.mat');
if(~isempty(ptrMat))
    strMatFile = strMatFile(1:(ptrMat-1));
end

strMatFull = [pwd filesep strMatFile '.mat'];

if(~exist(strMatFull))
    if(flgVerbose)
        disp(sprintf('%s : WARNING : ''%s.mat'' does NOT Exist in %s.  Ignoring call to parse.', ...
            mfilename, strMatFile, pwd));
    end
else
    
    load(strMatFull);
%     data = eval(strMatFile)';
%     eval(['clear ' strMatFull]);
    
    fileinfo = dir(strMatFull);
    
    if(flgVerbose)
        disp(sprintf('%s : Parsing %s', mfilename, strMatFile));
    end

    % Error Checking:
    sizeExpected = sum(cell2mat(ListMatFile(:,2)));
    sizeRecorded = size(eval(strMatFile),1);

    if ((sizeExpected+1) ~= sizeRecorded)
        disp(' ');
        disp([mfilename ' : WARNING : Size Mismatched in parsing ' strMatFile '!']);
        disp([' The size of the expected data (' ...
            num2str(sizeExpected) ') does NOT match the']);
        disp(['size of the recorded data (' num2str(sizeRecorded) ').']);

        disp(' Data will NOT be Parsed.');

    else

        % Add Date/Time at which Data was Parsed/Recorded
        if(~isempty(fileinfo))
            DataRecorded = [datestr(fileinfo.datenum, 'dddd, mmmm') ...
                datestr(fileinfo.datenum,' dd, yyyy @ HH:MM:SS PM')];
            ec = sprintf('Results.%s.DataRecorded = ''%s'';', ...
                OutputStruct, DataRecorded );
            ec = strrep(ec, '..', '.');
            eval(ec); clear ec DataRecorded;
        end
            
        ec = sprintf('t = %s(1,:)'';', strMatFile);
        eval(ec);
            
        ptrEnd = 1;
        for i = 1:size(ListMatFile,1)
            
            yname   = ListMatFile{i,1};
            if(~isempty(OutputStruct))
                yname = [OutputStruct '.' yname];
            end
            
            numDims = ListMatFile{i,2};
            yunits  = ListMatFile{i,3};
            
            ptrStart = ptrEnd + 1;
            ptrEnd = ptrStart + numDims - 1;
            
            % Loop Through the Dimensions of the ListMatFile Member
            clear y;
            
            ec = sprintf('y = %s((%d:%d),:)'';', strMatFile, ptrStart, ptrEnd);
            eval(ec);
            
%             y = data(:,(ptrStart:ptrEnd));
            
            clear ts;
            ts = timeseries(y, t);
            ts.Name = yname;
            ts.DataInfo.Units = yunits;
            
            ec = sprintf('Results.%s = ts;', yname);
            eval(ec);
        end
        
        flgCorrect = (ptrEnd == sizeRecorded);
    end
    
    clear data ts;
end

end % << End of function ParseRecordedData2ts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101019 MWS: Cleaned up internal documentation with CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
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
