% LST2SAMPLECSV Writes timeseries parse function for a given list of recorded signals
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% lst2sampleCSV:
%     <Function Description> 
% 
% SYNTAX:
%	[lstFiles] = lst2sampleCSV(lstSignals, varargin, 'PropertyName', PropertyValue)
%	[lstFiles] = lst2sampleCSV(lstSignals, varargin)
%	[lstFiles] = lst2sampleCSV(lstSignals)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	lstSignals	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	lstFiles	  <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[lstFiles] = lst2sampleCSV(lstSignals, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[lstFiles] = lst2sampleCSV(lstSignals)
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
%	Source function: <a href="matlab:edit lst2sampleCSV.m">lst2sampleCSV.m</a>
%	  Driver script: <a href="matlab:edit Driver_lst2sampleCSV.m">Driver_lst2sampleCSV.m</a>
%	  Documentation: <a href="matlab:pptOpen('lst2sampleCSV_Function_Documentation.pptx');">lst2sampleCSV_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/706
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [lstFiles] = lst2sampleCSV(strRoot, lstSignals, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[MarkingsFile, varargin]        = format_varargin('MarkingsFile', 'CreateNewFile_Defaults',  2, varargin);
[SaveFolder, varargin]          = format_varargin('SaveFolder', pwd,  2, varargin);
[OpenAfterCreated, varargin]    = format_varargin('OpenAfterCreated', true,  2, varargin);
[numTimesteps, varargin]        = format_varargin('numTimesteps', 3,  2, varargin);
[flgIncludeTime, varargin]      = format_varargin('IncludeTime', 1, 2, varargin);
[SampleTime, varargin]          = format_varargin('SampleTime', 0.01, 2, varargin);
[strSuffix, varargin]           = format_varargin('Suffix', '', 2, varargin);
[fileext, varargin]             = format_varargin('Extension', '.csv', 2, varargin);
[flgVerbose, varargin]          = format_varargin('Verbose', true, 2, varargin);

if(ischar(lstSignals))
    % It's a bus object
    lstSignals = BO2ResultsList(lstSignals);
end

fileext = ['.' fileext];
fileext = strrep(fileext, '..', '.');

%% Main Function:
filenameroot = strRoot;

%% File #1: The CSV itself:
% csvfile = [filenameroot '_Info'];
% logfile = [SaveFolder filesep logroot '.m'];
numBOsignals = sum(cell2mat(lstSignals(:,2)));
mat2save = zeros(numTimesteps, (flgIncludeTime + numBOsignals));

lstSavedData = {}; iInfo = 0;
icol = 0;

iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['% Log Info for Data Saved in: ' filenameroot fileext] };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Note that this log file doubles as a file loader' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Data loaded in will be in a timeseries object' };

iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'if( (nargin == 0) || isempty(filename) )' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { [tab 'filename = [fileparts(mfilename(''fullpath'')) filesep ''' filenameroot fileext '''];'] };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'end' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'matData = dlmread(filename, '','');' };
iInfo = iInfo + 1;
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Disable Timeseries Warning:' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'warnID = ''timeseries:init:istimefirst'';' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'warning(''off'', warnID);' };
iInfo = iInfo + 1;

if(flgIncludeTime)
    arrTime = [1:numTimesteps]*SampleTime - SampleTime;     % [sec]
    mat2save(:,1) = arrTime';
    
    icol = icol + 1;
    mat2save(:,icol) = arrTime;
    curSignal = ['t = matData(:,1);  % Time [sec]'];
    lstSavedData(iInfo,:) = { curSignal };
    iInfo = iInfo + 1;
end

numSignals = size(lstSignals, 1);

for iSignal = 1:numSignals
    curSignalRoot   = lstSignals{iSignal, 1};
    numLines    = lstSignals{iSignal, 2};
    curUnits    = lstSignals{iSignal, 3};

    for iLine = 1:numLines
        iInfo = iInfo + 1;
        icol = icol + 1;
        if(numLines > 1)
            curSignal = ['y(:,' num2str(iLine) ') = matData(:,' num2str(icol) ');'];
        else
            curSignal = ['y = matData(:,' num2str(icol) ');'];
        end
        lstSavedData(iInfo,:) = { curSignal }; %#ok<AGROW>
    end

    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'ts = timeseries(y, t);  clear y;' }; %#ok<AGROW>
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['ts.Name = ''' curSignalRoot ''';'] }; %#ok<AGROW>
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['ts.DataInfo.Units = ''' curUnits ''';'] }; %#ok<AGROW>
    iInfo = iInfo + 1; lstSavedData(iInfo,:) = { ['Results.' curSignalRoot ' = ts; clear ts;'] }; %#ok<AGROW>
    
    if(iSignal < numSignals)
        iInfo = iInfo + 1;
    end
end

iInfo = iInfo + 1;
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { '% Re-enable Timeseries Warning:' };
iInfo = iInfo + 1; lstSavedData(iInfo,:) = { 'warning(''on'', warnID);' };
iInfo = iInfo + 1;

datafile = [SaveFolder filesep filenameroot strSuffix fileext];
if(~isdir(SaveFolder))
    mkdir(SaveFolder);
end
if(exist(datafile) == 2)
    delete(datafile);
end
dlmwrite(datafile, mat2save);
if(OpenAfterCreated)
    edit(datafile);
end
lstFiles(1,:) = { datafile };
if(flgVerbose)
    [fldrSave, strFile, strExt] = fileparts(datafile);
    disp(sprintf('%s : Wrote ''%s%s'' in ''%s''...', mfnam, strFile, strExt, fldrSave));
end

%% Write File #2: The csv parser:
%  Writes the Log File associated with the datafile
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
if(OpenAfterCreated)
    edit(logfile);
end
lstFiles(2,:) = { logfile };
if(flgVerbose)
    [fldrSave, strFile, strExt] = fileparts(logfile);
    disp(sprintf('%s : Wrote ''%s%s'' in ''%s''...', mfnam, strFile, strExt, fldrSave));
end

end % << End of function lst2sampleCSV >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110523 MWS: Created function using CreateNewFunc
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
