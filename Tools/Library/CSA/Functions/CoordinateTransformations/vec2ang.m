% VEC2ANG  Converts a pointing vector into its Euler Angle equivalent.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% vec2ang:
%     Converts a pointing vector into its Euler Angle equivalent.
% 
% SYNTAX:
%	[eul] = vec2ang(vec)
%
% INPUTS: 
%	Name		Size		Units		Description
%   vec         [1x3]       [ND]        Vector
%
% OUTPUTS: 
%	Name		Size		Units		Description
%	eul         [1x3]       [rad]       Euler Angles [Phi, Theta, Psi]
%                                       with respect to a body frame where:
%                                             x - positive out nose
%                                             y - positive out right wing
%                                             z - positive down
% NOTES:
%	Euler angles are in radians. Size can be [1x3] or [3x1] depending on
%	the input. This function assumes both coordinate origins coincide.
%
% EXAMPLES:
%	Example 1: Vector coordinates are [15 30 45]. Find the euler angles.
%   vec=[15 30 45]
% 	[eul] = vec2ang(vec)
%	Returns  eul = [0   -0.9303    1.1071]
%
%	Example 2: Vector coordinates are [15 30 45] and [ 5 3 10]. Find the euler angles.
%   vec=[15 30 45]
%   vec=[5 3 10]
% 	[eul] = vec2ang(vec)
%	Returns  eul = [0   -0.9303    1.1071]
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit vec2ang.m">vec2ang.m</a>
%	  Driver script: <a href="matlab:edit Driver_vec2ang.m">Driver_vec2ang.m</a>
%	  Documentation: <a href="matlab:pptOpen('vec2ang_Function_Documentation.pptx');">vec2ang_Function_Documentation.pptx</a>
%
% See also ang2vec 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/363
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/vec2ang.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [eul] = vec2ang(vec)

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
if ischar(vec)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
vec = unitv(vec);

eul(1) = 0;                                     % [rad] Phi
eul(2) = atan2( -vec(3), ...
    sqrt( vec(1)*vec(1) + vec(2)*vec(2) ) );    % [rad] Theta
eul(3) = atan2( vec(2), vec(1) );               % [rad] Psi

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/vec2ang.m
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
