% XLS_LETTER2NUM Converts an Excel Column Letter to Numerical Index
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% xls_letter2num:
%     Converts a Microsoft Excel column name (e.g. 'AA') to a numerical
%     index.  An index of 1 maps to column 'A'.  For indices over 26, a
%     second letter is included (e.g. 27 --> 'AA').  Note that only 702
%     indices are supported (i.e. 702 --> 'ZZ').
% 
% SYNTAX:
%	[num] = xls_letter2num(letter)
%
% INPUTS: 
%	Name    	Size                    Units		Description
%	letter      'string' or {'string'}  [char]      Excel column names to
%                                                    translate
%
% OUTPUTS: 
%	Name    	Size                    Units		Description
%	num 	    [1] or size(letter)     [int]       Mapped column index
%
% NOTES:
%
% EXAMPLES:
%	% Example 1: Convert some Excel column names to their column index:
%   % Step 1: Convert indices [1:53] to their Excel column name
%   arrIndices  = [1:53]
%   lstLetter   = xls_num2letter(arrIndices)
%
%   % Step 2: Convert the Excel column name back to indices
%   arrIndices2 = xls_letter2num(lstLetter)
%   deltaGood   = all(arrIndices - arrIndices2)
%
%	% Example 2: Error message handling
%   xls_letter2num('ZZZ')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit xls_letter2num.m">xls_letter2num.m</a>
%	  Driver script: <a href="matlab:edit Driver_xls_letter2num.m">Driver_xls_letter2num.m</a>
%	  Documentation: <a href="matlab:winopen(which('xls_letter2num_Function_Documentation.pptx'));">xls_letter2num_Function_Documentation.pptx</a>
%
% See also xls_num2letter 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/748
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/xls_letter2num.m $
% $Rev: 2323 $
% $Date: 2012-04-04 15:41:05 -0500 (Wed, 04 Apr 2012) $
% $Author: sufanmi $

function [num] = xls_letter2num(letter)

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
num= zeros(size(letter));

%% Main Function:
if(ischar(letter))
    lstLet = { letter };
else
    lstLet = letter;
end

numLet = numel(lstLet);

for iLet = 1:numLet
    curLet = lstLet{iLet};
    cur_num = 0;
    
    switch length(curLet)
        case 1
            % A --> Z
        cur_num = double(upper(curLet)) - 64;
        
        case 2
            % AA --> ZZ
       intBase = double(upper(curLet(1))) - 64;
       
       intRem = double(upper(curLet(2))) - 64;
       cur_num = intBase*26 + intRem;
            
        otherwise
            % AAA+ not supported
            disp(sprintf('%s : WARNING : Desired letter exceeds supported limit of ZZ (702).  Returning null.', ...
            mfilename, cur_num));
    end
    num(iLet) = cur_num;
end

if(numLet == 1)
    num = cur_num;
end

end % << End of function xls_letter2num >>

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
