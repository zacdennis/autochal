% MINALL Returns the minimum value of the inputted array or matrix
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% minAll:
%     Returns the minimum value of the inputted array or matrix
% 
% SYNTAX:
%	[min_value] = minAll(mat)
%
% INPUTS: 
%	Name		Size		Units		Description
%	mat         [variable]  [ND]        Inputted Value(s)
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	min_value   [1]         [ND]        Minimum value found in 'mat'
%   ind         [1]         [int]       Index of 
%   ind_arr     [Variable]  [index]     Index of largest value in 'mat'
%
% NOTES:
%  Inputted 'mat' can be a row or column vector or a multi-dimensional
%  matrix (e.g. M x N x P).  This function will scale to the number of 
%  dimensions of 'mat'.  The outputed 'ind_arr' will have the same 
%  dimensions as 'mat'.
%
% EXAMPLES:
%	Example 1: Find the minimum value of a column vector
%   r=[2; 4; 7]
% 	[min_value, ind, ind_arr] = minAll(r)
%	Returns:    min_value = 2
%               ind       = 1
%               ind_arr   = [ 1  1 ]
%
%	Example 2: Find the minimum value of a 3D array
%   Table3D(:,:,1) = [  1  2  3;  
%                       4  5  6;
%                       7  8  9;
%                      10 11 12 ]; 
%   Table3D(:,:,2) = [ 11 12 13;
%                      14 15 16;
%                      17 18 19;
%                     -20 21 22 ];
% 	[min_value, ind, ind_arr] = minAll(Table3D)
%	Returns:    min_value = -20
%               ind       = 16
%               ind_arr   = [ 4 1 2 ]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit minAll.m">minAll.m</a>
%	  Driver script: <a href="matlab:edit Driver_minAll.m">Driver_minAll.m</a>
%	  Documentation: <a href="matlab:pptOpen('minAll_Function_Documentation.pptx');">minAll_Function_Documentation.pptx</a>
%
% See also maxAll 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/419
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/minAll.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [min_value, ind, ind_arr] = minAll(mat)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);
%% Input check
if ischar(mat)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end
%% Main Function:
ndim = ndims(mat);  % Retrieve Dimensions
ind = zeros(1, ndim);   % Initialize Output, index to max value

mat_new = mat;      % Initialize Output
for i = 1:ndim
    mat_new = min(mat_new);
end

% Output #1
min_value = mat_new;

if(nargout > 1)
    % Output #2
    ind = find(mat == mat_new);
end

if(nargout > 2)
    % Output #3
    ec = ['['];
    for i = 1:ndim
        ec = [ec 'ind_arr(' num2str(i) ')'];
        if(i < ndim)
            ec = [ec ', '];
        else
            ec = [ec '] = ind2sub(size(mat), find(mat == mat_new));'];
        end
    end
    eval(ec);

end % < End of maxAll Function >

end % < End of minAll Function >

%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 100610 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATH_UTILITIES/minAll.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

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
