% GIMBAL2POINTINGDIR converts Pointing Direction Centerline to Euler Angles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gimbal2PointingDir:
%     Converts Pointing Direction Centerline Vector to Euler Angles
% 
% SYNTAX:
%	[PointingDir] = Gimbal2PointingDir(GimbalPitch, GimbalYaw,PointingDirCL)
%
% INPUTS: 
%	Name         	Size	Units		Description
%   GimbalPitch     [1xN]   [rad]       The thrust gimbal pitch angle 
%   GimbalYaw       [1xN]   [rad]       The thrust gimbal yaw angle   
%   PointingDirCL   [3xN]   [ND]        The centerline of thrust before
%                                           gimbaling
% OUTPUTS: 
%	Name         	Size    Units		Description
%	PointingDir     [3xN]   [ND]        The centerline of thrust due to 
%                                       gimbal angles
% NOTES:
%	This calculation assumes that the instalation angle is fixed. The pointing
%	direction center line is a unit vector with its origin in the aircrafts
%	body frame. The resultant direction is also a unit vector with its
%	origin in the body reference frame. The conversion of the Gimbal angles
%	with respect to the thrust center line are done with a typical 321 dcm
%	rotation. Note, that the roll angle is always 0.
%
% EXAMPLES:
%	Example 1: Find the thrust pointing direction using one thruster
%   GimbalPitch=[pi/6]; GimbalYaw=[pi/4]; PointingDirCL=[1; 0; 0]
% 	[PointingDir] = Gimbal2PointingDir(GimbalPitch, GimbalYaw, PointingDirCL)
%	Results: PointingDir=[ 0.6124; 0.6124; -0.5000 ]
%
%	Example 2: Find the Thrust pointing direction of 2 engines with the
%	gimbal in the opposite direction
%   GimbalPitch=[pi/6 -pi/6]; GimbalYaw=[pi/4 -pi/4]; PointingDirCL=[1 1; 0 0; 0 0]
% 	[PointingDir] = Gimbal2PointingDir(GimbalPitch, GimbalYaw, PointingDirCL)
%	Results: PointingDir=[ 0.6124    0.6124
%                          0.6124   -0.6124
%                         -0.5000    0.5000 ];
% SOURCE DOCUMENTATION:
%   [1] Stevens, Brian L. Lewis, Frank L. Aircraft Control and
%	Simulation 2ed. John Wiley and Sons, New Jersey, 2003 pg. 26
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Gimbal2PointingDir.m">Gimbal2PointingDir.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gimbal2PointingDir.m">Driver_Gimbal2PointingDir.m</a>
%	  Documentation: <a href="matlab:pptOpen('Gimbal2PointingDir_Function_Documentation.pptx');">Gimbal2PointingDir_Function_Documentation.pptx</a>
%
% See also propForcesMoments 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/344
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/Gimbal2PointingDir.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [PointingDir] = Gimbal2PointingDir(GimbalPitch, GimbalYaw, PointingDirCL)

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

if nargin < 3
    PointingDirCL = zeros(3,length(GimbalPitch));
end
if ischar(GimbalPitch)||ischar(GimbalYaw)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

if length(GimbalPitch)~=length(GimbalYaw)
    errstr = [mfnam tab 'ERROR: Angles must be the same dimension [1xN]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end

%% Main Function:
for i = 1 : size(PointingDirCL, 2)
    PointingAngles(:, i) = vec2ang( PointingDirCL(:,i) )';
end

PointingDir(:, 1) = cos( GimbalPitch ) .* cos( GimbalYaw ) .* cos( PointingAngles(2, :) ) .* cos( PointingAngles(3, :) ) - ...
    cos( GimbalPitch ) .* sin( GimbalYaw ) .* sin( PointingAngles(3, :) ) - sin( GimbalPitch ) .* sin( PointingAngles(2, :) ) .* cos( PointingAngles(3, :) );

PointingDir(:, 2) = cos( GimbalPitch ) .* cos( GimbalYaw ) .* cos( PointingAngles(2, :) ) .* sin( PointingAngles(3, :) ) + ...
    cos( GimbalPitch ) .* sin( GimbalYaw ) .* cos( PointingAngles(3, :) ) - sin( GimbalPitch ) .* sin( PointingAngles(2, :) ) .* sin( PointingAngles(3, :) );

PointingDir(:, 3) = -cos( GimbalPitch ) .* cos( GimbalYaw ) .* sin( PointingAngles(2, :) ) - sin( GimbalPitch ) .* cos( PointingAngles(2, :) );

PointingDir = PointingDir';


end

%% REVISION HISTORY
% YYMMDD INI: note
% 101123 JJ:  Filled the description and units of the I/O added input check
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086

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
