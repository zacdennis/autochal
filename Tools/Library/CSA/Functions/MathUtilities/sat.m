% SAT Saturation function.  Limits input to user-defined limits.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% sat:
%     Saturation function.  Limits input to user-defined limits.
% 
% SYNTAX:
%	[x,i] = sat(x,limits)
%	
% INPUTS: 
%	Name		Size        	Units               Description
%	x   		[variable]		[user defined]		Input to be saturated
%	limits		[1x2] or [2x1]  [User Defined]		Lower and upper bounds
%										 
%
% OUTPUTS: 
%	Name		Size            Units               Description
%	x   		[variable]      [User defined]      Input adjusted to 
%                                                    lower/upper bounds
%	i   		[variable]      [none]              Saturation Flags where: 
%                                                    -1: Lower limit
%                                                     0: No saturation
%                                                     1: Upper limit
%
% NOTES:
% 'x' and 'i' will have the same dimensions.  These variables do not have
% set dimensions, hence the 'variable' tag.  Input 'x' can be singular [1], 
% a row/column vector ([1xN] or [Nx1]) or a multi-dimentional matrix 
%   ([M x N x P x ...]).
% 
% EXAMPLES:
%   Example 1: Singular Inputs
%   [s,i]= sat(5, [1 3])
%    returns s=3, i=1           %Filtered by upper limit
%
%   Example 2: Vectorized Inputs
%   [s,i]= sat([-1 5 15], [1; 10]) %note limits are in column form
%   returns s =[ 1     5    10]
%           i =[-1     0     1] % First and last elements were saturated
%
%   Example 3: Matrix Inputs
%    [s,i]= sat([-2 5 15; 1 23 -5; 15 5 -10], [1 10])
%   returns 
%           s =[ 1     5    10          i = [ -1     0     1
%                1    10     1                -1     1    -1
%               10     5     1 ]               1     0    -1 ]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit sat.m">sat.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_sat.m">DRIVER_sat.m</a>
%	  Documentation: <a href="matlab:pptOpen('sat_Function_Documentation.pptx');">sat_Function_Documentation.pptx</a>
%
% See also PlotBounds 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/427
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/sat.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [x,i] = sat(x,limits)

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

%% Initialize Outputs:
if nargin<2
    errstr = [mfnam tab 'ERROR: Must define Limits' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (isempty(x) || isempty(limits))
    errstr = [mfnam tab 'ERROR: One input is empty, Please define the limits as [lower upper]' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

if (ischar(x)||ischar(limits))
    errstr = [mfnam tab 'ERROR: Input  of type string or CHAR, Please insert a scalar' ]; %will term with error; "doc Error" ';
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
imax = (x >= limits(2));
imin = (x <= limits(1)) * -1;
i = imax + imin;

x = max( x, limits(1) );
x = min( x, limits(2) );

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100819  JJ: Filled in all the internal documentation and created examples  
% 100818 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

%% Initials Identification: 
% INI: FullName         : Email                             : NGGN Username 
%  JJ: jovany jimenez   : jovany.jimenez-deparias@ngc.com   : g67086 

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
