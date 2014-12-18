% QUAT2EIG Converts Quaternion Vector to Eigen Vector
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% quat2eig:
%     Converts Quaternion Vector to Eigen Vector
% 
% SYNTAX:
%	[eigen] = quat2eig(quat)
%
% INPUTS: 
%	Name		Size            Units		Description
%   quat        [1x4]or[4x1]    [ND]        Quaternions [q1, q2, q3, q4]
%                                           q4 is scalar
% OUTPUTS: 
%	Name		Size            Units		Description
%	eigen       [1x3]or[3x1]    [ND]        Eigen Vector 
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	Example 1:      
%	[eigen] = quat2eig(quat)
%	Returns
%
%	Example 2:
%	[eigen] = quat2eig(quat)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit quat2eig.m">quat2eig.m</a>
%	  Driver script: <a href="matlab:edit Driver_quat2eig.m">Driver_quat2eig.m</a>
%	  Documentation: <a href="matlab:pptOpen('quat2eig_Function_Documentation.pptx');">quat2eig_Function_Documentation.pptx</a>
%
% See also eig2quaternion 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/354
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/quat2eig.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [eigen] = quat2eig(quat)

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
theta=2*acos(quat(4));

sin_half_theta=sin(theta/2);

if abs(sin_half_theta)>eps
    ahat=quat(1:3)/sin_half_theta;
else
    ahat=zeros(3,1);
end

eigen=theta*ahat;

%% Check Size:
sizequat = size(quat);
if (sizequat(2) > sizequat(1))
    eigen = eigen';
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/quat2eig.m
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
