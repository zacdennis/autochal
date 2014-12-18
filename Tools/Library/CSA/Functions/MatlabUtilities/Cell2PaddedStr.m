% CELL2PADDEDSTR Converts a Cell array strings into a single formatted
% string
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Cell2PaddedStr:
%   This function converts a cell array of strings into a single formatted
%   string such that the cell members are aligned vertically beneath their
%   column members.  To get the members to line up visual, extra spaces are
%   added between cell members.
%
% SYNTAX:
%	[str] = Cell2PaddedStr(lstInfo, varargin, 'PropertyName', PropertyValue)
%	[str] = Cell2PaddedStr(lstInfo, varargin)
%	[str] = Cell2PaddedStr(lstInfo)
%
% INPUTS:
%	Name    	Size		Units		Description
%	lstInfo     {MxN cell}  [char]      Cell array of strings to format
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS:
%	Name    	Size		Units		Description
%	str 	    'string'    [char]      Formatted String
%
% NOTES:
%	This function is supported by the CSA_Library functions:
%   format_varargin & spaces
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%   'CellDispMode'      'string'        false (0)   Output a formatted
%                                                    string that is capable
%                                                    of recreating the
%                                                    inputted cell
%   'CellDispName'      'string'        inputname(1) Name to use for cell
%                                                    if 'CellDispMode' is
%                                                    true
%	'Padding'           'string'        ' : '       String to place between
%                                                   cell strings (Only
%                                                   enabled if CellDispMode
%                                                   is false)
%   'Prefix'            'string'        ''          String to place in
%                                                   front of each line
%                                                   (Only enabled if
%                                                   CellDispMode is false)
%   'Suffix'            'string'        ''          String to place at end
%                                                   of each line (Only
%                                                   enabled if CellDispMode
%                                                   is false)
%   'RightJustifyText'  boolean         false (0)   Right justify the text
%   'SpaceAfterPad'     boolean         false (0)   For left justified
%                                                   text, insert the spaces
%                                                   after 'Padding'?
%
% EXAMPLES:
%	% Example #1: Convert a Cell array of strings into a formatted string
%   lstInfo = { 'Alt:',     '20000',    '[ft]';
%               'Alpha:',   '45',       '[deg]'};
%	[str] = Cell2PaddedStr(lstInfo, 'Padding', ' : ')
%   % Returns:    Alt:   : 20000 : [ft]
%   %             Alpha: : 45    : [deg]
%
%	% Example #2: Convert a Cell array of strings into a formatted string
%   lstInfo = { 'Alt:',     '20000',    '[ft]';
%               'Alpha:',   '45',       '[deg]'};
%	[str] = Cell2PaddedStr(lstInfo, 'Padding', ' ')
%   % Returns:    Alt:   20000 [ft]
%   %            Alpha: 45    [deg]
%
%   % Example #3: Convert the Cell array into a 'CellDisp' string
%   [str] = Cell2PaddedStr(lstInfo, 'CellDispMode', 1)
%
%   %   % Example #3: Convert the Cell array into a 'CellDisp' string but
%   %                 change the output name to 'hi'
%   [str] = Cell2PaddedStr(lstInfo, 'CellDispMode', 1, 'CellDispName', 'hi')
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Cell2PaddedStr.m">Cell2PaddedStr.m</a>
%	  Driver script: <a href="matlab:edit Driver_Cell2PaddedStr.m">Driver_Cell2PaddedStr.m</a>
%	  Documentation: <a href="matlab:winopen(which('Cell2PaddedStr_Function_Documentation.pptx'));">Cell2PaddedStr_Function_Documentation.pptx</a>
%
% See also format_varargin, spaces
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/664
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/Cell2PaddedStr.m $
% $Rev: 3056 $
% $Date: 2013-12-03 16:10:05 -0600 (Tue, 03 Dec 2013) $
% $Author: sufanmi $
function [str] = Cell2PaddedStr(lstInfo, varargin)
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
[CellDispMode, varargin]        = format_varargin('CellDispMode', 0, 2, varargin);
[CellDispName, varargin]        = format_varargin('CellDispName', inputname(1), 2, varargin);
[flgRightJustifyText, varargin] = format_varargin('RightJustifyText', false, 2, varargin);
[flgSpaceAfterPad, varargin]    = format_varargin('SpaceAfterPad', false, 2, varargin);

