% QUATDIV Division of the quaternion vectors A and B
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% QuatDiv:
%     Division of the quaternion vectors A and B
% 
% SYNTAX:
%	[quat] = QuatDiv(quatA, quatB)
%
% INPUTS: 
%	Name		Size            Units		Description
%	quatA       [1x4]or[4x1]    [ND]        Quaternion vector A
%   quatB       [1x4]or[4x1]    [ND]        Quaternion vector B
%	
% OUTPUTS: 
%	Name		Size			Units		Description
%	quat		[1x4]or[4x1]	[ND]        Quotient of quatA and quatB 
%
% NOTES:
%	Quaternion division is not commutative. The reciprocal of a unit vector
%	is the vector reversed (i.e 1/i = -i). The 4th element of each
%	quaternion is a scalar. 
%
% EXAMPLES:
%	Example 1: Divide quaternion A by quaternion B. Row Input
%   quatA=[ 10 20 30 40]; quatB=[5 10 3 4];
% 	[quat] = QuatDiv(quatA, quatB)
%	Returns quat = [2.6667   0    2.9333   -0.5333]
%
%	Example 2: Prove that quaternion division is not commutative by
%	dividing quatA/quatB and then quatB/quatA
%	[quat] = QuatDiv(quatA, quatB,)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit QuatDiv.m">QuatDiv.m</a>
%	  Driver script: <a href="matlab:edit Driver_QuatDiv.m">Driver_QuatDiv.m</a>
%	  Documentation: <a href="matlab:pptOpen('QuatDiv_Function_Documentation.pptx');">QuatDiv_Function_Documentation.pptx</a>
%
% See also QuatMult QuatInv QuatTrans 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/356
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/QuatDiv.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [quat] = QuatDiv(quatA, quatB)

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

%% Input checks

if length(quatA)~=length(quatB)
     error([mfnam ':InputArgCheck'], ['Inputs must be of same length! See ' mlink ' documentation for help.']);
end
if ischar(quatA)||ischar(quatB)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Velocity must be expressed in scalar form.')
end
%% Main Function:
q1 = quatA(1);
q2 = quatA(2);
q3 = quatA(3);
q0 = quatA(4);

%quatB
r1 = quatB(1);
r2 = quatB(2);
r3 = quatB(3);
r0 = quatB(4);

num1 = r1*q1 + r2*q1 + r3*q3 + r0*q0;
num2 = r1*q2 - r2*q1 - r3*q0 + r0*q3;
num3 = r1*q3 + r2*q0 - r3*q1 - r0*q2;
num4 = r1*q0 - r2*q3 + r3*q2 - r0*q1;
num = [num1 num2 num3 num4];

den = r1^2 + r2^2 + r3^2 + r0^2;

quat = num./den;

end
%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/QuatDiv.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : G67086
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
