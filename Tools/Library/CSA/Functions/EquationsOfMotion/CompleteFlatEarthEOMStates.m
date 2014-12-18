% COMPLETEFLATEARTHEOMSTATES creates complete IC structure for flat central bodies
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CompleteFlatEarthEOMStates:
%   
% 
% SYNTAX:
%	[IC] = CompleteFlatEarthEOMStates(IC, CentralBody)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	IC  	    <size>		<units>		<Description>
%	CentralBody	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name            Size		Units           Description
%   IC          {structure}                     Vehicle's Initial States  
%                                               and Conditions
%       .P_i        [3x1]   [length]            Position in Central Body
%                                               Inertial Frame
%       .V_i        [3x1]   [length/sec]        Velocity in Central Body
%                                               Inertial Frame
%       .LLA        [3x1]   [deg deg length]    Geodetic Latitude/Longitude
%                                               /Altitude
%       .PQRb       [1x3]   [rad/sec]           Rotational velocity in  
%                                               Aircraft Body Frame
%       .V_f        [3x1]   [length/sec]        Initial Velocity in Central
%                                               Body Fixed Frame
%       .V_ned      [3x1]   [length/sec]        Velocity in North East Down
%                                               Frame
%       .Euler_ned  [3x1]   [rad]               Euler orientation in North 
%                                               East Down Frame
%       .Vrel_b     [3x1]   [length/sec]        Relative velocity in 
%                                               Aircraft Body Frame
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
%	[IC] = CompleteFlatEOMStates(IC, mst, CentralBody, varargin)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CompleteFlatEarthEOMStates.m">CompleteFlatEarthEOMStates.m</a>
%	  Driver script: <a href="matlab:edit Driver_CompleteFlatEarthEOMStates.m">Driver_CompleteFlatEarthEOMStates.m</a>
%	  Documentation: <a href="matlab:winopen(which('CompleteFlatEarthEOMStates_Function_Documentation.pptx'));">CompleteFlatEarthEOMStates_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/845
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/CompleteFlatEarthEOMStates.m $
% $Rev: 3128 $
% $Date: 2014-03-25 21:25:14 -0500 (Tue, 25 Mar 2014) $
% $Author: sufanmi $

function [IC] = CompleteFlatEarthEOMStates(IC, CentralBody, varargin)

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

%%
IC.P_ned_ft    = [0 0 -IC.Alt_msl_ft];

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

% Calculate Vrel_b from Vtrue / Alpha / Beta:
%   Note that Vtrue can be used for Flat Earth since there's no earth
%   rotation.
IC.Vrel_b_fps   = AlphaBetaVtrue2Vb(IC.Alpha_deg, IC.Beta_deg, IC.Vtas_fps)';   % [ft/sec]

% Calculate V_ned from Vtrue / Gamma / Chi:
IC.V_ned_fps    = GammaChiVtrue2Vned(IC.Gamma_deg, IC.Chi_deg, IC.Vtas_fps);   % [ft/sec]

% Calculate Standard Atmosphere Mach Number & Qbar
StdAtmos    = Coesa1976(IC.Alt_msl_ft, UseEnglishUnits, DeltaTemp);
IC.StdAtmos = StdAtmos;
IC.Mach     = IC.Vtas_fps / StdAtmos.Sound;
IC.Qbar_psf = (1/2) * StdAtmos.Density * (IC.Vtas_fps^2);

%%
IC.Euler_ned_deg = fp2euler(IC.Gamma_deg, IC.Chi_deg, IC.Mu_deg, IC.Alpha_deg, IC.Beta_deg); % [deg]

%% Finish Orientations:
IC.Quat_ned = eul2quaternion(IC.Euler_ned_deg * C.D2R);

% Point Mass Gravity:
[IC.Gmag_fpss, IC.G_ned_fpss] = Gravity_Flat( IC.Alt_msl_ft, CentralBody );
b_C_ned = eul2dcm(IC.Euler_ned_deg * C.D2R);
IC.G_b_fpss  = (b_C_ned * IC.G_ned_fpss')';

load    = b_C_ned * [0;0;-1];
IC.nx_g   =  load(1);
IC.ny_g   =  load(2);
IC.nz_g   = -load(3);

end % << End of function CompleteFlatEOMStates >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120717 MWS: Created function based on CompleteOblateEarthEOMStates
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
