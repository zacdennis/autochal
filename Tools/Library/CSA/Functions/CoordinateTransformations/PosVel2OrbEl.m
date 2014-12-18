% POSVEL2ORBEL Computes new Position, Velocity, and Gamma for an Elliptical
% Orbit
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PosVel2OrbEl:
%    Computes new Position, Velocity, and Gamma for an Elliptical Orbit
% 
% SYNTAX:
%	[OrbEl] = PosVel2OrbEl(P_i, V_i, GM, OrbEl)
%	[OrbEl] = PosVel2OrbEl(P_i, V_i, GM)
%
% INPUTS: 
%	Name		Size                 Units              Description
%	P_i         [3x1]or[1x3]         [length]           Position in Central Body Inertial
%                                                       Frame
%   V_i         [3x1]or[1x3]         [length/time]      Velocity in Central Body Inertial
%                                                       Frame
%   GM      	[1x1]                [length^3/time^2]  Central Body Gravitational Constant
%                                                           Default=
%                                                                   OrbEl=[] (all)                                                           all)
%
% OUTPUTS: 
%	Name            Size             Units              Description
%	OrbEl           [structure]                         Orbital Elements Structure
%    .a             [1x1]            [length]           Semi-major Axis
%    .e             [1x1]            [ND]               Eccentricity
%    .theta         [1x1]            [deg]              True Anomaly
%    .RAAN          [1x1]            [deg]              Right Ascension Longitude of
%                                                       the Ascending node
%    .i             [1x1]            [deg]              Inclination
%    .omega         [1x1]            [deg]              Argument of the Perigee
%    .deltaT        [1x1]            [sec]              Time since Perigee Passage
%    .capE          [1x1]            [deg]              Eccentric Anomaly
%    .rp            [1x1]            [length]           Radius of Perigee
%    .ra            [1x1]            [length]           Radius of Apogee
%    .b             [1x1]            [length]           Semi-minor Axis
%    .P             [1x1]            [length]           Semilatus rectum
%    .period        [1x1]            [sec]              Period of Orbit
%    .n             [1x1]            [rad/sec]          Mean Motion
%    .M             [1x1]            [deg]              Mean Anomaly
%    .omega_defined [1x1]            [bool]             Argument of Perigee Defined*
%    .RAAN_defined  [1x1]            [bool]             RAAN Defined*
%
% NOTES:
%   This function is NOT unit specific.  Unit specific outputs will be
%   based on the units of the inputs.  Standard METRIC or ENGLISH units
%   should be used.
%
%   This function ONLY works for ELLIPTICAL orbits.
%	*Omega is undefined for perfectly circular (e = 0) and equatorial
%   orbits (i = 0)
%   *RAAN is undefined for equatorial orbits (i = 0)
%
% EXAMPLES:
%	Example 1:
%	[OrbEl] = PosVel2OrbEl(P_i, V_i, GM, OrbEl)
%	Returns
%
%	Example 2:
%	[OrbEl] = PosVel2OrbEl(P_i, V_i, GM, OrbEl)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1] Wie, Bong.  Space Vehicle Dynamics and Control.  AIAA Education
%     Series.  Reston, VA, 1998.
%
%   [2]Larson, Wiley J.  Human Spaceflight: Mission Analysis and Design.
%     McGraw-Hill Companies, Inc.
%
%   [3] Vallado, David A.  Fundamentals of Astrodynamics and Applications.
%    McGraw-Hill Companies, Inc. 1997. (pg. 146)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit PosVel2OrbEl.m">PosVel2OrbEl.m</a>
%	  Driver script: <a href="matlab:edit Driver_PosVel2OrbEl.m">Driver_PosVel2OrbEl.m</a>
%	  Documentation: <a href="matlab:pptOpen('PosVel2OrbEl_Function_Documentation.pptx');">PosVel2OrbEl_Function_Documentation.pptx</a>
%
% See also OrbEl2PosVel 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/353
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/PosVel2OrbEl.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [OrbEl] = PosVel2OrbEl(P_i, V_i, GM, OrbEl)

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
conversions;        % Load Unit Conversions

if(nargin < 4)
    OrbEl = [];
end

%% Compute Position and Velocity Magnitudes:
R = norm( P_i );
V = norm( V_i );

%% Compute Specific Angular Momentum, [length^2/sec]:
%   {Ref 1., Eq. 3.63, pg. 227}
Hvec = cross( P_i, V_i);

%% Compute Inclination, [rad]:
%   {Ref 2., Table 9-4, pg. 221}
i = acos( Hvec(3)/norm(Hvec) );

%% Compute RAAN, [rad]:
%   {Ref 2., Eq. 9-8, pg. 220}
nvec = cross([0 0 1], Hvec);
    
%  Check for division by zero:
if norm(nvec) > 0
    % {Ref 2., Table 9-4, pg. 221}
    RAAN = acos( nvec(1)/norm(nvec) );

    % Quadrant Check:
    if (nvec(2)<0)
        RAAN = 2*pi - RAAN;
    end
