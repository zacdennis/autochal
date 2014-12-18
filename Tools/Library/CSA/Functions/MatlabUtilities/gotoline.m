% GOTOLINE Opens a File in the MATLAB Editor at a Specified Line Number
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% gotoline:
%     This function opens the specified text file in the MATLAB editor and
%     goes to a specified section of the file.  This section can be defined
%     by either a line number or a string.  If the input is a string, the
%     file is searched first for all instances of the string and the line
%     number of the first found string is then used.
%
% SYNTAX:
%	[] = gotoline(filename, lineSearch)
%	[] = gotoline(filename)
%
% INPUTS:
%	Name      	Size                Units               Description
%	filename	'string'            [char]              Filename to open
%	lineSearch	[1] or 'string'     [int] or [char]     Either the line
%                                                       number to open to
%                                                       or the string to
%                                                       search for
% OUTPUTS:
%	Name            Size            Units               Description
%	None
%
% NOTES:
%	This function uses the CSA Library function str2cell and MATLAB's
%	editor services class, which is MATLAB version specific.
%   2010b & older: editorservices
%   2011a & newer: matlab.desktop.editor
%
% EXAMPLES:
%	% Open this function to line #10 (e.g. specify exact line)
%	gotoline('gotoline.m', 10)
%
%	% Open this function to the 'INPUTS' line (e.g. force a search 1st)
%	gotoline('gotoline.m', 'INPUTS')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit gotoline.m">gotoline.m</a>
%	  Driver script: <a href="matlab:edit Driver_gotoline.m">Driver_gotoline.m</a>
%	  Documentation: <a href="matlab:winopen(which('gotoline_Function_Documentation.pptx'));">gotoline_Function_Documentation.pptx</a>
%
% See also str2cell, editorservices (<=r2010b), matlab.desktop.editor (2011a+)
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/667
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: $
% $Rev: $
% $Date: $
% $Author: $

function gotoline(filename, lineSearch)

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
switch(nargin)
    case 0
        errstr = [mfnam '>> ERROR: Need to know filename. See ' mlink ' help'];
        error([mfnam 'class:file:InputArgCheck'], errstr);    % Call error function with error string
    case 1
        lineSearch= '';
end

if(isempty(lineSearch))
    lineSearch = 1;
end

%% Main Function:
if(isnumeric(lineSearch))
    lineNumber = lineSearch(1);
else
    % Open the file and retrieve its text
    try
        % 2011a & later
        filedata = matlab.desktop.editor.openDocument(which(filename));
    catch
        % 2010b & earlier
        filedata = editorservices.open(which(filename));
    end
    cellText = str2cell(filedata.Text, endl);
    % Find all instances of desired string
    arrMatch = strfind(cellText, lineSearch);
    
    flgMatchFound = ~isempty(strfind(filedata.Text, lineSearch));
    
    iMatch = 0; lstMatch = [];
    if(flgMatchFound)
        % Desired String Exists, Figure out the line
        for iLine = 1:size(arrMatch)
            curLine = arrMatch{iLine};
            if(~isempty(curLine))
                iMatch = iMatch + 1;
                lstMatch(iMatch) = iLine;
            end
        end
        
        lineNumber = lstMatch(1);
        
    else
        % Didn't find the desired string
        lineNumber = 1;
    end
end

try
    % 2011a & newer
    matlab.desktop.editor.openAndGoToLine(which(filename), lineNumber);
catch
    % 2010b & older
    editorservices.openAndGoToLine(which(filename), lineNumber);
end
end % << End of function gotoline >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101118 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName      : Email                : NGGN Username
% MWS: Mike Sufana   : mike.sufana@ngc.com  : sufanmi

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
