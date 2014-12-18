% UNITV computes the unit vector for a given vector.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% unitv:
%     Computes the unit vector from a given vector.
% 
% SYNTAX:
%	[unit] = unitv(vector)
%
% INPUTS: 
%	Name    	Size            Units           Description
%	vector      [Mx1] or [1xN]  [User Defined]  Input vector
%
% OUTPUTS: 
%	Name    	Size            Units           Description
%	unit	    [Mx1] or [1xN]  [User Defined]  Unit vector
%
% EXAMPLES:
%	Example 1: [1x2] with a Magnitude Check
%   vector = [1 1];
%	[unit] = unitv(vector);
%   magnitude = norm(unit);
%   Returns:
%   unit = [0.7071 0.7071];
%   magnitude = 1.0000;
%
%	Example 2: [3x1] with a Magnitude Check
%   vector = [1; 0; 1];
%	[unit] = unitv(vector);
%   magnitude = norm(unit);
%   Returns:
%   unit = [0.7071; 0; 0.7071];
%   magnitude = 1.0000;
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit unitv.m">unitv.m</a>
%	  Driver script: <a href="matlab:edit Driver_unitv.m">Driver_unitv.m</a>
%	  Documentation: <a href="matlab:pptOpen('unitv_Function_Documentation.pptx');">unitv_Function_Documentation.pptx</a> 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/429
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/unitv.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [unit] = unitv(vector)

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
unit= -1;

%% Input Argument Conditioning:

if nargin < 1
   disp([mfnam ' :: Please refer to useage of unitv' endl ...
       'Syntax: [unit] = unitv(vector)']);
   return;
end;

vec_test = size(vector);
if vec_test(1) ~= 1 && vec_test(2) ~= 1 || numel(vec_test) > 2
    errstr = [mfnam tab 'ERROR: Input is not a vector'];
    error([mfnam, 'CSA:unitv:Matrixin'], errstr);
end

if (isempty(vector))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'CSA:unitv:EmptyInput'],errstr);
end

if (ischar(vector))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'CSA:unitv:CharInput'],errstr);
end

%% Main Function:
normVector = norm( vector );
if(normVector > 0)
    unit = vector / normVector;
else
    unit = vector;
end

end % << End of function unitv >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101014 JPG: Added some error checking to the function.
% 101013 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
