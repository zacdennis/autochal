% SPINNINGMACHINERYTORQUE Compute torque on a rigid body given a 2-axis gimbaled spinning machinery
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SpinningMachineryTorque:
%     <Function Description> 
% 
% SYNTAX:
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz, varargin, 'PropertyName', PropertyValue)
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz, varargin)
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz)
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix)
%
% INPUTS: 
%	Name         	Size	Units           Description
%   OMEGA           [1x1]   [rad/sec]       Spinning Machinery Angular Velocity
%   OMEGADot        [1x1]   [rad/sec^2]     Spinning Machinery Angular 
%                                           Acceleration
%   AlphaBeta       [2x1]   [rad]           Gimbal Angles [alpha; beta]
%   AlphaBetaDot    [2x1]   [rad/sec]       Gimbal Angles Rate [alphad; betad]
%   AlphaBetaDDot   [2x1]   [rad/sec^2]     Gimbal Angles Acceleration 
%                                           [alphadd; yawdd]
%   PQR             [3x1]   [rad/sec]       Vehicle Body Angular Rate
%   PQRDot          [3x1]   [rad/sec^2]     Vehicle Body Angular Acceleration
%   Ix              [1x1]   [mass*length^2] Machinery Moment of Inertia about 
%                                           Gimbal Axes (same as Iy; 
%                                           considered rotating cylinder)
%   Iz              [1x1]   [mass*length^2] Machinery Moment of Inertia about
%                                           Gimbal Axes (about the rotation, 
%                                           OMEGA,axes)
%
% OUTPUTS: 
%	Name         	Size	Units           Description
%   LMN_b           [3x1]   [force*length]  Body-Axis Torque Due to Spinning 
%                                           Machinery
%   lmn_G           [3x1]   [force*length]  Gimbal-Axis Torque
%
% NOTES:
%	The units of inertia are mass-length^2 so as to allow input in any
%   units. LMN outputs will be in units corresponding to input Ix & Iz.
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% Primarily Spacecraft Variable Speed Control Moment Gyro (VSCMG) Formulations
% [1] "A GYRO MOMENTUM EXCHANGE DEVICE FOR SPACE VEHICLE ATTITUDE CONTROL";
% KENNEDY, H. B.; AIAA Journal 1963; 0001-1452 vol.1 no.5 (1110-1118);
% Northrop Space Laboratories; Hawthorne, CA - AIAA-1732-313 or AIAA-1732-986
% [2] "A Two-Degree-of-Freedom Control Moment Gyro for High-Accuracy
% Attitude Control"; LISKA, D. J. CALIFORNIA, U., LOS ALAMOS SCIENTIFIC LAB.,
% PHYSICS DIV., LOS ALAMOS, NM; JOURNAL OF SPACECRAFT AND ROCKETS 1968
% 0022-4650 vol.5 no.1 (74-83) - AIAA-29188-354
% [3] "Analytical Mechanics of Space Systems";
% Hanspeter Schaub, Virginia Polytechnic Inst and State University;
% John L. Junkins, Texas A&M University; AIAA Education Series;
% 2003; ISBN-10: 1-56347-563-4 
% [4] "Spacecraft Dynamics and Control";
% Sidi M. J.; Cambridge University Press 1997
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SpinningMachineryTorque.m">SpinningMachineryTorque.m</a>
%	  Driver script: <a href="matlab:edit Driver_SpinningMachineryTorque.m">Driver_SpinningMachineryTorque.m</a>
%	  Documentation: <a href="matlab:pptOpen('SpinningMachineryTorque_Function_Documentation.pptx');">SpinningMachineryTorque_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/472
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Actuators/SpinningMachineryTorque.m $
% $Rev: 1713 $
% $Date: 2011-05-11 15:12:26 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [LMN_b, lmn_G] = SpinningMachineryTorque(OMEGA, OMEGADot, AlphaBeta, AlphaBetaDDot, PQR, PQRDot, Ix, Iz)

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
LMN_b= -1;
lmn_G= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Iz= ''; Ix= ''; PQRDot= ''; PQR= ''; AlphaBetaDDot= ''; AlphaBeta= ''; OMEGADot= ''; OMEGA= ''; 
%       case 1
%        Iz= ''; Ix= ''; PQRDot= ''; PQR= ''; AlphaBetaDDot= ''; AlphaBeta= ''; OMEGADot= ''; 
%       case 2
%        Iz= ''; Ix= ''; PQRDot= ''; PQR= ''; AlphaBetaDDot= ''; AlphaBeta= ''; 
%       case 3
%        Iz= ''; Ix= ''; PQRDot= ''; PQR= ''; AlphaBetaDDot= ''; 
%       case 4
%        Iz= ''; Ix= ''; PQRDot= ''; PQR= ''; 
%       case 5
%        Iz= ''; Ix= ''; PQRDot= ''; 
%       case 6
%        Iz= ''; Ix= ''; 
%       case 7
%        Iz= ''; 
%       case 8
%        
%       case 9
%        
%  end
%
%  if(isempty(Iz))
%		Iz = -1;
%  end

alpha = AlphaBeta(1);
beta  = AlphaBeta(2);

alpha1 = AlphaBetaDot(1);
beta1  = AlphaBetaDot(2);

alpha2 = AlphaBetaDDot(1);
beta2  = AlphaBetaDDot(2);

p = PQR(1);
q = PQR(2);
r = PQR(3);

p1 = PQRDot(1);
q1 = PQRDot(2);
r1 = PQRDot(3);

%% Main Function:

%% Compute Moments in the Gimbal Frame:
Mx = -Iz * OMEGA * (alpha1 * sin(beta) - (p * sin(alpha) + q * cos(alpha)) * cos(beta) - r * sin(beta) )...
    - Ix * (beta2 + p1 * cos(alpha) - p * alpha1 * sin(alpha) - q1 * sin(alpha) - q * alpha1 * cos(alpha) );

My = Iz * OMEGA * (beta1 + p * cos(alpha) - q * sin(alpha) )...
    - Ix * (alpha2 * sin(beta) + alpha1 * beta1 * cos(beta) - p1 * sin(alpha) * cos(beta)...
    - p * (alpha1 * cos(alpha) * cos(beta) - beta1 * sin(alpha) * sin(beta) )...
    - q1 * cos(alpha) * cos(beta) + q * (alpha1 * sin(alpha) * cos(beta) + beta1 * cos(alpha) * sin(beta) )...
    - r1 * sin(beta) - r * beta1 * cos(beta) );

Mz = -Iz * (OMEGADot + alpha2 * cos(beta) - alpha1 * beta1 * sin(beta) + ...
    p * (alpha1 * cos(alpha) * sin(beta) + beta1 * sin(alpha) * cos(beta) )...
    + p1 * sin(alpha) * sin(beta) + q * (beta1 * cos(alpha) * cos(beta) - ...
    alpha1 * sin(alpha) * sin(beta) )...
    + q1 * cos(alpha) * sin(beta) + r * beta1 * sin(beta) - r1 * cos(beta) );

lmn_G = [Mx; My; Mz];

%% Transform to the body frame:
LMN_b = [-My * cos(beta) * sin(alpha) + Mx * cos(alpha) + Mz * sin(beta) * sin(alpha);
    -My * cos(beta) * cos(alpha) - Mx * sin(alpha) + Mz * sin(beta) * cos(alpha);
    -My * sin(beta) - Mz * cos(beta) ];

%% Compile Outputs:
%	LMN_b= -1;
%	lmn_G= -1;

end % << End of function SpinningMachineryTorque >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
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
