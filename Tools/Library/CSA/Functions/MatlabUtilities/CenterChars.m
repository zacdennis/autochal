% CENTERCHARS String centering utility
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CenterChars:
%     This function centers a string or a cell array of strings
%
% SYNTAX:
%   [str] = CenterChars(str, width, centchar, strPrefix, strSuffix)
%   [str] = CenterChars(str, width, centchar, strPrefix)
%	[str] = CenterChars(str, width, centchar)
%	[str] = CenterChars(str, width)
%	[str] = CenterChars(str)
%
% INPUTS:
%	Name    	Size		Units           Description
%	str 	    'string' or {'strings'}     String(s) to center
%	width       [1]         [int]           Maximum width of string
%                                            Default: 67
%	centchar	[1]         [char]          Character to use to fill in
%                                            centering gaps
%                                            Default: '-'
%   strPrefix   'string'    [char]          String to add to beginning of
%                                            centered string
%                                            Default: ''
%   strSuffix   'string'    [char]          String to add to end of
%                                            centered string
%                                            Default: ''
%
% OUTPUTS:
%	Name    	Size		Units           Description
%	str 	    'string' or {'strings'}     Centered string(s)
%
% NOTES:
%   If a string is entered, a string will be returned.  If a cell array of
%   strings is entered, a cell array of strings will be returned.
%
% EXAMPLES:
%	Example #1: Center a single string.
%	CenterChars('This is my string', 30)
%   Returns:    '----- This is my string ------'
%
%	Example #2: Center a cell array of strings.
%	CenterChars({'This is my string';'Line2'}, 30)
%	Returns:    '----- This is my string ------'
%               '----------- Line2 ------------'
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CenterChars.m">CenterChars.m</a>
%	  Driver script: <a href="matlab:edit Driver_CenterChars.m">Driver_CenterChars.m</a>
%	  Documentation: <a href="matlab:pptOpen('CenterChars_Function_Documentation.pptx');">CenterChars_Function_Documentation.pptx</a>
%
% See also <add relevant functions>
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/665
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/CenterChars.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [str] = CenterChars(str, width, centchar, strPrefix, strSuffix)

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
    case 1
        strSuffix = ''; strPrefix = ''; centchar= ''; width= [];
    case 2
        strSuffix = ''; strPrefix = ''; centchar= '';
    case 3
        strSuffix = ''; strPrefix = ''; 
    case 4
        strSuffix = '';
    case 5
        % Nominal
end

if(isempty(centchar))
    centchar = '-';
end

if(isempty(width))
    width = 67;
end

% Increase the upper limit if it's a large cell array of strings
if(iscell(str))
    numRows = size(str, 1);
    for iRow = 1:numRows
        width = max(width, length(str{iRow,:}));
    end
end

%% Main Function:

if(iscell(str))
    numRows = size(str, 1);
    for iRow = 1:numRows
        % Recurse into CenterChars if it's a cell array of strings
        str(iRow,:) = { CenterChars( str{iRow,:}, width, centchar, strPrefix) };
    end
else
    lstr = length(str); % get length of input string
    if(lstr <= width)
        cc = sprintf(centchar(1));  % get character to use as centering char
        leadcc = floor((width-lstr)/2) - 1; %calc how many leadnig chars ('% ' and ' 'str)
        tailcc = width - lstr - leadcc - 1 -1; %trailng chars
        str = [strPrefix char(ones(1,leadcc))*cc ' ' str ' ' char(ones(1,tailcc))*cc strSuffix];
    end
end

end % << End of function CenterChars >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 MWS: Added Suffix string
% 101015 MWS: Added Prefix string
% 101014 MWS: Created function based on the CenterChars function originally
%               buried in CreateNewFunc.
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName         : Email                 : NGGN Username
% MWS: Mike Sufana      : mike.sufana@ngc.com   : sufanmi
% TKV: Travis Vetter    : travis.vetter@ngc.com : vettetr

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
