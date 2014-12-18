% GENERATEINITIALEOMSTATE3 define relative velocity to create IC struct for Oblate Earth EOM.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GenerateInitialEOMState3:
%     Creates the IC structure required for the Oblate Earth Equations of
%   Motion to initialize the integrators and for other miscellaneous uses.
%
% Velocity definition case #3
% ---------------------------
% 3.) Define the pure relative velocity components IC.Vrel_b = [u v w]
%       Usually for atmospheric flight with known velocity components
%       (no flight path definition used for velocity, but still required)
%
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "Alpha, Beta, 
% * and Mu" is a function name!
% * -JPG
% *************************************************************************
% SYNTAX:
%	[IC] = GenerateInitialEOMState3(mst, CentralBody, LLA, Vrel_b, ...
%               Alpha, Beta, Gamma, Chi, Mu, PQRb)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	mst 	        <size>		<units>		<Description>
%	CentralBody	<size>		<units>		<Description>
%	LLA 	        <size>		<units>		<Description>
%	Vrel_b	     <size>		<units>		<Description>
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
%	[IC] = GenerateInitialEOMState3(mst, CentralBody, LLA, Vrel_b, Alpha, Beta, Gamma, Chi, Mu, PQRb, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[IC] = GenerateInitialEOMState3(mst, CentralBody, LLA, Vrel_b, Alpha, Beta, Gamma, Chi, Mu, PQRb)
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
%	Source function: <a href="matlab:edit GenerateInitialEOMState3.m">GenerateInitialEOMState3.m</a>
%	  Driver script: <a href="matlab:edit Driver_GenerateInitialEOMState3.m">Driver_GenerateInitialEOMState3.m</a>
%	  Documentation: <a href="matlab:pptOpen('GenerateInitialEOMState3_Function_Documentation.pptx');">GenerateInitialEOMState3_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/388
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/GenerateInitialEOMState3.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [IC] = GenerateInitialEOMState3(mst, CentralBody, LLA, Vrel_b, Alpha, Beta, Gamma, Chi, Mu, PQRb)

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
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vrel_b= ''; LLA= ''; CentralBody= ''; mst= ''; 
%       case 1
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vrel_b= ''; LLA= ''; CentralBody= ''; 
%       case 2
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vrel_b= ''; LLA= ''; 
%       case 3
%        PQRb= ''; Mu= ''; Chi= ''; Gamma= ''; Beta= ''; Alpha= ''; Vrel_b= ''; 
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
IC.LLA = LLA;
IC.P_i = lla2eci( LLA, CentralBody.flatten, CentralBody.a, mst);
[IC.GeocentricLat, GD_lat, lon, alt] = eci2lla( IC.P_i, CentralBody.a, ...
    CentralBody.b, CentralBody.flatten, mst); % [length]
IC.P_f = eci2ecef( IC.P_i, mst );
IC.P_ned = ecef2ned( IC.P_f, LLA(1), LLA(2) );

% Initial Euler Orientation in NED frame from flight path and aero
% angles expressed in NED frame
IC.Gamma    = Gamma;    % [deg]
IC.Chi      = Chi;      % [deg]
IC.Mu       = Mu;       % [deg]
IC.Alpha    = Alpha;    % [deg]
IC.Beta     = Beta;     % [deg]

IC.Euler_ned= fp2euler(IC.Gamma, IC.Chi, IC.Mu, IC.Alpha, IC.Beta); % [deg]
IC.Euler_i  = eul_ned_2_eul_i( IC.LLA(1), IC.LLA(2), mst, IC.Euler_ned )';  % [deg]
IC.Euler_f  = eci2ecef( IC.Euler_i, mst );                          % [deg]

% Initial body rotation rates
IC.PQRb       = PQRb;   % [rad/s]

%% Convert EulerECI orientation into quaternion representation
IC.quat = eul2quaternion( IC.Euler_i * C.D2R );

% Calculate B:
IC.B = eul2dcm( IC.Euler_i * C.D2R );

% 3.) Define the pure relative velocity components IC.Vrel_b0 = [u v w]
%       Usually for atmospheric flight with known velocity components

IC.Vrel_b = Vrel_b;

% Calculate the Inertial Velocity from the Relative Velocity
IC.V_i = IC.B' * (IC.Vrel_b' + IC.B * (IC.CapOmegaE * IC.P_i'));

% Calculate Inertial Speed in NED frame:
IC.Speed_i  = norm(IC.Vi);

% Calculate V_ned from Vtrue / Gamma / Chi:
%   Note: Gamma and Chi are assumed to be [deg]:
IC.V_ned(1) = IC.Speed_i * cosd(IC.Gamma) * cosd(IC.Chi);
IC.V_ned(2) = IC.Speed_i * cosd(IC.Gamma) * sind(IC.Chi);
IC.V_ned(3) = IC.Speed_i * -sind(IC.Gamma);
IC.Vtrue  = norm(IC.Vrel_b);

% Calculate Standard Atmosphere Mach Number & Qbar
StdAtmos    = Coesa1976(LLA(3));
IC.Mach     = IC.Vtrue / StdAtmos.Sound;
IC.Qbar     = (1/2) * StdAtmos.Density * (IC.Vtrue^2);

%% Compile Outputs:
%	IC= -1;

end % << End of function GenerateInitialEOMState3 >>

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
