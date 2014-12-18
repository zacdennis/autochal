% GENERATEORBITALIC computes IC struct for a vehicle outside of a central body's atmosphere.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GenerateOrbitalIC:
%   Computes the Initial Condition Structure for a vehicle outside of the
%   Central Body's atmosphere using Orbital Elements.  Establishes vehicle
%   for nadir pointing.
% 
% SYNTAX:
%	[IC] = GenerateOrbitalIC(ICin, CentralBody, mst)
%
% INPUTS: 
%	Name       	Size	Units               Description
%   IC            [structure]               Initial condition structure
%   .a          [1x1]   [length]            Semi-major Axis
%   .e          [1x1]   [ND]                Eccentricity
%   .theta      [1x1]   [deg]               True Anomaly
%   .RAAN       [1x1]   [deg]               Right Ascension Logitude
%                                           of the Ascending node
%   .i          [1x1]   [deg]               Inclination
%   .omega      [1x1]   [deg]               Argument of the Perigee
%   .GM         [1x1]   [length^3/sec^2]    Central Body Gravitational
%                                           Constant
%   .Euler_lvlh [1x3]   [deg]               Euler orientation in Local 
%                                           ertical Local Horizontal 
%                                           Frame
%   CentralBody   [structure]               Central Body Parameters
%   .a          [1x1]   [length]            Semi-major axis
%   .b          [1x1]   [length]            Semi-minor axis
%   .flatten    [1x1]   [ND]                Flattening Parameter
%   .gm         [1x1]   [length^3/sec^2]    Gravitational Constant
%   mst         [1x1]   [deg]               Mean-Sidereal Time
%
% OUTPUTS: 
%	Name       	Size		Units           Description
%   IC            [structure]               Vehicle's Initial States 
%                                           and Conditions
%   .P_i        [3x1]   [length]            Position in Central Body 
%                                           Inertial Frame
%   .V_i        [3x1]   [length/sec]        Velocity in Central Body 
%                                           Inertial Frame
%   .LLA        [3x1]   [deg deg length]    Geodetic Latitude/Longitude/
%                                           Altitude
%   .PQRb       [1x3]   [rad/sec]           Rotational velocity in 
%                                           Aircraft Body Frame
%   .Euler_i    [3x1]   [rad]               Euler orientation in Central 
%                                           Body Inertial Frame
%   .quat       [1x4]   [ND]                Quaterions
%   .B          [3x3]   [ND]                Transformation Matrix from 
%                                           Central Body Inertial Frame 
%                                           to Aircraft Body Frame
%   .P_f        [3x1]   [length]            Position in Central Body
%                                           Fixed Frame
%   .V_f        [3x1]   [length/sec]        Velocity in Central Body
%                                           Fixed Frame
%   .V_ned      [3x1]   [length/sec]        Velocity in North East Down
%                                           Frame
%   .Euler_ned  [3x1]   [deg]               Euler orientation in North 
%                                           East Down Frame

%
% NOTES:
%   Output ICs are added to the IC's defined as Inputs
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = GenerateOrbitalIC(ICin, CentralBody, mst, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = GenerateOrbitalIC(ICin, CentralBody, mst)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit GenerateOrbitalIC.m">GenerateOrbitalIC.m</a>
%	  Driver script: <a href="matlab:edit Driver_GenerateOrbitalIC.m">Driver_GenerateOrbitalIC.m</a>
%	  Documentation: <a href="matlab:pptOpen('GenerateOrbitalIC_Function_Documentation.pptx');">GenerateOrbitalIC_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/390
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/GenerateOrbitalIC.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [IC] = GenerateOrbitalIC(ICin, CentralBody, mst)

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

%% Initialize Outputs:
IC= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        mst= ''; CentralBody= ''; ICin= ''; 
%       case 1
%        mst= ''; CentralBody= ''; 
%       case 2
%        mst= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(mst))
%		mst = -1;
%  end
%% Main Function:
%% Transfer Units:
conversions;
IC.Units   = CentralBody.units;
IC.AngleTag = 'Angles are in [deg]; PQRb is in [rad/s]';

