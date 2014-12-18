% CALC_FP Calculate flight Path variables
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% calc_fp:
%     Calculate flight Path variables
% 
% SYNTAX:
%	[alpha, beta, mu, gamma, chi] = calc_fp(Vrel_b, Veci, EulerNED, units)
%   [alpha, beta, mu, gamma, chi] = calc_fp(Vrel_b, Veci, EulerNED)
%
% INPUTS: 
%	Name		Size		Units           Description
%	Vrel_b      [1x3]       [length/time]   Relative Velocity in Body Frame
%   Veci        [1x3]       [length/time]   Velocity in Central Body Inertial
%                                           Frame
%   EulerNED    [1x3]       [deg]           Euler Orientation in North East
%                                           Down Frame
%   units       [1x1]       [ND]            Specifies input/output 
%                                           units (either 'degrees' or 'radians')
%                                         
%                                                           default = 'deg': degrees                                                             g'= degrees
% OUTPUTS: 
%	Name		Size		Units           Description
%	alpha       [1x1]       [deg]           Angle of Attack 
%   beta        [1x1]       [deg]           Sideslip Angle
%   mu          [1x1]       [deg]           Bank angle about velocity vector
%   gamma       [1x1]       [deg]           Vertical Flight path angle
%	chi 		[1x1]		[deg]           Horizontal Flight path angle (heading) 
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	Example 1:
%	[alpha, beta, mu, gamma, chi] = calc_fp(Vrel_b, Veci, EulerNED, units)
%	Returns
%
%	Example 2:
%	[alpha, beta, mu, gamma, chi] = calc_fp(Vrel_b, Veci, EulerNED, units,)
%	Returns 
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit calc_fp.m">calc_fp.m</a>
%	  Driver script: <a href="matlab:edit Driver_calc_fp.m">Driver_calc_fp.m</a>
%	  Documentation: <a href="matlab:pptOpen('calc_fp_Function_Documentation.pptx');">calc_fp_Function_Documentation.pptx</a>
%
% See also BankAngle 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/317
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/calc_fp.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [alpha, beta, mu, gamma, chi] = calc_fp(Vrel_b, Veci, EulerNED, units)

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

%% Input check:

if nargin<4,units='deg';end
if strcmp(units,'deg')
  units_sf=180/pi;
else
  units_sf=1;
end

%% Main Function:
U = Vrel_b(1);
V = Vrel_b(2);
W = Vrel_b(3);
phi   = EulerNED(1)/units_sf;
theta = EulerNED(2)/units_sf;

alpha=unwrap(atan2(W,U));
beta=atan2(V,sqrt(U^2+W^2));

sa=sin(alpha);ca=cos(alpha);
sb=sin(beta); cb=cos(beta);
sp=sin(phi);  cp=cos(phi);
st=sin(theta);ct=cos(theta);

gamma=asin(cb*(st*ca-ct*cp*sa)-ct*sp*sb);
mu  =atan2(sb*(st*ca-ct*cp*sa)+ct*sp*cb,ct*cp*ca+st*sa);
chi =sign(Veci(2))*acos(Veci(1)/norm(Veci));

alpha=alpha*units_sf;
beta =beta*units_sf;
mu   =mu*units_sf;
gamma=gamma*units_sf;
chi  =chi*units_sf;
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/calc_fp.m
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
