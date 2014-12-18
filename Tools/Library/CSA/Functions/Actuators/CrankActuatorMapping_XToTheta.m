% CRANKACTUATORMAPPING_XTOTHETA Crank Actuator Mapping Linear X Deflection to Surface Rotation
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CrankActuatorMapping_XToTheta:
%   This function is for use with linear actuators that are connected to
%   rotary control surfaces (like an elevator).  This 'crank function'
%   translates a linear actuator deflection, X, into a rotation angle,
%   Theta, assuming basic geometric constraints of the actuator and crank
%   lever arm.
% 
% SYNTAX:
%	[Theta_deg] = CrankActuatorMapping_XToTheta(X, R, C, L2, ThetaBias_deg, XBias)
%	[Theta_deg] = CrankActuatorMapping_XToTheta(X, R, C, L2, ThetaBias_deg)
%	[Theta_deg] = CrankActuatorMapping_XToTheta(X, R, C, L2)
%
% INPUTS: 
%	Name            Size		Units		Description
%	X               [varies]    [dist]      Linear actuator position
%	R               [1]         [dist]      Length of crank lever arm
%	C               [1]         [dist]      Length of the linear actuator
%   L2              [1]         [dist]      Distance between the pivot
%                                            points for the crank arm and
%                                            linear actuator
%   ThetaBias_deg   [1]         [deg]       Angle bias that Theta takes on
%                                            when X is in neutral state.
%                                            (Default is 0)
%   XBias           [1]         [dist]      Position bias when actuator is
%                                            in its neutral state.  When X
%                                            "reads" 0, XBias is 'actual
%                                            distance between clevis and
%                                            actuator attachment point'
%                                            (L1) - C (Default is 0)
% OUTPUTS: 
%	Name            Size		Units		Description
%	Theta_deg       [varies]    [deg]       Control surface deflection angle
%
% NOTES:
%	This function is vectorized, so 'X' can be a scalar or vector. Output
%	'Theta_deg' will carry same dimensions as 'X'.  Units for 'R',
%	'C', 'X', and 'L2' are not specified.  However, these 4 all must use 
%   the same distance unit, so standard English [ft] or Metric [m] should 
%   be used.
%
% EXAMPLES:
% % Example 1:
% % Plot the Deflection angle for a series of normalized (C/R) inputs:
% R = 1;                      % [dist]
% arr_C_over_R = [10 4 2];    % [non-dimensional]
% X = [-R : .01 : R];         % [dist]
% tbl_Theta_deg = zeros(length(X), length(arr_C_over_R));
% lstLegend = cell(length(arr_C_over_R), 1);
% 
% for i = 1:length(arr_C_over_R)
%     cur_C_over_R = arr_C_over_R(i); % [non-dimensional]
%     C = R * cur_C_over_R;           % [dist]
%     tbl_Theta_deg(:,i) = CrankActuatorMapping_XtoTheta(X, R, C)';
%     lstLegend(i,:) = {sprintf('C/R = %.0f', cur_C_over_R)};   
% end
% 
% figure();
% h = plot(X, tbl_Theta_deg, 'LineWidth', 1.5);
% xlabel('\bfNormalized Position, X/R [unitless]');
% ylabel('\bfTheta [deg]');
% grid on; set(gca, 'FontWeight', 'bold');
% title('\bf\fontsize{12}Crank Actuator Mapping - X to Theta');
% legend(h, lstLegend, 'Location', 'SouthEast');
%
% SOURCE DOCUMENTATION:
% [1]   Schley, Bill. "Actuator and Crank.pdf"  Internal NGC Document.
%       http://vodka.ccc.northgrum.com/svn/CSA/trunk/MATLABFunctionVerification/CrankActuatorMapping_XToTheta/Actuator_and_Crank.pdf
% [2]   Schley, Bill. "Extension_of_the_Crank_Function_Aanlysis_RevA.docx"  Internal NGC Document.
%       http://vodka.ccc.northgrum.com/svn/CSA/trunk/MATLABFunctionVerification/CrankActuatorMapping_XToTheta/Extension_of_the_Crank_Function_Aanlysis_RevA.docx
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CrankActuatorMapping_XToTheta.m">CrankActuatorMapping_XToTheta.m</a>
%	  Driver script: <a href="matlab:edit Driver_CrankActuatorMapping_XToTheta.m">Driver_CrankActuatorMapping_XToTheta.m</a>
%	  Documentation: <a href="matlab:pptOpen('CrankActuatorMapping_XToTheta_Function_Documentation.pptx');">CrankActuatorMapping_XToTheta_Function_Documentation.pptx</a>
%
% See also CrankActuatorMapping_ThetaToX 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/725
%  
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Actuators/CrankActuatorMapping_XToTheta.m $
% $Rev: 2242 $
% $Date: 2011-11-01 19:36:54 -0500 (Tue, 01 Nov 2011) $
% $Author: sufanmi $

function [Theta_deg] = CrankActuatorMapping_XToTheta(X, R, C, L2, ThetaBias_deg, XBias)

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
if((nargin < 4) || (nargin > 6))
    errstr = [mfnam '>> ERROR: Incorrect Number of Inputs. See ' mlink ' for more help.'];      % <-- Couple with error function
    error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string
end

if( (nargin < 5) || isempty(ThetaBias_deg) )
    ThetaBias_deg = 0;  % [deg]
end

if( (nargin < 6) || isempty(XBias) )
    XBias = 0;     % [dist]
end

%% Conversions:
R2D = 180.0/acos(-1);   % [rad] to [deg]

%% Main Function:
%  Alpha is the angle between R and L2
Alpha0_deg = acos( (R*R + L2*L2 - C*C)/(2*R*L2) )*R2D;
L1 = (X-XBias) + C;

Alpha_deg = acos( (R*R + L2*L2 - L1.*L1)./(2*R*L2) )*R2D;

Theta_deg = Alpha_deg - Alpha0_deg + ThetaBias_deg;

end % << End of function CrankActuatorMapping_XToTheta >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110822 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