%% Organize Output Structure (these will all be overwritten):
IC.P_i          = zeros(1,3);
IC.P_f          = zeros(1,3);
IC.P_lvlh       = zeros(1,3);
IC.P_rsw        = zeros(1,3);
IC.P_onf        = zeros(1,3);
IC.LLA          = zeros(1,3);
IC.GeocentricLat= 0;

IC.V_i          = zeros(1,3);
IC.V_f          = zeros(1,3);
IC.V_ned        = zeros(1,3);
IC.V_lvlh       = zeros(1,3);
IC.V_rsw        = zeros(1,3);
IC.V_onf        = zeros(1,3);
IC.V_local      = zeros(1,3);
IC.Speed_i      = 0;

IC.quat         = zeros(1,4);
IC.Euler_i      = zeros(1,3);
IC.Euler_f      = zeros(1,3);
IC.Euler_ned    = zeros(1,3);
% IC.Euler_lvlh   = SPECIFIED
% IC.Euler_lvlh   = zeros(1,3);
IC.Euler_lvlh   = ICin.Euler_lvlh;
IC.Euler_rsw    = zeros(1,3);
IC.Euler_onf    = zeros(1,3);

IC.Quat_f       = zeros(1,4);
IC.Quat_ned     = zeros(1,4);
IC.Quat_lvlh    = zeros(1,4);
IC.Quat_rsw     = zeros(1,4);
IC.Quat_onf     = zeros(1,4);

% IC.PQRb = SPECIFIED
IC.PQRb         = ICin.PQRb;

%% Compute Position Parameters:
[IC.P_i, IC.V_i, IC.OrbitGamma] = OrbEl2PosVel(ICin.a, ICin.e, ...
    ICin.theta, ICin.RAAN, ICin.i, ICin.omega, CentralBody.gm);
IC.Euler_i  = eul_lvlh_2_eul_i( IC.P_i, IC.V_i, IC.Euler_lvlh * C.D2R) * C.R2D;   % [rad]
IC.quat     = eul2quaternion(IC.Euler_i * C.D2R);
IC.i2b      = eul2dcm(IC.Euler_i);

% LLA:
[IC.GeocentricLat, IC.LLA(1), IC.LLA(2), IC.LLA(3)] = eci2lla( IC.P_i, ...
    CentralBody.a, CentralBody.b, CentralBody.flatten, mst); % [length]

