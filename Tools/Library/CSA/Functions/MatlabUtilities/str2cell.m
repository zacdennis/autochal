% STR2CELL Converts a string into a cell array
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% str2cell:
%     Converts a string with a user-defined separator into a cell array
% 
% SYNTAX:
%	[lstItems] = str2cell(strItems, strSep, strIgnore)
%	[lstItems] = str2cell(strItems, strSep)
%	[lstItems] = str2cell(strItems)
%
% INPUTS: 
%	Name     	Size            Units   Description
%   strItems                    [ND]    Character string array of the cell 
%                                        members
%   strSep      [string]        [ND]    String Separation {Default is a 
%                                        comma}
%   strIgnore   [string]        [ND]    Cell Members to Avoid putting into
%                                        string form
%
% OUTPUTS: 
%	Name     	Size            Units   Description
%   lstItems    {cell array}    [ND]    List to put into a string
%
% NOTES:
%	If 'strItems' is already a cell array, 'lstItems' will be the
%   inputted string (lstItems = strItems).
%
% EXAMPLES:
%	% Example 1: Basic Use
%	[lstItems] = str2cell( 'one,two,three;four,five,six' )
%	lstItems =
%     'one'
%     'two'
%     'three;four'
%     'five'
%     'six'
%
%	% Example 2: Using a Different Seperator 
%	[lstItems] = str2cell( 'one,two,three;four,five,six', ';')
%	lstItems =
%     'one,two,three'
%     'four,five,six'
%
%	% Example 3: Excluding Members 
%	[lstItems] = str2cell( 'one,two,three;four,five,six', ',', 't')
%	lstItems =
%     'one'
%     'five'
%     'six'
%
% SOURCE DOCUMENTATION:
%   None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit str2cell.m">str2cell.m</a>
%	  Driver script: <a href="matlab:edit Driver_str2cell.m">Driver_str2cell.m</a>
%	  Documentation: <a href="matlab:pptOpen('str2cell_Function_Documentation.pptx');">str2cell_Function_Documentation.pptx</a>
%
% See also cell2str
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/468
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) 
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/str2cell.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstItems] = str2cell(strItems, strSep, strIgnore)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

%% Initialize Outputs:
% lstItems= -1;

%% Input Argument Conditioning:
if nargin < 1
   disp([mfnam ' :: Please refer to useage of' mfnam endl ...
       'Syntax: [lstItems] = str2cell( strItems, strSep, strIgnore)' endl...
       '        [lstItems] = str2cell( strItems, strSep)' endl ...
       '        [lstItems] = str2cell( strItems )']);
   return;
end;

if nargin < 3
    strIgnore = '';
end

if nargin < 2
    strSep = '';
end

if(isempty(strSep))
    strSep = ',';
end

if(isnumeric(strItems))
    disp([mfnam ' >>WARNING: Input is a numeric value.'])
end
if(iscell(strItems))
    disp([mfnam ' >>WARNING: Input is already a cell.'])
    lstItems = strItems;
else
    
%% Main Function:    
    if(isempty(strItems))
        lstItems = {};
    else
        
        ptrSep = findstr(strItems, strSep);
        
        if(isempty(ptrSep))
            lstItems = { strItems };
        else
            
            % Check to see if last segment has end separator
            if(ptrSep(end) < length(strItems))
                ptrSep = [ptrSep (length(strItems)+1)];
            end
            
            numItems = length(ptrSep);
            
            ictr = 0;
            for iItem = 1:numItems
                if(iItem == 1)
                    ptrBegin = 1;
                else
                    ptrBegin = ptrSep(iItem-1) + length(strSep);
                end
                ptrEnd = ptrSep(iItem) - 1;
                
                curItem = strItems(ptrBegin:ptrEnd);
                
                if(isempty(strfind(curItem, strIgnore)))
                    ictr = ictr + 1;
                    
                    lstItems(ictr,:) = { curItem };
                end
            end
        end
    end
end

end % << End of function str2cell >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101117 JPG: Added some warnings to the function
% 101025 JPG: Used CreateNewFunc to update internal documentation for CSA
% 100331 MWS: Originally created function for the VSI_LIB
%               https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/str2cell.m
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
