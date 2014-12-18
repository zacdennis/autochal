% GENERATEINITIALEOMSTATE2 define relative speed to create IC struct for Oblate Earth EOM.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GenerateInitialEOMState2:
% Velocity definition case #2
% ---------------------------
% 2.) Define relative speed IC.Vtrue = |IC.Vrel_b| and flight path
%       Usually used for atmospheric flight where vtrue is known
%
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "Alpha, Beta, 
% * and Mu" is a function name!
% * -JPG
% *************************************************************************
% 
% SYNTAX:
%	[IC] = GenerateInitialEOMState2(mst, CentralBody, LLA, Vtrue, Alpha, Beta, Gamma, Chi, Mu, PQRb)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	mst 	        <size>		<units>		<Description>
%	CentralBody	<size>		<units>		<Description>
%	LLA 	        <size>		<units>		<Description>
%	Vtrue	      <size>		<units>		<Description>
%	Alpha	      <size>		<units>		<Description>
%	Beta	       <size>		<units>		<Description>
%	Gamma	      <size>		<units>		<Description>
%	Chi 	        <size>		<units>		<Description>
%	Mu  	         <size>		<units>		<Description>
%	PQRb	       <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	IC  	         <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[IC] = GenerateInitialEOMState2(mst, CentralBody, LLA, Vtrue, Alpha, Beta, Gamma, Chi, Mu, PQRb, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = GenerateInitialEOMState2(mst, CentralBody, LLA, Vtrue, Alpha, Beta, Gamma, Chi, Mu, PQRb)
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
%	Source function: <a href="matlab:edit GenerateInitialEOMState2.m">GenerateInitialEOMState2.m</a>
%	  Driver script: <a href="matlab:edit Driver_GenerateInitialEOMState2.m">Driver_GenerateInitialEOMState2.m</a>
%	  Documentation: <a href="matlab:pptOpen('GenerateInitialEOMState2_Function_Documentation.pptx');">GenerateInitialEOMState2_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/387
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/GenerateInitialEOMState2.m $
% $Rev: 2326 $
% $Date: 2012-05-10 12:58:28 -0500 (Thu, 10 May 2012) $
% $Author: salluda $

function [IC] = GenerateInitialEOMState2(mst, CentralBody, LLA, Vtrue, Alpha, Beta, Gamma, Chi, Mu, PQRb)

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
%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vtrue= ''; LLA= ''; CentralBody= ''; mst= ''; 
%       case 1
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vtrue= ''; LLA= ''; CentralBody= ''; 
%       case 2
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vtrue= ''; LLA= ''; 
%       case 3
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vtrue= ''; 
%       case 4
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; 
%       case 5
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; 
%       case 6
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; 
%       case 7
%        PQRb= ''; Mu= ''; Chi= ''; 
%       case 8
%        PQRb= ''; Mu= ''; 
%       case 9
%        PQRb= ''; 
%       case 10
%        
%       case 11
%        
%  end
%
%  if(isempty(PQRb))
%		PQRb = -1;
%  end
%% Main Function:
conversions;

%% Tag structure as metric to reduce confusion:
IC.Units   = CentralBody.units;
IC.AngleTag = 'Angles are in [deg]; PQRb is in [rad/s]';

%% Convert Lat / Lon / Alt to Central Body Inertial Coordinates

IC.P_i      = lla2eci( LLA, CentralBody.flatten, CentralBody.a, mst); % [length]
IC.P_f      = eci2ecef( IC.P_i, mst );
IC.P_ned    = ecef2ned( IC.P_f, LLA(1), LLA(2) );

% Placeholders:
% These fields will be overwritten, but defining order now to keep output
% structure tidy.
IC.P_lvlh       = zeros(1,3);
IC.V_i          = zeros(1,3);
IC.V_f          = zeros(1,3);
IC.V_ned        = zeros(1,3);
IC.V_lvlh       = zeros(1,3);
IC.Speed_i      = 0;
IC.quat         = zeros(1,4);
IC.Euler_i      = zeros(1,3);
IC.Euler_f      = zeros(1,3);
IC.Euler_ned    = zeros(1,3);
IC.Euler_lvlh   = zeros(1,3);

% Initial body rotation rates
IC.PQRb       = PQRb;   % [rad/s]

IC.LLA = LLA;       % [deg deg length]
[IC.GeocentricLat, GD_lat, lon, alt] = eci2lla( IC.P_i, CentralBody.a, ...
    CentralBody.b, CentralBody.flatten, mst); % [length]

% Initial Euler Orientation in NED frame from flight path and aero
% angles expressed in NED frame
IC.Gamma    = Gamma;    % [deg]
IC.Chi      = Chi;      % [deg]
IC.Mu       = Mu;       % [deg]
IC.Alpha    = Alpha;    % [deg]
IC.Beta     = Beta;     % [deg]

IC.Euler_ned= fp2euler(IC.Gamma, IC.Chi, IC.Mu, IC.Alpha, IC.Beta); % [deg]

IC.Euler_i  = eul_ned_2_eul_i( IC.LLA(1), IC.LLA(2), mst, IC.Euler_ned )';  % [deg]
IC.quat = eul2quaternion( IC.Euler_i * C.D2R );
IC.B = eul2dcm( IC.Euler_i * C.D2R );

IC.Euler_f  = eci2ecef( IC.Euler_i, mst );                          % [deg]

% 2.) Define relative speed IC.Vtrue0 = |IC.Vrel_b0| and flight path
%       Usually for atmospheric flight [length/sec]
IC.Vtrue    = Vtrue;
IC.Vrel_b(1) = IC.Vtrue * cosd(IC.Beta) * cosd(IC.Alpha);
IC.Vrel_b(2) = IC.Vtrue * sind(IC.Beta);
IC.Vrel_b(3) = IC.Vtrue * cosd(IC.Beta) * sind(IC.Alpha);

