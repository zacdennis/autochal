% FP2EULER  Flight Path and Aerodynamic Angles to Euler NED Angles
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% fp2euler:
% Converts the aerodynamic angles (Alpha and Beta) and flight path angles
% (Gamma, Chi, Mu) to the Euler Angles with respect to the the NED frame.
%  
% SYNTAX:
%	[Euler_ned_deg] = fp2euler(Gamma_deg, Chi_deg, Mu_deg, Alpha_deg, Beta_deg)
%
% INPUTS: 
%	Name            Size       	   Units	Description
%   Gamma_deg       [1xN] or [Nx1] [deg]    Vertical Flight Path Angle
%   Chi_deg         [1xN] or [Nx1] [deg]    Flight Path AziMu_degth Angle (Heading)
%   Mu_deg          [1xN] or [Nx1] [deg]    Flight Path Roll (bank) Angle
%   Alpha_deg       [1xN] or [Nx1] [deg]    Angle of Attack
%   Beta_deg        [1xN] or [Nx1] [deg]    Angle of Sideslip
%
% OUTPUTS: 
%	Name            Size           Units	Description
%	Euler_ned_deg   [3xN] or [Nx3] [deg]    Euler Angles w.r.t. 
%                                            North/East/Down Frame
%
% NOTES:
%   Inputs of Gamma_deg and Alpha_deg are assumed to be limited to +/- 90 deg.
%   Inputs of Chi_deg and Mu_deg are assumed to be -180deg <= Chi_deg,Mu_deg < 180 deg.
%   Input Beta_deg is assumed to be -180deg < Beta_deg <= 180 deg.
%   Out of bound inputs will be wrapped by the Matlab trig functions (cos,
%   sin, atan2, and asin) and the outputs will be valid Euler_ned_deg angles
%
%   Output Euler_ned_deg angles will be within +/- 90 deg for theta, and +/-180 deg
%   for phi and psi.
%
%   For example, this means that an input of 95 deg Gamma_deg and 0 for all
%   other angles will generate Euler_ned_deg angles of [-180 85 180] and will not 
%   result in [0 95 0]
%
% EXAMPLES:
%   % Example 1: Single Input Form
%   Gamma_deg = 0; Chi_deg = 90; Mu_deg = 0; Alpha_deg = 45; Beta_deg = 0;
% 	[Euler_ned_deg] = fp2euler(Gamma_deg, Chi_deg, Mu_deg, Alpha_deg, Beta_deg)
%	% Returns Euler_ned_deg = [0.0   45.0  -90.0]
%
%   % Example 2: Testing at Singularities (Gamma)
%   Gamma_deg = 90; Chi_deg = 180; Mu_deg = 0; Alpha_deg = 0; Beta_deg = 0;
% 	[Euler_ned_deg] = fp2euler(Gamma_deg, Chi_deg, Mu_deg, Alpha_deg, Beta_deg)
%	% Returns Euler_ned_deg = [0.0   90.0  180.0]
%
% SOURCE DOCUMENTATION:
%	[1]    Kalviste, Juri. Flight Dynamics Reference Book. 
%           Northrop Grumman, Aircraft division. rev 06-30-89 1988 P.8
% HYPERLINKS:
%	Source function: <a href="matlab:edit fp2euler.m">fp2euler.m</a>
%	  Driver script: <a href="matlab:edit Driver_fp2euler.m">Driver_fp2euler.m</a>
%	  Documentation: <a href="matlab:pptOpen('fp2euler_Function_Documentation.pptx');">fp2euler_Function_Documentation.pptx</a>
%
% See also eul2dcm 
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/342
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/fp2euler.m $
% $Rev: 3114 $
% $Date: 2014-03-24 21:51:31 -0500 (Mon, 24 Mar 2014) $
% $Author: sufanmi $

function [Euler_ned_deg] = fp2euler(Gamma_deg, Chi_deg, Mu_deg, Alpha_deg, Beta_deg)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);
%% Input check

if ischar(Gamma_deg)||ischar(Chi_deg)||ischar(Mu_deg)||ischar(Alpha_deg)||ischar(Beta_deg)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end

if length(Gamma_deg)~=length(Chi_deg)||length(Mu_deg)~=length(Alpha_deg)||length(Beta_deg)~=length(Gamma_deg)
     error([mfnam ':InputArgCheck'], ['Inputs Mu_degst be of same length! See ' mlink ' documentation for help.']);
end
    
%% Main Function:
R2D = 180.0/acos(-1);
D2R = 1/R2D;

Gamma_rad   = Gamma_deg * D2R;
Chi_rad     = Chi_deg * D2R;
Mu_rad      = Mu_deg * D2R;
Alpha_rad   = Alpha_deg * D2R;
Beta_rad    = Beta_deg * D2R;

Phi_num = (cos(Gamma_rad).*sin(Mu_rad).*cos(Beta_rad) - sin(Gamma_rad).*sin(Beta_rad));
Phi_den = (cos(Gamma_rad).*cos(Mu_rad).*cos(Alpha_rad)-sin(Gamma_rad).*sin(Alpha_rad).*cos(Beta_rad)...
             -cos(Gamma_rad).*sin(Mu_rad).*sin(Alpha_rad).*sin(Beta_rad));
Phi_ned_deg = atan2(Phi_num, Phi_den) * R2D;
      
Theta_ned_deg = asin( cos(Gamma_rad).*cos(Mu_rad).*sin(Alpha_rad) + sin(Gamma_rad).*cos(Alpha_rad).*cos(Beta_rad) ...
            + cos(Gamma_rad).*sin(Mu_rad).*cos(Alpha_rad).*sin(Beta_rad)) .* R2D;

Psi_num = (sin(Mu_rad).*sin(Alpha_rad)-cos(Mu_rad).*cos(Alpha_rad).*sin(Beta_rad)).*cos(Chi_rad)...
             +(-sin(Gamma_rad).*cos(Mu_rad).*sin(Alpha_rad)+cos(Gamma_rad).*cos(Alpha_rad).*cos(Beta_rad)...
             -sin(Gamma_rad).*sin(Mu_rad).*cos(Alpha_rad).*sin(Beta_rad)).*sin(Chi_rad);
Psi_den =  (-sin(Gamma_rad).*cos(Mu_rad).*sin(Alpha_rad)+cos(Gamma_rad).*cos(Alpha_rad).*cos(Beta_rad)...
             -sin(Gamma_rad).*sin(Mu_rad).*cos(Alpha_rad).*sin(Beta_rad)).*cos(Chi_rad)...
             -(sin(Mu_rad).*sin(Alpha_rad)-cos(Mu_rad).*cos(Alpha_rad).*sin(Beta_rad)).*sin(Chi_rad);
Psi_ned_deg = atan2(Psi_num, Psi_den) .* R2D;

% Return row arrays if input is in row array
if size(Gamma_deg,1)< size(Gamma_deg,2)
    Euler_ned_deg = [Phi_ned_deg; Theta_ned_deg; Psi_ned_deg];
else
    Euler_ned_deg = [Phi_ned_deg Theta_ned_deg Psi_ned_deg];
end

end 

%% Author Identification:
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
