% GRAVITY_J2 Computes Gravity based on the J2 perturbation parameter
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gravity_J2:
%   Computes the Gravity vector and magnitude using the J2 perturbation
%   parameters.
% 
% SYNTAX:
%	[Gmag, G_f] = Gravity_J2(P_i, CentralBody, ZeroCent_flg)
%
% INPUTS: 
%	Name            Size	Units		Description
%   P_f             [3]     [dist]      Position in Central Body Centered
%                                        Fixed Coordinates (e.g. ECEF, LCLF)
%   CentralBody     {struct}            Central Body Parameters
%       .a          [1]     [dist]       Semi-major Axis
%       .gm         [1]     [dist^3/s^2] Gravitational Constant
%       .j2         [1]     [ND]         J2 Perturbation Parameter
%       .rate       [1]     [rad/sec]   Angular Velocity 
%   ZeroCent_flg    [1]     [bool]      Zero Centripetal Acceleration
%                                        Affects? (Default 0/false)
%  
% OUTPUTS: 
%	Name            Size	Units		Description
%   Gmag            [1]     [dist/s^2]  Magnitude of Gravity Vector
%   G_f             [3]     [dist/s^2]  Gravity Vector in Central Body
%                                        Centered Fixed Coordinates
%                                        (e.g. ECEF, LCLF)
%   G_f_Cent        [3]     [dist/s^2]  Centripetal Acceleration in Central
%                                        Body Centered Fixed Coordinates
%                                        (e.g. ECEF, LCLF)
%
% NOTES:
%   This calculation is not unit specific.  Input distances only need to be
%   of a uniform unit.  Standard METRIC [m, m^3/s^2] or ENGLISH 
%   [ft, ft^3/s^2] distances should be used.
%   Output gravity vector will be of same dimensions as the inputted
%   position vector (ie either a [3x1] or [1x3]).
%
% EXAMPLES:
%   % Example 1: Compute Gravity at the Equator and Pole of the Earth
%   % Assume WGS-84 Earth
%   CB.a       = 6378137.0;             % [m]       Semi-major Axis
%   CB.b       = 6356752.3142;          % [m]       Semi-minor Axis
%   CB.gm      = 3986004.418e8;         % [m^3/s^2] Gravitational Constant
%   CB.rate    = 7292115e-11;           % [rad/s]   Angular Velocity
%   CB.C_2_0   = -0.484166774985e-3;    % [ND]      2nd degree zonal harmonic
%   CB.j2      = -sqrt(5)*CB.C_2_0;     % [ND]      J2 Perturbation Coefficient
%
%   % Example 1a: Compute Gravity at Equator and include centripetal acceleration.
%   P_f = [CB.a 0 0];
%   [Gmag, G_f, G_f_Cent] = Gravity_J2(P_f, CB)
%   %   Gmag    = 9.78028164729659          [m/sec^2]  (32.0875382129153 ft/sec^2)
%   %   G_f     = [-9.78028164729659  0  0] [m/sec^2]
%   %   G_f_Cent= [-0.033915705976977 0  0] [m/sec^2]
%
%   % Example 1b: Same as 1a but exclude centripetal acceleration.
%	[Gmag, G_f] = Gravity_J2(P_f, CB, 1)
%   %  Gmag =  9.81419735327356         [m/sec^2]  (32.1988102141521 ft/sec^2)
%   %  G_f  = [-9.81419735327356  0  0] [m/sec^2]
%
%   % Example 1c: Compute Gravity at Pole and include centripetal acceleration.
%   P_f = [0 0 CB.b];
%	[Gmag, G_f, G_f_Cent] = Gravity_J2(P_f, CB)
%   %  Gmag     =  9.83206684666606         [m/sec^2]  (32.2574371609779 ft/sec^2)
%   %  G_f      = [0 0 -9.83206684666606]   [m/sec^2]
%   %  G_f_Cent = [0 0 0]                   [m/sec^2]
%
%   % Example 1d: Same as 1c but exclude centripetal acceleration.
%   %             Note that because we're exactly at pole
%	[Gmag, G_f, G_f_Cent] = Gravity_J2(P_f, CB, 1)
%   %  Gmag =  9.83206684666606         [m/sec^2]  (32.2574371609779 ft/sec^2)
%   %  G_f  = [0 0 -9.83206684666606]   [m/sec^2]
%   %  G_f_Cent = [0 0 0]                   [m/sec^2]
%
% SOURCE DOCUMENTATION:
% [1]   Stevens, Brian L. and Lewis, Frank L. Aircraft Control and 
%       Simulation (2nd Edition).  Hoboken, New Jersey: John Wiley & 
%       Sons, Inc. 2003.
%       Eqn. 1.4-15 & 1.5-16 (pg 41)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Gravity_J2.m">Gravity_J2.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gravity_J2.m">Driver_Gravity_J2.m</a>
%	  Documentation: <a href="matlab:winopen(which('Gravity_J2_Function_Documentation.pptx'));">Gravity_J2_Function_Documentation.pptx</a>
%
% See also Gravity_Flat, Gravity_PointMass, Gravity_Ellipsoid 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/653
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Gravity_J2.m $
% $Rev: 3046 $
% $Date: 2013-10-29 20:31:44 -0500 (Tue, 29 Oct 2013) $
% $Author: sufanmi $

