% CALCNEGRHAT  Computes the unit vector from the vehicle body to the center
% of the Central Body
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CalcNegRhat:
%     Computes the unit vector from the vehicle body to the center of the
%     Central Body
% 
% SYNTAX:
%	[negRhat] = CalcNegRhat(P_i, Euler_i)
%	[negRhat] = CalcNegRhat(P_i)
%
% INPUTS: 
%	Name		Size            Units		Description
%	P_i         [3xN]or[Nx3]    [length]	Inertial Position
%   Euler_i     [3xN]or[Nx3]    [deg]		Inertial Orientation
%	
% OUTPUTS: 
%	Name		Size            Units		Description
%	negRhat     [3xN]or[Nx3]    [ND]        Unit Vector from vehicle body to Central
%                                           Body, in vehicle body frame
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	Example 1:
%	[negRhat] = CalcNegRhat(P_i, Euler_i)
%	Returns
%
%	Example 1:
%	[negRhat] = CalcNegRhat(P_i, Euler_i)
%	Returns
%
% SOURCE DOCUMENTATION:
%	[1]    http://www...
%	[2]    Author. Book Title. Publisher, City, Copyright year
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit CalcNegRhat.m">CalcNegRhat.m</a>
%	  Driver script: <a href="matlab:edit Driver_CalcNegRhat.m">Driver_CalcNegRhat.m</a>
%	  Documentation: <a href="matlab:pptOpen('CalcNegRhat_Function_Documentation.pptx');">CalcNegRhat_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/318
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/CoordinateTransformations/CalcNegRhat.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [negRhat] = CalcNegRhat(P_i, Euler_i)

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

%% Input check
if ischar(P_i)||ischar(Euler_i)
    errstr = [mfnam tab 'ERROR: Input of type CHAR. Please input the angles in scalar form' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
h = size(Euler_i);
if ((h(1)>3) && (h(1) ~= 3))||((h(2)>3) && (h(2) ~= 3))
    errstr = [mfnam tab 'ERROR: Euler angles must be [1x3] or [3x1]' ];
    error([mfnam 'class:file:Identifier'],errstr);
end
%% Main Function:
conversions; 
i2b = eul2dcm(Euler_i * C.D2R);

[nrow, ncol] = size(P_i);
if(ncol > nrow)
    negRhat = -unitv(i2b * P_i')';
else
    negRhat = -unitv(i2b * P_i);
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100913 JJ:  Generated 2 examples.
% 100819 JJ:  Function template created using CreateNewFunc
% 080118 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/COORDINATE_TRANSFORMATIONS/CalcNegRhat.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN Username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : G67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

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
