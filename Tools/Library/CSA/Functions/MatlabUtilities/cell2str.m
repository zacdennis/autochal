% CELL2STR Converts a string cell array to a string with defined separators
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% cell2str:
%     Converts a cell array into a single string with a user-defined
%     separator
%
% SYNTAX:
%	[strItems] = cell2str(lstItems, strSep, strIgnore)
%	[strItems] = cell2str(lstItems, strSep)
%
% INPUTS:
%	Name     	Size            Units	Description
%   lstItems    {Mx1} or {1XN}          List to put into a string
%   strSep      [string]                String Separation {Default is a
%                                        comma}
%   strIgnore   [string]                Cell Members to Avoid putting into
%                                        string form
%
% OUTPUTS:
%	Name     	Size            Units	Description
%   strItems                            Character string array of the cell
%                                        members
% NOTES:
%	If 'lstItems' is not a cell (e.g. string), strItems will be the
%   inputted string (strItems = lstItems).
%
% EXAMPLES:
%	% Convert a simple cell array into a string
%   lstItems = {'This'; 'is'; 'my'; 'string'}
%
%   Example 1:
%   % Using the defaults...
%	[strItems] = cell2str(lstItems)
%   strItems =
%       This,is,my,string
%
%   Example 2:
%   % Specifying the separator to be a space...
%	[strItems] = cell2str(lstItems, ' ')
%   strItems =
%       This is my string
%
%   Example 3:
%   % Specifying the separator and ignoring any cell member containing 'is'
%	[strItems] = cell2str(lstItems, ' ', 'is')
%   strItems =
%       my string
%
% SOURCE DOCUMENTATION:
%   None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit cell2str.m">cell2str.m</a>
%	  Driver script: <a href="matlab:edit Driver_cell2str.m">Driver_cell2str.m</a>
%	  Documentation: <a href="matlab:pptOpen('cell2str_Function_Documentation.pptx');">cell2str_Function_Documentation.pptx</a>
%
% See also str2cell
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/438
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/cell2str.m $
% $Rev: 2597 $
% $Date: 2012-11-01 16:13:08 -0500 (Thu, 01 Nov 2012) $
% $Author: sufanmi $

function [strItems] = cell2str(lstItems, strSep, strIgnore)

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
if nargin < 3
    strIgnore = '';
end

if nargin < 2
    strSep = '';
end

if(isempty(strSep))
    strSep = ',';
end

if(~iscell(lstItems))
    strItems = lstItems;
else
    
    if(isempty(lstItems))
        strItems = '';
    else
        
        [numRows, numCols] = size(lstItems);
        
        ictr = 0;
        for iRow = 1:numRows
            for iCol = 1:numCols
                
                curItem = lstItems{iRow, iCol};
                if(isnumeric(curItem))
                    curItem = num2str(curItem);
                end
                
                
                if(isempty(strfind(curItem, strIgnore)))
                    ictr = ictr + 1;
                    
                    if(ictr == 1)
                        strItems = curItem;
                    else
                        strItems = sprintf('%s%s%s', strItems, strSep, curItem);
                    end
                end
            end
        end
    end
end

end % << End of function cell2str >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110125 JPG: CoSMO'd the function
% 101025 JPG: Used CreateNewFunc to standardize internal documentation for CSA
% 081029 MWS: Originally created function for VSI_LIB
%               https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/cell2str.m
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName             :  Email                :  NGGN Username
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWS: Mike Sufana          :  mike.sufana@ngc.com  :  sufanmi

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