function [Gmag, G_f, G_f_Cent] = Gravity_J2(P_f, CentralBody, ZeroCentripetal_flg)

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

if(nargin < 3)
    ZeroCentripetal_flg = 0;
end

%% Main Function:
G_f = P_f*0;

%% Pick off Needed Central Body Parameters
CB_a   = CentralBody.a;         % [dist]        Semi-major Axis
CB_gm  = CentralBody.gm;        % [dist^3/s^2]  Gravitational Constant
CB_J2  = CentralBody.j2;        % [ND]          J2 Perturbation Parameter
CB_rate= CentralBody.rate;      % [rad/sec]     Angular Velocity

%% Break Apart Position Vector
R  = norm(P_f);
Px = P_f(1); Py = P_f(2); Pz = P_f(3);

%% Centripetal Acceleration
%  From 1.4-18: g = G - omega_e/i x (omega_e/i x P_e)
%  omega_e/i x (omega_e/i x P_e) = [-omega_e/i^2 * Px_f; -omega_e/i^2 * Py_f; 0]
G_f_Cent     = P_f * 0;
G_f_Cent(1)  = -CB_rate * CB_rate * Px;
G_f_Cent(2)  = -CB_rate * CB_rate * Py;

%% Geocentric Latitude
%   Ref 1: Pg 41 (after 1.4-16)
sinPsi      = Pz / R;
sinPsiSqrd  = sinPsi * sinPsi;
negGMRSqrd = -CB_gm/(R*R);

%   Ref 1: Pg 41 (1.4-16)
J2_term = 1.5*CB_J2*(CB_a/R)*(CB_a/R);

V_f = G_f*0;    % Initialize Gravity Vector
V_f(1) = negGMRSqrd * (1 + J2_term * (1-5*sinPsiSqrd)) * Px / R;  % [dist/s^2]
V_f(2) = negGMRSqrd * (1 + J2_term * (1-5*sinPsiSqrd)) * Py / R;  % [dist/s^2]
V_f(3) = negGMRSqrd * (1 + J2_term * (3-5*sinPsiSqrd)) * Pz / R;  % [dist/s^2]

if(ZeroCentripetal_flg)
    G_f = V_f;
else
    G_f = V_f - G_f_Cent;
end

Gmag = norm(G_f);   % [dist/s^2] Gravity Vector

end % << End of function Gravity_J2 >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130619 MWS: Updated function to be based on Stevens & Lewis
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi

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
