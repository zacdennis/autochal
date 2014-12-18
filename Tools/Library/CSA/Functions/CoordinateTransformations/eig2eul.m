% EIG2EUL Converts Eigen Vector to Euler Angles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% eig2eul:
%     Converts Eigen Vector to Euler Angles
% 
% SYNTAX:
%	[eul] = eig2eul(eigen)
%
% INPUTS: 
%	Name		Size            Units		Description
%	eigen       [1x3] or [3x1]  [ND]        Eigen Vector
%	varargin	[N/A]           [varies]	Optional function inputs that
%                                           should be entered in pairs.
%                                           See the 'VARARGIN' section
%                                           below for more details
% OUTPUTS: 
%	Name		Size            Units		Description
%	 eul        [1x3]           [rad]       Euler Anles [Phi, Theta, Psi]
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	Example 1:
%	[eul] = eig2eul(eigen)
%	Returns 
%
%   Example 2:
%	[eul] = eig2eul(eigen)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit eig2eul.m">eig2eul.m</a>
%	  Driver script: <a href="matlab:edit Driver_eig2eul.m">Driver_eig2eul.m</a>
%	  Documentation: <a href="matlab:pptOpen('eig2eul_Function_Documentation.pptx');">eig2eul_Function_Documentation.pptx</a>
%
% See also eul2eig 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/328
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/eig2eul.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [eul] = eig2eul(eigen)

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
%% Input check
if ischar(eigen)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
% Initialize quaternion vector:
quat=zeros(4,1);

theta=norm(eigen);

if abs(theta)>eps
    ahat=eigen/theta;
else
    ahat = eigen * 0;
end

quat(1:3)=ahat*sin(theta/2);
quat(4)=cos(theta/2);

quat=quat/norm(quat);

eul = quat2eul( quat ); % [rad]

%% Check Size:
match = max(size(eigen) == size(eul));
if ~match
    eul = eul';
end
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/eig2eul.m
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