% Calculate the Inertial Velocity from the Relative Velocity [length/sec]
IC.V_i = (IC.B' * (IC.Vrel_b' + IC.B * (CentralBody.OmegaE * IC.P_i')))';
IC.Speed_i  = norm(IC.V_i);

IC.V_f = IC.V_i - cross([0 0 CentralBody.rate], IC.P_f);
IC.V_ned = ecef2ned(IC.V_f, LLA(1), LLA(2));
IC.Euler_lvlh = eul_i_2_eul_lvlh(IC.P_i, IC.V_i, IC.Euler_i*C.D2R)' * C.R2D; % [deg]

b_C_lvlh = eul2dcm(IC.Euler_lvlh * C.D2R);
b_C_i    = eul2dcm(IC.Euler_i * C.D2R);
lvlh_C_i = (b_C_lvlh') * b_C_i;

IC.V_lvlh = (lvlh_C_i * IC.V_i')';
IC.P_lvlh = (lvlh_C_i * IC.P_i')';

% Calculate Standard Atmosphere Mach Number & Qbar
if(~strfind(lower(CentralBody.title), 'earth'))
    StdAtmos    = Coesa1976(LLA(3));
    IC.Mach     = IC.Vtrue / StdAtmos.Sound;
    IC.Qbar     = (1/2) * StdAtmos.Density * (IC.Vtrue^2);
end

%% Orbital Elements:
OE = PosVel2OrbEl(IC.P_i, IC.V_i, CentralBody.gm);
IC.a        = OE.a;         % [length]  Semi-major axis
IC.e        = OE.e;         % [ND]      Eccentricy
IC.theta    = OE.theta;     % [deg]     True Anomaly
IC.RAAN     = OE.RAAN;      % [deg]     Right Ascension Ascending Node
IC.i        = OE.i;         % [deg]     Inclination
IC.omega    = OE.omega;     % [deg]     Argument of the Perigee
IC.deltaT   = OE.deltaT;    % [sec]     Time since Perigee Passage
IC.capE     = OE.capE;      % [deg]     Eccentric Anomaly
IC.rp       = OE.rp;        % [length]  Radius of Perigee
IC.ra       = OE.ra;        % [length]  Radius of Apogee
IC.b        = OE.b;         % [length]  Semi-minor Axis
IC.P        = OE.P;         % [length]  Semi-latus rectum
IC.period   = OE.period;    % [sec]     Period of Orbit
IC.n        = OE.n;         % [rad/sec] Mean Motion
IC.M        = OE.M;         % [deg]     Mean Anomaly

%% Compile Outputs:
%	IC= -1;

end % << End of function GenerateInitialEOMState2 >>

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
