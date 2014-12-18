% CALCTURNRADIUS Computes the radius for a level turn
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CalcTurnRadius:
%     Computes the radius for a level turn given airspeed, gravity, and a
%     maximum roll angle.
% 
% SYNTAX:
%	[TurnRadius] = CalcTurnRadius(Vtrue, MaxPhi_deg, Gmag)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	Vtrue	    [1]         [varies]    True Airspeed
%	MaxPhi_deg	[1]         [deg]       Maximum Roll Angle
%	Gmag        [1]         [varies]    Acceleration of gravity
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	TurnRadius	[1]         [varies]    Radius of level turn
%
% NOTES:
%	Units for 'Vtrue' and 'Gmag' are not specified since function can work
%	for both METRIC and ENGLISH units.  If METRIC, 'Vtrue' will be [m/sec]
%	and 'Gmag' will be [m/sec^2].  If ENGLISH, 'Vtrue' will be [ft/sec] and
%	'Gmag' will be [ft/sec^2].
%
% EXAMPLES:
%	% Example 1: Sub-sonic turn radius
%   Vtrue_fps = 100;    % [ft/sec]
%   Gmag_fpss = 32.174; % [ft/sec^2]
%   MaxPhi_deg = 30;    % [deg]
%	[TurnRadius] = CalcTurnRadius(Vtrue_fps, MaxPhi_deg, Gmag_fpss)
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit TurnRadius.m">CalcTurnRadius.m</a>
%	  Driver script: <a href="matlab:edit Driver_CalcTurnRadius.m">Driver_CalcTurnRadius.m</a>
%	  Documentation: <a href="matlab:winopen(which('CalcTurnRadius_Function_Documentation.pptx'));">CalcTurnRadius_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/765
%  
% Copyright Northrop Grumman Corp 2012
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/DistanceCalculations/CalcTurnRadius.m $
% $Rev: 2504 $
% $Date: 2012-10-04 13:24:13 -0500 (Thu, 04 Oct 2012) $
% $Author: sufanmi $

function [TurnRadius] = CalcTurnRadius(Vtrue, MaxPhi_deg, Gmag)

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

%% Main Function:
MaxPhi_deg = abs(MaxPhi_deg);   % Make sure it's positive
if(MaxPhi_deg == 0)
    TurnRadius = 0; % Technically infinity
else
    TurnRadius = (Vtrue*Vtrue)/(tand(MaxPhi_deg)*Gmag);
end

end % << End of function CalcTurnRadius >>

%% REVISION HISTORY
% YYMMDD INI: note
% 121003 MWS: Created function using CreateNewFunc
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
