% BANKANGLE Computes Bank Angle Mu from Alpha, Beta, Euler_ned
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BankAngle:
%     Computes Bank Angle Mu from Alpha, Beta, Euler_ned 
% 
% SYNTAX:
%	[Mu] = BankAngle(Alpha, Beta, Euler_ned)
%
% INPUTS: 
%	Name		Size             Units       Description
%	Alpha       [1x1]            [deg]       Angle of Attack
%   Beta        [1x1]            [deg]       Sideslip Angle
%   Euler_ned   [1x3] or [3x1]   [deg]       Euler Orientation in North East Down Frame
%
% OUTPUTS: 
%	Name		Size             Units		 Description
%	 Mu         [1x1]            [deg]       Bank Angle
%
% NOTES:
%	Mu is the flight path bank angle. It is defined as the angle between
%	the plane formed by the velocity vector and the lift vector, and the
%	vertical plane containing the velocity vector. Positive rotation is
%	clockwise, about the elocity vector looking forward. 
%
% EXAMPLES:
%	Example 1: An aircraft has an angle of attack of 20 degrees and a
%	sideslip of 15 degrees. If the euler angles are 45, 90 and 90 degrees
%	respectively. Find the bank angle Mu.
%   Alpha=20; Beta=15; Euler_ned=[45 90 90];
% 	[Mu] = BankAngle(Alpha, Beta, Euler_ned)
%	Returns Mu = 35.4166
%
%	Example 2: An aircraft has an angle of attack of 10 degrees and a
%	sideslip of -15 degrees. If the euler angles are 60, 30 and -90 degrees
%	respectively. Find the bank angle Mu.
%   Alpha=10; Beta=-15; Euler_ned=[60 30 -90];
% 	[Mu] = BankAngle(Alpha, Beta, Euler_ned)
%	Returns Mu = 50.2197
%
% SOURCE DOCUMENTATION:
% 	[1]    Kalviste, Juri. Flight Dynamics Reference Book. 
%          Northrop Grumman, Aircraft division. rev 06-30-89 1988 P.37
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit BankAngle.m">BankAngle.m</a>
%	  Driver script: <a href="matlab:edit Driver_BankAngle.m">Driver_BankAngle.m</a>
%	  Documentation: <a href="matlab:pptOpen('BankAngle_Function_Documentation.pptx');">BankAngle_Function_Documentation.pptx</a>
%
% See also calc_fp
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/316
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/BankAngle.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Mu] = BankAngle(Alpha, Beta, Euler_ned)

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

%% Input Check
if ischar(Alpha) || ischar(Beta) || ischar(Euler_ned)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
h = size(Euler_ned);
if ((h(1)>3) && (h(1) ~= 3))||((h(2)>3) && (h(2) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
R2D = 180.0/acos(-1);       % conversion radians to degrees

Phi     = Euler_ned(1);     % [deg]
Theta   = Euler_ned(2);     % [deg]
Psi     = Euler_ned(3);     % [deg]

Mu_num = cosd(Theta)*sind(Phi)*cosd(Beta) ...
    + sind(Theta)*cosd(Alpha)*sind(Beta) ...
    - cosd(Theta)*cosd(Phi)*sind(Alpha)*sind(Beta);

Mu_den = cosd(Theta)*cosd(Phi)*cosd(Alpha) + sind(Theta)*sind(Alpha);

Mu = atan2( Mu_num, Mu_den ) * R2D;
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/BankAngle.m
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