else
    RAAN = 0;
end

%% Compute Eccentricity, [ND]:
%   {Ref 1., Eq. 3.64, pg. 227}
evec = ( cross(V_i, Hvec) - (GM/R)* P_i ) /GM;
e = norm(evec);

%% Compute Argument of Perigee, [rad]:
%   {Ref 2., Table 9-4, pg. 221}
if ((norm(nvec)*e) > 0)
    omega = acos( (dot(nvec,evec)) / (norm(nvec)*e) );
    
    omega = real(omega);
        
    % Quadrant Check:
    if (evec(3)<0)
        omega = 2*pi - omega;
    end
else
    % Special Case: 
    %   Elliptical equatorial
    if (e > 0)
        omega = acos( evec(1)/e );
        
        % Quadrant Check:
        if (evec(2) < 0)
            omega = 2*pi - omega;
        end
    else
        % Omega not defined for perfectly circular orbits:
        omega = 0;
    end
end

%% Compute Orbit Energy, [length^2/sec^2]:
%   {Ref 1., Eq. 3.65, pg. 227}
spEnergy = (V^2)/2 - (GM/R);

%% Compute Semi-major Axis, [length]:
%   {Ref 1., Eq. 3.66, pg. 227}
a = -GM/(2*spEnergy);

%% Compute Current True Anomaly, [rad]:
%   {Ref 1., Eq. 3.71, pg. 228}
if(e>0)
    theta = acos(( dot(P_i, evec) )/(R*e));   
    theta = real(theta);
    
    % Quadrant Check:
    if( dot(P_i, V_i) < 0 )
        theta = 2*pi - theta;
    end
    
else
    % Circular Orbit
    theta = atan2( P_i(2), P_i(1) );
end

%% Compute Eccentric Anomaly, [ND]:
%   {Ref 1., Eq. 372, pg. 228}
capE = 2*atan(sqrt((1-e)/(1+e))*tan(theta/2));

%% Compute Mean Motion, [rad/sec]:
%   {Ref 1., Eq. 3.59b, pg. 223}
n = sqrt( GM /(a^3) );

%% Compute Time Since Perigee, [sec]:
%   {Ref 1., Eq. 3.73, pg. 228}
deltaT = ( capE - e*sin(capE) )/n;

period = (2*pi)*sqrt( (a^3)/GM );

deltaT = mod(deltaT, period);
deltaT2 = period - deltaT;

%% Create Orbital Elements Structure:
OrbEl.AllUnits.a        = '[length]';
OrbEl.AllUnits.e        = '[ND]';
OrbEl.AllUnits.theta    = '[deg]';
OrbEl.AllUnits.RAAN     = '[deg]';
OrbEl.AllUnits.i        = '[deg]';
OrbEl.AllUnits.omega    = '[deg]';
OrbEl.AllUnits.deltaT   = '[sec]';
OrbEl.AllUnits.time2rp  = '[sec]';
OrbEl.AllUnits.capE     = '[deg]';
OrbEl.AllUnits.rp       = '[length]';
OrbEl.AllUnits.ra       = '[length]';
OrbEl.AllUnits.b        = '[length]';
OrbEl.AllUnits.P        = '[length]';
OrbEl.AllUnits.period   = '[sec]';
OrbEl.AllUnits.n        = '[rad/sec]';
OrbEl.AllUnits.M        = '[deg]';

OrbEl.a         = a;                        % Semi-major axis
OrbEl.e         = e;                        % Orbit Eccentricity
OrbEl.theta     = wrap360(theta * C.R2D);   % True Anomaly
OrbEl.RAAN      = wrap360(RAAN * C.R2D);    % Right Ascension Ascending Node
OrbEl.i         = i * C.R2D;                % Inclination
OrbEl.omega     = wrap360(omega * C.R2D);   % Argument of Perigee
OrbEl.deltaT    = deltaT;                   % Time since Perigee
OrbEl.time2rp   = deltaT2;                  % Time To Perigee
OrbEl.capE      = wrap360(capE * C.R2D);    % Eccentric Anomaly
OrbEl.rp        = a*(1-e);                  % Radius of Perigee
OrbEl.ra        = a*(1+e);                  % Radius of Apogee
OrbEl.b         = a*sqrt(1-e^2);            % Semi-minor axis
OrbEl.P         = a*(1-e^2);                % Semilatus rectum
OrbEl.period    = (2*pi)*sqrt( (a^3)/GM );  % Orbit Period
OrbEl.n         = n;                        % Mean Motion
OrbEl.M         = wrap360((capE - e*sin(capE)) * C.R2D); % Mean Anomaly

% Check if omega is defined:
if (i == 0) || (e == 0)
    OrbEl.omega_defined = 0;
else
    OrbEl.omega_defined = 1;
end

% Check if RAAN is defined:
if (i == 0)
    OrbEl.RAAN_defined = 0;
else
    OrbEl.RAAN_defined = 1;
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/PosVel2OrbEl.m
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
