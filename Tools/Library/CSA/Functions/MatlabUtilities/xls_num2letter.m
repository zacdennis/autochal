% XLS_NUM2LETTER Converts a Numerical Index into an Excel Column Letter
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% xls_num2letter:
%     Converts a numerical index into a Microsoft Excel column name (e.g.
%     'AA').  An index of 1 maps to column 'A'.  For indices over 26, a
%     second letter is computed (e.g. 27 --> 'AA').  Note that only 702
%     indices are supported (i.e. 702 --> 'ZZ').
% 
% SYNTAX:
%	[letter] = xls_num2letter(num)
%
% INPUTS: 
%	Name    	Size                    Units		Description
%	num 	    [n]                     [int]       Numerical index of
%                                                    column to map
%
% OUTPUTS: 
%	Name    	Size                    Units		Description
%	letter      'string' or {'string'}  [char]      Mapped Excel column
%                                                    names
%
% NOTES:
%	If 'num' is scalar, 'letter' will be a string.  If 'num' is a vector
%	(either row or column), 'letter' will be a cell array of matching size.
%
% EXAMPLES:
%	% Example 1: Convert some indices to their Excel column name:
%   % Step 1: Convert indices [1:53] to their Excel column name
%   arrIndices  = [1:53]
%   lstLetter   = xls_num2letter(arrIndices)
%
%   % Step 2: Convert the Excel column name back to indices
%   arrIndices2 = xls_letter2num(lstLetter)
%   deltaGood   = all(arrIndices - arrIndices2)
%
%	% Example 2: Error message handling
%   xls_num2letter(1000)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit xls_num2letter.m">xls_num2letter.m</a>
%	  Driver script: <a href="matlab:edit Driver_xls_num2letter.m">Driver_xls_num2letter.m</a>
%	  Documentation: <a href="matlab:winopen(which('xls_num2letter_Function_Documentation.pptx'));">xls_num2letter_Function_Documentation.pptx</a>
%
% See also xls_letter2num 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/749
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/xls_num2letter.m $
% $Rev: 2323 $
% $Date: 2012-04-04 15:41:05 -0500 (Wed, 04 Apr 2012) $
% $Author: sufanmi $

function [letter] = xls_num2letter(num)
    
%% Main Function:
num = floor(num);
num = max(num, 1);

letter = cell(size(num));

for inum = 1:length(num)
    cur_num = num(inum);
    if(cur_num > 702)
        disp(sprintf('%s : WARNING : Desired index %d exceeds supported limit of 702 (ZZ).  Returning null.', ...
            mfilename, cur_num));
        cur_letter = '';
    elseif(cur_num > 26)
        intBase = ceil((cur_num-26)/26);
        letBase = char(intBase + 64);
        intRem = (cur_num-26) - ((intBase-1)*26);
        letRem = char(intRem + 64);
        cur_letter = [letBase letRem];
    else
        cur_letter  = char(cur_num + 64);
    end
    letter(inum) = { cur_letter };
end

if(length(num) == 1)
    letter = cur_letter;
end

end % << End of function xls_num2letter >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120404 MWS: Created function using CreateNewFunc
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
