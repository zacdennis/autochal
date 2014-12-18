% DISPSTRUCT Displays the contents of a structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% dispStruct:
%   Displays the contents of a MATLAB structure as a formatted string.
% 
% SYNTAX:
%	[str] = dispStruct(structure)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	structure	[N/A]                   MATLAB structure to display
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	str 	    [1xn]       [char]      Structure contents in string format
%
% NOTES:
%
% EXAMPLES:
%	% Create a sample structure and then display it
%   clear A;
%   A.a = 'Hi';
%   A.b.line1 = 'line1';
%   A.b.line2 = 'line2';
%   A.c.ref.a = 'a';
%   A.c.ref.b = 'b';
%   A.d.scalar = pi;
%   A.d.row_vector = [1 2 3];
%   A.d.col_vector = [1; 2; 3];
%   A.d.matrix = magic(3);
%
%   str = dispStruct(A)
%   % returns:
%   % A.a            = 'Hi'   
%   % A.b.line1      = 'line1'
%   % A.b.line2      = 'line2'
%   % A.c.ref.a      = 'a'    
%   % A.c.ref.b      = 'b'    
%   % A.d.scalar     = 3.1416 
%   % A.d.row_vector = 1  2  3
%   % A.d.col_vector = 1      
%   %                  2      
%   %                  3      
%   % A.d.matrix     = 8  1  6
%   %                  3  5  7
%   %                  4  9  2
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit dispStruct.m">dispStruct.m</a>
%	  Driver script: <a href="matlab:edit Driver_dispStruct.m">Driver_dispStruct.m</a>
%	  Documentation: <a href="matlab:winopen(which('dispStruct_Function_Documentation.pptx'));">dispStruct_Function_Documentation.pptx</a>
%
% See also listStruct, Cell2PaddedStr
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/750
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/dispStruct.m $
% $Rev: 2961 $
% $Date: 2013-05-31 16:47:28 -0500 (Fri, 31 May 2013) $
% $Author: sufanmi $

function [str] = dispStruct(structure)

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
lstStruct = listStruct(structure);

numMembers = size(lstStruct, 1);
tbl = cell(numMembers, 3);

input1 = inputname(1);
iRow = 0;
for iMember = 1:numMembers
    iRow = iRow + 1;
    tbl(iRow, 1) = { [input1 '.' lstStruct{iMember}] };
    tbl(iRow, 2) = { '=' };
    
    ec = ['structValue = structure.' lstStruct{iMember} ';'];
    eval(ec);
    
    if(ischar(structValue))
        tbl(iRow, 3) = { ['''' structValue ''''] };
    else
        numSize = size(structValue);
        switch length(numSize)
            case 1
                tbl(iRow, 3) = { [num2str(structValue)] };
            case 2
                nRow = numSize(1);
                if(nRow == 1)
                    tbl(iRow, 3) = { [num2str(structValue)] };
                else
                    for i = 1:nRow
                        tbl(iRow, 3) = { [num2str(structValue(i,:))] };
                        if(i < nRow)
                            iRow = iRow + 1;
                        end
                    end
                end
                    otherwise
                        disp(sprintf('%s : Warning : %d-dimensional tables are not currently supported.  Ignoring addition.', ...
                            mfnam, length(nSize)));
        end
    end
end

%% Compile Outputs:
str = Cell2PaddedStr(tbl, 'Padding', ' ');

end % << End of function dispStruct >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120224 MWS: Created function using CreateNewFunc
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
