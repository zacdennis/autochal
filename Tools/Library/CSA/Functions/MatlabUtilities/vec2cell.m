% VEC2CELL Converts a numeric vector into a column cell array
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vec2cell:
%     Converts a numeric vector into a column cell array
% 
% SYNTAX:
%	[lstItems] = vec2cell(vecItems)
%
% INPUTS: 
%	Name    	Size            Units           Description
%   vecItems    [1xN] or [Mx1]  [user defined]  Vector Input
%
% OUTPUTS: 
%	Name    	Size            Units           Description
%   lstItems    [Mx1]           [ND]            Vector in cell format
%
% NOTES:
%	None
%
% EXAMPLES:
%
%	% Example 1: Basic Usage (Row)
%	[lstItems] = vec2cell([1:3])
%   lstItems = 
%               '1'
%               '2'
%               '3'
%
%	% Example 2: Basic Usage (Column)
%	[lstItems] = vec2cell([1:3]')
%   lstItems = 
%               '1'
%               '2'
%               '3'
%
% SOURCE DOCUMENTATION:
% None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vec2cell.m">vec2cell.m</a>
%	  Driver script: <a href="matlab:edit Driver_vec2cell.m">Driver_vec2cell.m</a>
%	  Documentation: <a href="matlab:pptOpen('vec2cell_Function_Documentation.pptx');">vec2cell_Function_Documentation.pptx</a>
%
% See also str2cell
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/471
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21)
%                Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/vec2cell.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [lstItems] = vec2cell(vecItems)

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
if nargin < 1
   disp([mfnam ' :: Please refer to useage of' mfnam endl ...
       'Syntax: [lstItems] = vec2cell( vecItems )']);
   return;
end;



%% Main Function:
numItems = length(vecItems);

if iscell(vecItems)
    lstItems = vecItems;
    disp([mfnam ' >>WARNING: Input is a cell returning input.'])
elseif ~isnumeric(vecItems)
    disp([mfnam ' >>WARNING: Input is not numeric returning input.'])
    lstItems = vecItems;
else
    for iItem = 1:numItems
        curItem = vecItems(iItem);
        lstItems{iItem,:} = num2str(curItem);
    end
end

end % << End of function vec2cell >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101117 JPG: Made some minor formatting changes.
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
