% PARSERECORDEDBINARYDATA2TS Parses a time history data saved in binary form into a MATLAB timeseries structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ParseRecordedBinaryData2ts:
%   Parses a time history data saved in binary form into a MATLAB
%   timeseries structure
% 
% SYNTAX:
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose, varargin, 'PropertyName', PropertyValue)
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose, varargin)
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose)
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct)
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile)
%
% INPUTS: 
%	Name        	Size		Units		Description
%   Results         {structure}     Results Structure to which to add to
%   strBinFile      [string]        String of Bin File containing run
%                                   results from a Simulink 'To File'
%                                   block.
%                                   NOTE: In the 'To File' block the
%                                   filename and the variable name should
%                                   be identical.
%   ListBinFile     {Mx3 cell struct} List defining recorded data where:
%                                   Column 1: String identifier of data
%                                   Column 2: Size of data
%                                   Column 3: Units
%      
%   OutputStruct*   [string]        Additional Struct Name
%                                    Default is '' (empty string)
%   flgVerbose*     [bool]          Display Parsing?
%                                    Default is 1 (true)

%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%   Results         {structure}     Input Results Structure with added data
%
% NOTES:
%   *OutputStruct and flgVerbose are not required.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%   Suppose that a single signal (e.g. StateBus.P_i) was recorded for
%   100 timesteps from a simulink model using a 'To File' block.
%
%   Assumptions:    The Filename (strBinFile) is 'StateBus.mat'
%                   The Variable name is 'StateBus'
%
%   Because the 'To File' block automatically saves the timestep along with
%   the desired signal, ListBinFile becomes:
%    
%   ListBinFile = {'P_i'    3   '[ft]'};
%
%   Results = ParseRecordedData([], 'StateBus', ListBinFile, 'StateBus');
%
%   When parsed, the returned Results structure becomes:
%
%   Results.StateBus
%               P_i:    [100x3 timeseries]
%
%   where...
%
%   Results.StateBus.P_i
%       .Time           [100x1 double]
%       .TimeInfo.Units '[sec]'
%           simtime:    '[100x1 double]'
%               P_i:    '[ft]'
%
%	% <Enter Description of Example #1>
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ParseRecordedBinaryData2ts.m">ParseRecordedBinaryData2ts.m</a>
%	  Driver script: <a href="matlab:edit Driver_ParseRecordedBinaryData2ts.m">Driver_ParseRecordedBinaryData2ts.m</a>
%	  Documentation: <a href="matlab:pptOpen('ParseRecordedBinaryData2ts_Function_Documentation.pptx');">ParseRecordedBinaryData2ts_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/519
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/ParseRecordedBinaryData2ts.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Results] = ParseRecordedBinaryData2ts(Results, strBinFile, ListBinFile, OutputStruct, flgVerbose, varargin)

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

%% Initialize Outputs:
% Results= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgVerbose= ''; OutputStruct= ''; ListBinFile= ''; strBinFile= ''; Results= ''; 
%       case 1
%        flgVerbose= ''; OutputStruct= ''; ListBinFile= ''; strBinFile= ''; 
%       case 2
%        flgVerbose= ''; OutputStruct= ''; ListBinFile= ''; 
%       case 3
%        flgVerbose= ''; OutputStruct= ''; 
%       case 4
%        flgVerbose= ''; 
%       case 5
%        
%       case 6
%        
%  end
%
%  if(isempty(flgVerbose))
%		flgVerbose = -1;
%  end
%% Main Function:
%% Input Argument Checking:
if nargin < 5
    flgVerbose = 1;
end

if nargin < 4
    OutputStruct = '';
end

%% Input Error Checking:
%   Remove '.bin' from strBinFile, if it exists
ptrBin = findstr(strBinFile, '.bin');
if(~isempty(ptrBin))
    strBinFile = strBinFile(1:(ptrBin-1));
end

strBinFull = [pwd filesep strBinFile '.bin'];

if(~exist(strBinFull))
    if(flgVerbose)
        disp(sprintf('%s : WARNING : ''%s.bin'' does NOT Exist in %s.  Ignoring call to parse.', ...
            mfilename, strBinFile, pwd));
    end
else
    
    if(flgVerbose)
        disp(sprintf('%s : Parsing %s', mfilename, strBinFile));
    end
    
    % Add Date/Time at which Data was Parsed/Recorded
%         if(~isempty(fileinfo))
        if(1)
            fileinfo = dir(strBinFull);
            DataRecorded = [datestr(fileinfo.datenum, 'dddd, mmmm') ...
                datestr(fileinfo.datenum,' dd, yyyy @ HH:MM:SS PM')];
            ec = sprintf('Results.%s.DataRecorded = ''%s'';', ...
                OutputStruct, DataRecorded );
            ec = strrep(ec, '..', '.');
            eval(ec); clear ec DataRecorded;
        end
                
        numSignals = size(ListBinFile, 1);
        
        % Compute Total Signals Recorded (including time):
        numSignalsRef = sum(cell2mat(ListBinFile(:,2))) + 1;
        

        t = bin2mat(strBinFull, numSignalsRef, 1);
        
        ictr = 0;
    
        ptrEnd = 1;
        for i = 1:size(ListBinFile,1)
            
            yname   = ListBinFile{i,1};
            if(~isempty(OutputStruct))
                yname = [OutputStruct '.' yname];
            end
            
            numDims = ListBinFile{i,2};
            yunits  = ListBinFile{i,3};
            
            ptrStart = ptrEnd + 1;
            ptrEnd = ptrStart + numDims - 1;
            
            % Loop Through the Dimensions of the ListBinFile Member
            clear y;
            y = bin2mat(strBinFull, numSignalsRef, [ptrStart:ptrEnd]);
            
            clear ts;
            ts = timeseries(y, t);
            ts.Name = yname;
            ts.DataInfo.Units = yunits;
            
            ec = sprintf('Results.%s = ts;', yname);
            eval(ec);
        end
end
    
    clear data ts;



%% Compile Outputs:
%	Results= -1;

end % << End of function ParseRecordedBinaryData2ts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 

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