if(isempty(CellDispName))
    CellDispName = 'ans';
end

if(CellDispMode)
    strPrePad = ',';
    strPad = ' ';
    strSuffix = ';';
    strPrefix = tab;
else
    strPrePad = '';
    [strPad, varargin]  = format_varargin('Padding', '', 2, varargin);
    [strSuffix, varargin]  = format_varargin('Suffix', '', 2, varargin);
    [strPrefix, varargin]  = format_varargin('Prefix', '', 2, varargin);
end

if(ischar(lstInfo))
    lstInfo = { lstInfo };
end

%% Main Function:
%  <Insert Main Function>
[nrow, ncol] = size(lstInfo);
StrData = zeros(1,ncol);
for iCol = 1:ncol
    for iRow = 1:nrow
        if(iRow == 1)
            strLength = 0;
        end
        strCurr = lstInfo{iRow, iCol};
        
        if(CellDispMode)
            if(isnumeric(strCurr))
                strCurr = ['[' num2str(strCurr) ']'];
            else
                strCurr = ['''' strCurr ''''];
            end
        else
            if(isnumeric(strCurr))
                strCurr = num2str(strCurr);
            end
        end
        
        if(CellDispMode)
            if(iCol == 1)
                strCurr = [strPrefix strCurr strPrePad];
            elseif(iCol == ncol)
                % Do nothing
            else
                strCurr = [strCurr strPrePad];
            end
        end
        
        strLength = max(strLength, length(strCurr));
    end
    StrData(iCol) = strLength;
end
str = '';

if(CellDispMode)
    str = [CellDispName ' = {...' endl];
end

for iRow = 1:nrow
    str2add = [strPrefix];
    for iCol = 1:ncol
        strCurr = lstInfo{iRow,iCol};
        
        if(CellDispMode)
            
            if(isnumeric(strCurr))
                strCurr = ['[' num2str(strCurr) ']'];
            else
                strCurr = ['''' strCurr ''''];
            end
        else
            if(isnumeric(strCurr))
                strCurr = num2str(strCurr);
            end
        end
        
        if(CellDispMode)
            if(iCol == 1)
                strCurr = [strPrefix strCurr strPrePad];
            elseif(iCol == ncol)
                % Do nothing
            else
                strCurr = [strCurr strPrePad];
            end
        end
        
        strMax = StrData(iCol);
        lengthCurr = length(strCurr);
        strSpaces = spaces(strMax - lengthCurr);
        
        if(flgRightJustifyText)
            if(iCol < ncol)
                str2add = [strSpaces strCurr strPad];     %#ok<AGROW>
            else
                str2add = [strSpaces strCurr strSuffix endl];
            end
        else
            if(flgSpaceAfterPad)
                if(iCol < ncol)
                    str2add = [strCurr strPad strSpaces];     %#ok<AGROW>
                else
                    str2add = [strCurr strSuffix endl];
                end
            else
                if(iCol < ncol)
                    str2add = [strCurr strSpaces strPad];     %#ok<AGROW>
                else
                    str2add = [strCurr strSpaces strSuffix endl];
                end
            end
        end
        
        str = [str str2add]; %#ok<AGROW>
    end
end
if(CellDispMode)
    str = [str strPrefix '};' endl];
end

end % << End of function Cell2PaddedStr >>
%% REVISION HISTORY
% YYMMDD INI: note
% 101018 MWS: Function template created using CreateNewFunc
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
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
