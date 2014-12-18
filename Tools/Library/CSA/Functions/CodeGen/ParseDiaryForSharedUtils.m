% PARSEDIARYFORSHAREDUTILS Parses a diary used during autocoding to deterimine what shared utilities were used
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ParseDiaryForSharedUtils:
%     <Function Description> 
% 
% SYNTAX:
%   [fl, info, lstFilesToAdd] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils, varargin, 'PropertyName', PropertyValue)
%	[fl, info, lstFilesToAdd] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils, varargin)
%	[fl, info, lstFilesToAdd] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils)
%	[fl, info, lstFilesToAdd] = ParseDiaryForSharedUtils(filename_diary)
%
% INPUTS: 
%	Name            	Size		Units		Description
%	filename_diary	  <size>		<units>		<Description>
%	fldr_SharedUtils	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            	Size		Units		Description
%	strFilename	     <size>		<units>		<Description> 
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
%	[strFilename] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[strFilename] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils)
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
%	Source function: <a href="matlab:edit ParseDiaryForSharedUtils.m">ParseDiaryForSharedUtils.m</a>
%	  Driver script: <a href="matlab:edit Driver_ParseDiaryForSharedUtils.m">Driver_ParseDiaryForSharedUtils.m</a>
%	  Documentation: <a href="matlab:pptOpen('ParseDiaryForSharedUtils_Function_Documentation.pptx');">ParseDiaryForSharedUtils_Function_Documentation.pptx</a>
%
% See also LoadFile, str2cell, format_varargin
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/622
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function [fl, info, lstFilesToAdd] = ParseDiaryForSharedUtils(filename_diary, fldr_SharedUtils, varargin)

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
strFilename= '';

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[location, varargin]            = format_varargin('Location', pwd,         2, varargin);
[filename, varargin]            = format_varargin('Filename', '', 2, varargin);
[flgOpenAfterCreated, varargin] = format_varargin('OpenAfterCreated',  true, 2, varargin);

%% Main Function:
str = LoadFile(filename_diary);
lstDiary = str2cell(str.Text, char(10));

numLines = size(lstDiary, 1);

strModelLookup = '### Starting Real-Time Workshop build procedure for model: ';

iFileToAdd = 0;
lstFilesToAdd = {};

for iLine = 1:numLines
    curLine = lstDiary{iLine, :};

    % Retrieve Name of Model from Diary File:
    if(~isempty(strfind(curLine, strModelLookup)))
        strModel = curLine(length(strModelLookup)+1:end);
    end
    
    if(~isempty(strfind(curLine, '.c')))
        % It found either a .cpp or .c file
        ptrSlash = findstr(curLine, filesep);
        
        if(~isempty(ptrSlash))
            curFile = curLine(ptrSlash(end)+1:end);
        else
            ptrSpace = findstr(curLine, ' ');
            curFile = curLine(ptrSpace(end)+1:end);
        end
        
        curFileFull = [fldr_SharedUtils filesep curFile];
        
        if(exist(curFileFull))
            iFileToAdd = iFileToAdd + 1;
            lstFilesToAdd(iFileToAdd, 1) = { curFile };
        end
    end
end

lstFilesToAdd2 = unique(lstFilesToAdd);
[lstLower, sort_order] = sort(lower(lstFilesToAdd2));
lstFilesToAdd = lstFilesToAdd2(sort_order);

% Go back in and add the folder:
% for i = 1:size(lstFilesToAdd, 1)
%     curFileToAdd = lstFilesToAdd{i,:};
%     curFileToAddFull = [fldr_SharedUtils filesep curFileToAdd];
%     lstFilesToAdd(i,:) = { curFileToAddFull };
% end

% Begin File
fstr = ['Required MATLAB Shared Utility files for: ' strModel endl endl];
fstr = [fstr cell2str(lstFilesToAdd, endl) endl];

fstr = [fstr endl];
fstr = [fstr 'Total Files: ' num2str(size(lstFilesToAdd, 1)) endl];
fstr = [fstr 'All Files located in: ' fldr_SharedUtils endl];

if(isempty(filename))
    filename = [strModel '_Shared_Utilities'];
end

info.fname = [filename '.txt'];
info.fname = strrep(info.fname, '.txt.txt', '.txt');
info.fname_full = [location filesep info.fname];
info.text = fstr;

[fid, message ] = fopen(info.fname_full,'wt','native');
if fid == -1
    info.error = [mfnam '>> ERROR: File Not created: ' message];
    disp(info.error)
    fl = -1;
    return
else %any answer besides 'Y'
    fprintf(fid,'%s',fstr);
    fclose(fid);
    if(flgOpenAfterCreated)
        edit(info.fname_full);
    end
    fl = 0;
    info.OK = 'maybe it worked';
end

end % << End of function ParseDiaryForSharedUtils >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110211 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