% Fixed Frame:
[IC.P_f, f_C_i] = eci2ecef( IC.P_i, mst );
IC.V_f          = IC.V_i - cross([0 0 CentralBody.rate], IC.P_f);
b_C_f           = IC.i2b * (f_C_i');
IC.Euler_f      = (dcm2eul(b_C_f) * C.R2D)';
IC.Quat_f       = eul2quaternion(IC.Euler_f * C.R2D);

% NED Frame:
IC.P_ned        = ecef2ned( IC.P_f, IC.LLA(1), IC.LLA(2) );
IC.V_ned        = ecef2ned( IC.V_f, IC.LLA(1), IC.LLA(2) );
IC.Euler_ned    = eul_i_2_eul_ned(IC.LLA(1), IC.LLA(2), mst, IC.Euler_i);
IC.Quat_ned     = eul2quaternion(IC.Euler_ned * C.R2D);

% LVLH Frame:
[IC.Euler_lvlh, lvlh_C_i] = eul_i_2_eul_lvlh( IC.P_i, IC.V_i, IC.Euler_i*C.D2R);
IC.Euler_lvlh   = IC.Euler_lvlh * C.R2D;    % [deg]
IC.P_lvlh       = (lvlh_C_i * IC.P_i')';    % [length]
IC.V_lvlh       = (lvlh_C_i * IC.V_i')';    % [length/sec]
IC.Quat_lvlh    = eul2quaternion(IC.Euler_lvlh * C.R2D);

% RSW Frame:
[IC.Euler_rsw, i_C_rsw] = eul_i_2_eul_rsw( IC.P_i, IC.V_i, IC.Euler_i*C.D2R);
rsw_C_i = i_C_rsw';
IC.Euler_rsw    = IC.Euler_rsw * C.R2D;     % [deg]
IC.P_rsw        = (rsw_C_i * IC.P_i')';     % [length]
IC.V_rsw        = (rsw_C_i * IC.V_i')';     % [length/sec]
IC.Quat_rsw     = eul2quaternion(IC.Euler_rsw * C.R2D);

[Euler_onf, i_C_onf] = eul_i_2_eul_onf( IC.P_i, IC.V_i, IC.Euler_i * C.D2R);
IC.Euler_onf = Euler_onf * C.R2D;
onf_C_i = i_C_onf;
IC.P_onf = (onf_C_i * IC.P_i')';
IC.V_onf = (onf_C_i * IC.V_i')';
IC.Quat_onf = eul2quaternion(IC.Euler_onf * C.R2D);

%% Compute Relative Velocity in Body Frame, [length/sec]:
IC.Vrel_b = (IC.i2b * IC.V_i' - IC.i2b * (CentralBody.OmegaE * IC.P_i'))';

%% Compute Flight Path Angles, [deg]:
[IC.Gamma, IC.Chi, IC.Vtrue] = Vned2GammaChiVtrue(IC.V_ned);
[IC.Alpha, IC.Beta, junk] = Vb2AlphaBetaVtrue(IC.Vrel_b);
ned_C_local = eul2dcm([0 0 -IC.Chi] * C.D2R);
local_C_ned = ned_C_local';
IC.V_local = (local_C_ned * IC.V_ned')';
IC.ATDot    =   IC.V_local(1);
IC.CTDot    =   IC.V_local(2);
IC.AltRate  =  -IC.V_local(3);

%% Compute Magnitude of Velocity Vector:
IC.Speed_i = norm(IC.V_i);    % [length/sec]

% Calculate Standard Atmosphere Mach Number & Qbar
if(~strfind(lower(CentralBody.title), 'earth'))
    StdAtmos    = Coesa1976(LLA(3));
    IC.Mach     = IC.Vtrue / StdAtmos.Sound;
    IC.Qbar     = (1/2) * StdAtmos.Density * (IC.Vtrue^2);
end

OE = PosVel2OrbEl(IC.P_i, IC.V_i, CentralBody.gm);
IC.a        = ICin.a;       % [length]  Semi-major axis
IC.e        = ICin.e;       % [ND]      Eccentricy
IC.theta    = ICin.theta;   % [deg]     True Anomaly
IC.RAAN     = ICin.RAAN;    % [deg]     Right Ascension Ascending Node
IC.i        = ICin.i;       % [deg]     Inclination
IC.omega    = ICin.omega;   % [deg]     Argument of the Perigee
IC.deltaT   = OE.deltaT;    % [sec]     Time since Perigee Passage
IC.capE     = OE.capE;      % [deg]     Eccentric Anomaly
IC.rp       = OE.rp;        % [length]  Radius of Perigee
IC.ra       = OE.ra;        % [length]  Radius of Apogee
IC.b        = OE.b;         % [length]  Semi-minor Axis
IC.P        = OE.P;         % [length]  Semi-latus rectum
IC.period   = OE.period;    % [sec]     Period of Orbit
IC.n        = OE.n;         % [rad/sec] Mean Motion
IC.M        = OE.M;         % [deg]     Mean Anomaly

% Point Mass Gravity:
[IC.Gmag, IC.G_i] = Gravity_PointMass(IC.P_i, CentralBody);

%% Final Housekeeping:
%  Remove all the ICin fields used by this function and add whatever
%  remains to the IC output
ICin = rmfield(ICin, 'Euler_lvlh');
ICin = rmfield(ICin, 'a');
ICin = rmfield(ICin, 'e');
ICin = rmfield(ICin, 'theta');
ICin = rmfield(ICin, 'RAAN');
ICin = rmfield(ICin, 'i');
ICin = rmfield(ICin, 'omega');

lstStruct = listStruct(ICin);
if(~isempty(lstStruct))
    numMems = size(lstStruct,1);
    for iMem = 1:numMems
        curMem = lstStruct{iMem,:};
        IC.(curMem) = ICin.(curMem);
    end
end

%% Compile Outputs:
%	IC= -1;

end % << End of function GenerateOrbitalIC >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

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
