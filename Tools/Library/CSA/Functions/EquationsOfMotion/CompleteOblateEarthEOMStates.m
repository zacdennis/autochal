% COMPLETEOBLATEEARTHEOMSTATES creates complete IC structure for oblate earth model
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CompleteOblateEarthEOMStates:
%     <Function Description> 
% 
% SYNTAX:
%	[IC] = CompleteOblateEarthEOMStates(IC, mst_deg, CentralBody)
%
% INPUTS: 
%	Name                Size	Units	Description
%	IC                  {struct}        Initial Conditions Structure
%    .GeodeticLat_deg   [1]     [deg]   Geodetic Latitude
%    .Longitude_deg     [1]     [deg]   Longitude
%    .Alt_msl_ft        [1]     [ft]    Altitude Mean Sea Level
%    .Gamma_deg         [1]     [deg]   Flight Path Angle
%    .Chi_deg           [1]     [deg]   Heading
%    .Alpha_deg         [1]     [deg]   Angle of Attack
%    .Beta_deg          [1]     [deg]   Angle of Sideslip
%    .Mu_deg            [1]     [deg]   Bank Angle
%
%   <One of the following>
%    .Mach              [1]     [ND]    Mach Number
%    .Vtas_kts          [1]     [kts]   True Airspeed in knots
%    .Vias_kts          [1]     [kts]   Indicated Airspeed in knots
%    .Vtas_fps          [1]     [ft/sec] True Airspeed in ft/sec
%
%   <And Either>
%    .PQRb_dps          [3]     [deg/sec] Angular Body Rates
%   <OR>
%    .Pb_deg            [1]     [deg/sec] Body Roll Rate
%    .Qb_deg            [1]     [deg/sec] Body Pitch Rate
%    .Rb_deg            [1]     [deg/sec] Body Yaw Rate
%
%	mst_deg             [1]     [deg]   Mean Sidereal Time
%	CentralBody	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            Size    Units       Description
%   IC          {structure}             Inputted Initial Condition
%                                        Structure PLUS...
%    .P_i_ft        [3]     [ft]        Position in CB Inertial Frame
%    .P_f_ft        [3]     [ft]        Position in CB Fixed Frame
%    .P_ned_ft      [3]     [ft]        Position in CB North/East/Down Frame
%    .Mach          [1]     [ND]        Mach Number
%    .Vtas_kts      [1]     [kts]       True Airspeed in knots
%    .Vias_kts      [1]     [kts]       Indicated Airspeed in knots
%    .Vtas_fps      [1]     [ft/sec]    True Airspeed in ft/sec
%    .Vrel_b_fps    [3]     [ft/sec]    Relative Body Velocity
%    .V_ned_fps     [3]     [ft/sec]    Velocity in CB North/East/Down Frame
%    .V_i_fps       [3]     [ft/sec]    Velocity in CB Inertial Frame
%    .V_f_fps       [3]     [ft/sec]    Velocity in CB Fixed Frame
%    .V_b_fps       [3]     [ft/sec]    Velocity in Body Frame
%    .LatRate_dps   [1]     [deg/sec]   Latitude Rate
%    .LonRate_dps   [1]     [deg/sec]   Longitude Rate
%    .Omega_ned_rps [3]     [rad/sec]
%    .Omega_w_rps   [3]     [rad/sec]
%    .StdAtmos    {struct}  [varies]    COESA 1976 Standard Atmosphere at
%                                        IC.Alt_msl_ft
%    .Qbar_psf      [1]     [lb/ft^2]   Dynamic Pressure
%    .Euler_ned_deg [3]     [deg]       Euler w.r.t. North/East/Down Frame
%    .Euler_i_deg   [3]     [deg]       Euler w.r.t. Inertial Frame
%    .Euler_f_deg   [3]     [deg]       Euler w.r.t. Fixed Frame
%    .Euler_lvlh_deg [3]    [deg]       Euler w.r.t. Local Vertical Local
%                                        Horizontal Frame
%    .Quat_i        [4]     [ND]        Quaternion w.r.t. Inertial Frame
%    .Quat_f        [4]     [ND]        Quaternion w.r.t. Fixed Frame
%    .Quat_ned      [4]     [ND]        Quaternion w.r.t. NED Frame
%    .Quat_lvlh     [4]     [ND]        Quaternion w.r.t. LVLH Frame
%    .PQRb_wrt_ned_rps [3]  [rad/sec]   Body Rates w.r.t. NED Frame
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	'DeltaTemp'         [double]        0           Delta Standard Temp
%   'UseEnglishUnits'   'bool'          1 (true)    0 - Use Metric
%                                                   1 - Use English
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = CompleteOblateEarthEOMStates(IC, mst, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%  SOURCE DOCUMENTATION
%   [1]    Stevens, Brian L. and Lewis, Frank L.  "Aircraft Control and
%           Simulation. 2nd Edition" New York: John Wiley & Sons, Inc. 2003.
%           Pages 36-38.
% HYPERLINKS:
%	Source function: <a href="matlab:edit CompleteOblateEarthEOMStates.m">CompleteOblateEarthEOMStates.m</a>
%	  Driver script: <a href="matlab:edit Driver_CompleteOblateEarthEOMStates.m">Driver_CompleteOblateEarthEOMStates.m</a>
%	  Documentation: <a href="matlab:winopen(which('CompleteOblateEarthEOMStates_Function_Documentation.pptx'));">CompleteOblateEarthEOMStates_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/656
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/CompleteOblateEarthEOMStates.m $
% $Rev: 3134 $
% $Date: 2014-03-27 21:04:49 -0500 (Thu, 27 Mar 2014) $
% $Author: sufanmi $

function [IC] = CompleteOblateEarthEOMStates(IC, mst_deg, CentralBody, varargin)

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

[DeltaTemp, varargin]       = format_varargin('DeltaTemp', 0, 2, varargin);
[UseEnglishUnits, varargin] = format_varargin('UseEnglishUnits', 1, 2, varargin);

%% Main Function:
conversions;

%% Tag structure as metric to reduce confusion:
IC.Units   = CentralBody.units;
IC.AngleTag = 'Angles are in [deg]; PQRb is in [rad/s]';

%%
LLA         = [IC.GeodeticLat_deg, IC.Longitude_deg, IC.Alt_msl_ft];
IC.P_i_ft   = lla2eci( LLA, CentralBody.flatten, CentralBody.a, mst_deg); % [length]
IC.P_f_ft   = eci2ecef( IC.P_i_ft, mst_deg );
% IC.P_ned_ft = lla2ned( LLA, CentralBody );
IC.P_ned_ft = [0 0 -IC.Alt_msl_ft];

SeaLevel_LLA        = [IC.GeodeticLat_deg, IC.Longitude_deg, 0];
IC.SeaLevel_P_i_ft  = lla2eci( SeaLevel_LLA, CentralBody.flatten, CentralBody.a, mst_deg); % [length]
IC.SeaLevel_P_f_ft  = eci2ecef( IC.SeaLevel_P_i_ft, mst_deg );

%% Finish Velocities:
if(isfield(IC, 'Mach'))
    IC.Vtas_kts = mach2vkts(IC.Mach, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    IC.Vtas_fps = IC.Vtas_kts * C.KTS_2_FPS;  % [ft/s]
    IC.Vias_kts = vtas2vias(IC.Vtas_fps, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);

elseif(isfield(IC, 'Vtas_kts'))
    IC.Vtas_fps = IC.Vtas_kts * C.KTS_2_FPS;  % [ft/s]
    IC.Mach     = vkts2mach(IC.Vtas_kts, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    IC.Vias_kts = vtas2vias(IC.Vtas_fps, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    
elseif(isfield(IC, 'Vias_kts'))
    IC.Vtas_kts = vias2vtas(IC.Vias_kts, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    IC.Vtas_fps = IC.Vtas_kts * C.KTS_2_FPS;  % [ft/s]
    IC.Mach     = vkts2mach(IC.Vtas_kts, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    
elseif(isfield(IC, 'Vtas_fps'))
    IC.Vtas_kts = IC.Vtas_fps * C.FPS_2_KTS;    % [kts]
    IC.Mach     = vkts2mach(IC.Vtas_kts, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
    IC.Vias_kts = vtas2vias(IC.Vtas_fps, IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
end

% %% Finish Velocities:
% IC.Vtrue    = mach2vkts(IC.Mach, IC.Alt, UseEnglishUnits, DeltaTemp)*C.KTS_2_FPS;  % [ft/s]

% Calculate Vrel_b from Vtrue / Alpha / Beta:
%   Note that Vtrue can be used for Flat Earth since there's no earth
%   rotation.
IC.Vrel_b_fps = AlphaBetaVtrue2Vb(IC.Alpha_deg, IC.Beta_deg, IC.Vtas_fps)';
% IC.Vrel_b(1) = IC.Vtrue * cosd(IC.Beta) * cosd(IC.Alpha);   % [ft/s]
% IC.Vrel_b(2) = IC.Vtrue * sind(IC.Beta);                    % [ft/s]
% IC.Vrel_b(3) = IC.Vtrue * cosd(IC.Beta) * sind(IC.Alpha);   % [ft/s]

% Calculate V_ned from Vtrue / Gamma / Chi:
IC.V_ned_fps = GammaChiVtrue2Vned(IC.Gamma_deg, IC.Chi_deg, IC.Vtas_fps);
% IC.V_ned(1) = IC.Vtrue * cosd(IC.Gamma) * cosd(IC.Chi);     % [ft/s]
% IC.V_ned(2) = IC.Vtrue * cosd(IC.Gamma) * sind(IC.Chi);     % [ft/s]
% IC.V_ned(3) = IC.Vtrue * -sind(IC.Gamma);                   % [ft/s]


%%
Lat_rad = IC.GeodeticLat_deg * C.D2R;
Lon_rad = IC.Longitude_deg * C.D2R;
ned_C_f = [...
    -sin(Lat_rad)*cos(Lon_rad)      -sin(Lat_rad)*sin(Lon_rad)     cos(Lat_rad);
    -sin(Lon_rad)                    cos(Lon_rad)                  0;
    -cos(Lat_rad)*cos(Lon_rad)      -cos(Lat_rad)*sin(Lon_rad)    -sin(Lat_rad)];
f_C_ned = ned_C_f';
IC.V_f_fps = (f_C_ned * IC.V_ned_fps')';

IC.V_i_fps = IC.V_f_fps + cross([0 0 CentralBody.rate], IC.P_f_ft);

IC.V_b_fps = zeros(1,3);    % Place holder

% [IC.LatRate_dps, IC.LonRate_dps, IC.AltRate_fps] = Vned_2_LatLonAltRate(IC.V_ned_fps, ...
%     IC.GeodeticLat_deg, IC.Alt_msl_ft,  CentralBody.flatten, CentralBody.a);

% Compute M (Ref 1, pg. 37, Eqn 1.4-3)
% Compute N (Ref 1, pg. 38, Eqn 1.4-5)
[~, M, N] = RadiusAtGeodeticLat(IC.GeodeticLat_deg, CentralBody.flatten, CentralBody.a);
Vn  = IC.V_ned_fps(1);
Ve  = IC.V_ned_fps(2);
h   = IC.Alt_msl_ft;

% Ref 1, pg 38, Eqn 1.4-4
IC.LatRate_dps = ( Vn/(M+h) )*C.R2D;
% Ref 1, pg 38, Eqn 1.4-6
IC.LonRate_dps = ( Ve/((N+h)*cos(IC.GeodeticLat_deg*C.D2R)) )*C.R2D;

% Ref 1, pg 49, Eqn 1.5-14a
IC.Omega_ned_rps = zeros(1,3);
IC.Omega_ned_rps(1) = Ve/(N+h);
IC.Omega_ned_rps(2) = -Vn/(M+h);
IC.Omega_ned_rps(3) = -IC.Omega_ned_rps(1) * tan(IC.GeodeticLat_deg*C.D2R);

IC.Omega_w_rps = [0 0 CentralBody.rate];

% Calculate Standard Atmosphere Mach Number & Qbar
StdAtmos    = Coesa1976(IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
IC.StdAtmos = StdAtmos;
IC.Qbar_psf = (1/2) * StdAtmos.Density * (IC.Vtas_kts^2);

%%
IC.Euler_ned_deg        = fp2euler(IC.Gamma_deg, IC.Chi_deg, IC.Mu_deg, IC.Alpha_deg, IC.Beta_deg); % [deg]
b_C_ned                 = eul2dcm(IC.Euler_ned_deg * C.D2R);
IC.Euler_i_deg          = eul_ned_2_eul_i( IC.GeodeticLat_deg, IC.Longitude_deg, mst_deg, IC.Euler_ned_deg );  % [deg]
b_C_i                   = eul2dcm(IC.Euler_i_deg * C.D2R);
[IC.Euler_f_deg, f_C_i] = eul_i_2_eul_f(IC.Euler_i_deg, mst_deg);    % [deg]
b_C_f                   = eul2dcm(IC.Euler_f_deg * C.D2R);
IC.Euler_lvlh_deg       = eul_i_2_eul_lvlh(IC.P_i_ft, IC.V_i_fps, IC.Euler_i_deg * C.D2R)*C.R2D;
i_C_f = f_C_i';
ned_C_b = b_C_ned';

%% Finish Orientations:
IC.Quat_i   = eul2quaternion(IC.Euler_i_deg * C.D2R);
IC.Quat_f   = eul2quaternion(IC.Euler_f_deg * C.D2R);
IC.Quat_ned = eul2quaternion(IC.Euler_ned_deg * C.D2R);
IC.Quat_lvlh= eul2quaternion(IC.Euler_lvlh_deg * C.D2R);

%% Compute PQRb
if(isfield(IC, 'Pb_dps'))
    IC.PQRb_dps(1) = IC.Pb_dps;
end
if(isfield(IC, 'Qb_dps'))
    IC.PQRb_dps(2) = IC.Qb_dps;
end
if(isfield(IC, 'Rb_dps'))
    IC.PQRb_dps(3) = IC.Rb_dps;
end
IC.PQRb_wrt_ned_rps = IC.PQRb_dps * C.D2R;

w_ned_b_rps         = (b_C_ned * IC.Omega_ned_rps')';
IC.PQRb_wrt_f_rps   = IC.PQRb_wrt_ned_rps + w_ned_b_rps;

w_f_b_rps           = (b_C_f * IC.Omega_w_rps')';
IC.PQRb_wrt_i_rps   = IC.PQRb_wrt_f_rps + w_f_b_rps;

%% Update Vb
IC.V_b_fps = (b_C_ned * IC.V_ned_fps')';

%% Gravity:
% Gravity J2 (Include Centripetal Acceleration)
[IC.Gmag_fpss, IC.G_f_fpss, IC.G_f_Cent_fpss] = Gravity_J2(IC.P_f_ft, CentralBody);
IC.G_b_fpss = (b_C_f * IC.G_f_fpss')';
IC.G_i_fpss = (i_C_f * IC.G_f_fpss')';
IC.G_ned_fpss = (ned_C_b * IC.G_b_fpss')';

[IC.SeaLevel_Gmag_fpss] = Gravity_J2(IC.SeaLevel_P_f_ft, CentralBody);
load_g = IC.G_b_fpss/IC.SeaLevel_Gmag_fpss;
IC.nx_g =  load_g(1);   % [g]
IC.ny_g =  load_g(2);   % [g]
IC.nz_g =  load_g(3);   % [g]   % Don't need to flip for IC
IC.nx_mg = IC.nx_g * C.ONE_2_MILLI;
IC.ny_mg = IC.ny_g * C.ONE_2_MILLI;
IC.nz_mg = IC.nz_g * C.ONE_2_MILLI;

OrbEl =  PosVel2OrbEl(IC.P_i_ft, IC.V_i_fps, CentralBody.gm);
IC.OrbEl.a_ft               = OrbEl.a;              % Semi-major Axis
IC.OrbEl.e_ND               = OrbEl.e;              % Eccentricity
IC.OrbEl.theta_deg          = OrbEl.theta;          % True Anomaly
IC.OrbEl.RAAN_deg           = OrbEl.RAAN;           % Right Ascension Longitude of the Ascending Node
IC.OrbEl.i_deg              = OrbEl.i;              % Inclination
IC.OrbEl.omega_deg          = OrbEl.omega;          % Argument of the Perigee
IC.OrbEl.deltaT_sec         = OrbEl.deltaT;         % Time since Perigee Passage
IC.OrbEl.capE_deg           = OrbEl.capE;           % Eccentric Anomaly
IC.OrbEl.rp_ft              = OrbEl.rp;             % Radius of Perigee
IC.OrbEl.ra_ft              = OrbEl.ra;             % Radius of Apogee
IC.OrbEl.b_ft               = OrbEl.b;              % Semi-minor axis
IC.OrbEl.P_ft               = OrbEl.P;              % Semilatus rectum
IC.OrbEl.period_sec         = OrbEl.period;         % Period of Orbit
IC.OrbEl.n_rps              = OrbEl.n;              % Mean Motion
IC.OrbEl.M_deg              = OrbEl.M;              % Mean Anomaly
IC.OrbEl.omega_defined_flg  = OrbEl.omega_defined;  % Argument of Perigee Defined
IC.OrbEl.RAAN_defined_flg   = OrbEl.RAAN_defined;   % RAAN Defined  

% IC.udot = 0;
% IC.vdot = 0;
% IC.wdot = 0;
% 
% IC.PbDot = 0;
% IC.QbDot = 0;
% IC.RbDot = 0;

end % << End of function CompleteOblateEarthEOMStates >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
