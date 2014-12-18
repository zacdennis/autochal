% CENTRALBODYEARTH_INIT  Loads WGS-84 EGM 96 Earth Model Parameters
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CentralBodyEarth_init:
%     Loads WGS-84 EGM 96 Earth Model Parameters. Displays all the earth's
%     constants in the units desired.
% 
% SYNTAX:
%	[earth] = CentralBodyEarth_init(flgUseMetric)
%	[earth] = CentralBodyEarth_init()
%
% INPUTS: 
%	Name            Size	Units	Description
%   flgUseMetric	[1x1]	[ND]	 Flag Used to Set Units of Output
%                                        Structure where:
%                                           0: Returns English Units
%                                           1: Returns Metric Units
%                                    Default: 1 (metric)
%
% OUTPUTS: 
%	Name        Size        Units                   Description
%	 earth      [Various]	[Various]               Gives the WGS EGM 96 Earth Model Parameters 
%    .a         [1]         [m] or [ft]             Semi-major Axis
%    .b         [1]         [m] or [ft]             Semi-minor Axis (polar)
%    .gm        [1]         [m^3/s^2] or [ft^3/s^2] Gravitational Constant
%    .rate      [1]         [rad/s]                 Angular Velocity
%    .period    [1]         [sec]                   Revolution period
%    .OmegaE    [3x3]       [rad/s]                 Skew-symmetric matrix
%                                                    of angular velocity (.rate)
%                                                    skew([0 0 rate]) =
%                                                    [0     -rate   0;
%                                                     rate   0      0;
%                                                     0      0      0]
%    .OmegaE2   [3x3]       [rad/s^2]               OmegaE * OmegaE
%                                                    [-rate^2   0       0;
%                                                     0       -rate^2   0;
%                                                     0         0       0]
%    .flatten   [1]         [ND]                    Flattening Parameter
%    .e         [1]         [ND]                    First Eccentricity
%    .e2        [1]         [ND]                    First Eccentricity Squared
%    .ep        [1]         [ND]                    Second Eccentricity
%                                                    ( e-prime, e')
%    .ep2       [1]         [ND]                    Second Eccentricity
%                                                   (e-prime) Squared
%    .E1        [1]         [m] or [ft]             Linear Eccentricity
%    .E21       [1]         [m^2] or [ft^2]         Linear Eccentricity
%                                                    Squared
%    .c         [1]         [m] or [ft]             Polar Radius of
%                                                    Curvature
%    .eta       [1]         [ND]                    (a^2 - b^2)/(a^2)
%    .j2        [1]         [ND]                    J2 Perturbation
%                                                    Coefficient
%    .gamma_e   [1]         [m/s^2] or [ft/s^2]     Theoretical (Normal)
%                                                    Gravity at the Equator
%    .gamma_p   [1]         [m/s^2] or [ft/s^2]     Theoretical (Normal)
%                                                    Gravity at the Pole
%    .g0        [1]         [m/s^2] or [ft/s^2]     Mean Value of Theoretical
%                                                    (Normal) Gravity
%    .m         [1]         [ND]                    Gravity Ratio
%    .k         [1]         [ND]                    Theoretical (Normal)
%                                                    Gravity Formula Constant
%                                                    (Somigliana's)
%    .MR        [1]         [m] or [ft]             Mean Radius of Semi-axis
%    .g         [1]         [m/s^2] or [ft/s^2]     Acceleration due to
%                                                    Gravity on the Earth's
%                                                    surface at a geodetic
%                                                    latitude of ~45.5 deg
%
% NOTES:
%
% EXAMPLES:
%   % Loads the Earth Parameters with english units
%	[earth] = CentralBodyEarth_init(1)
%   % earth = 
%   %       title: 'WGS-84 EGM 96 Earth Model'
%   %       units: 'ENGLISH'
%   %           a: 20925646.3254593     [ft]
%   %           ...    
%   %           g: 32.1740485564304     [ft/sec^2]
%
%   % Loads the Earth Parameters without an input, thus assuming metric units
%	[earth] = CentralBodyEarth_init()
%   % earth = 
%   %       title: 'WGS-84 EGM 96 Earth Model'
%   %       units: 'METRIC'
%   %           a: 6378137              [m]
%   %           ...    
%   %           g: 9.80665              [m/sec^2]
%
% SOURCE DOCUMENTATION:
%   [1]    "Department of Defence World Geodetic System 1984: Its 
%           Definition and Relationships with Local Geodetic Systems"
%          National Imagery and Mapping Agency Technical Report
%          NIMA TR8350.2, Third Edition, Amendemnt 1, 3 January 2000
%          http://earth-info.nga.mil/GandG/publications/tr8350.2/wgs84fin.pdf
%
% HYPERLINKS:
%	  Source function: <a href="matlab:edit CentralBodyEarth_init.m">CentralBodyEarth_init.m</a>
%	  Driver script: <a href="matlab:edit Driver_CentralBodyEarth_init.m">Driver_CentralBodyEarth_init.m</a>
%	  Documentation: <a href="matlab:winopen(which('CentralBodyEarth_init Documentation.pptx'));">CentralBodyEarth_init Documentation.pptx</a>
%
% See also CentralBodyMoon_init, CentralBodyMars_init, conversions
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/374
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Earth/CentralBodyEarth_init.m $
% $Rev: 2845 $
% $Date: 2013-01-22 15:05:52 -0600 (Tue, 22 Jan 2013) $
% $Author: sufanmi $

function [earth] = CentralBodyEarth_init(flgUseMetric)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Checking:
% If nothing is introduced
if nargin==0
    flgUseMetric=1;
end
% If string is introduced
if ischar(flgUseMetric); 
        errorstr = 'fname (input 1) must be 0 or 1 ! ';
        disp([mfnam '>>ERROR: ' errorstr]);
        error(errorstr);
end
    
%% Build Earth Structure:
earth.title     = 'WGS-84 EGM 96 Earth Model';
earth.units     = 'METRIC';
earth.a         = 6378137.0;            % [m]       Semi-major Axis
                                        %            (Equatorial Radius)
earth.b         = 6356752.3142;         % [m]       Semi-minor Axis
                                        %            (Polar Radius)
earth.gm        = 3986004.418e8;        % [m^3/s^2] Gravitational Constant
earth.rate      = 7292115e-11;          % [rad/s]   Angular Velocity (3-6)
earth.rate_prime= 7292115.1467e-11;     % [rad/sec] IAU /GRS 67 angular
                                        %           velocity (3-7)
earth.period    = (2*pi)/earth.rate;    % [sec]     Revolution period
earth.OmegaE    = [0 -earth.rate 0; earth.rate 0 0; 0 0 0];
earth.OmegaE2   = earth.OmegaE * earth.OmegaE;
earth.flatten   = 1/298.257223563;      % [ND]      Flattening Parameter
earth.e         = 8.1819190842622e-2;   % [ND]      First Eccentricity
earth.e2        = earth.e * earth.e;    % [ND]      First Eccentricity Squared
earth.ep        = 8.2094437949696e-2;   % [ND]      Second Eccentricity
                                        %           (e-prime, e')
earth.ep2       = earth.ep^2;           % [ND]      Second Eccentricity
                                        %           (e-prime) Squared
earth.El        = earth.e * earth.a;    % [m]       Linear Eccentricity
earth.E2l       = earth.El^2;           % [m^2]     Linear Eccentricity
                                        %            Squared
earth.c         = 6399593.6258;         % [m]       Polar Radius of
                                        %            Curvature
earth.eta       = (earth.a^2 - earth.b^2)/earth.a^2;  % [ND]
earth.C_2_0     = -0.484166774985e-3;   % [ND]      2nd degree zonal harmonic (Table 3.3)
earth.j2        = -sqrt(5)*earth.C_2_0; % [ND]      J2 Perturbation Coefficient
                                        %           -sqrt(5) * C_(2,0)
earth.gamma_e   = 9.7803253359;         % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at the Equator
                                        %            (on the Ellipsoid)
earth.gamma_p   = 9.8321849378;         % [m/s^2]   Theoretical (Normal)
                                        %            Gravity at the Pole
                                        %            (on the Ellipsoid)
earth.g0        = 9.7976432222;         % [m/s^2]   Mean Value of
                                        %            Theoretical (Normal)
                                        %            Gravity
earth.m         = (earth.rate^2) * (earth.a^2) * earth.b / earth.gm;
                                        % [ND]      Gravity Ratio
earth.k         = 0.00193185265241;     % [ND]      Theoretical (Normal)
                                        %            Gravity Formula
                                        %            Constant (Somigliana's
                                        %            Constant)
earth.MR       = 6371008.7714;          % [m]       Mean Radius of Semi-axis
earth.g         = 9.80665;              % [m/s^2]  Acceleration due to
                                        %           Gravity on the Earth's
                                        %           surface at a geodetic
                                        %           latitude of about 45.5
                                        %           deg.

                                        % Uncomment this line to use the 'Gravity_Harmonic_Lib' block
% earth.harmonic  = load('EGM96_nm360.dat');  % [ND] Loads EGM96 Spherical
                                        % Coefficients complete to order
                                        % and degree of 360
% % compute normal gravity eqn constants per Bose.
% m_tmp = earth.rate^2*earth.a^2*earth.b/earth.gm;
% earth.grav_A = 1.0 + earth.flatten + m_tmp;
% earth.grav_B = (5/2)*m_tmp - earth.flatten;

%% Convert to English
if (nargin == 1) && (flgUseMetric == 0)
    %% Conversions:
    conversions;

    earth.units     = 'ENGLISH';
    earth.a         = earth.a * C.M2FT;       % [ft]
    earth.b         = earth.b * C.M2FT;       % [ft]
    earth.c         = earth.c * C.M2FT;       % [ft]
    earth.gm        = earth.gm * (C.M2FT)^3;  % [ft^3/s^2]
    earth.gamma_e   = earth.gamma_e * C.M2FT; % [ft/s^2]
    earth.gamma_p   = earth.gamma_p * C.M2FT; % [ft/s^2]
    earth.g0        = earth.g0 * C.M2FT;      % [ft/s^2]
    earth.MR        = earth.MR * C.M2FT;      % [ft]
    earth.g         = earth.g * C.M2FT;       % [ft/s^2]
    
    clear C;

end % << End of function CentralBodyEarth_init >>

%% REVISION HISTORY
% YYMMDD INI: note
% 100813 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI:  Name            : Email                             : NGGN Username
% JJ:   Jovany Jimenez  : Jovany.Jimenez-deparias@ngc.com   : g67086

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
