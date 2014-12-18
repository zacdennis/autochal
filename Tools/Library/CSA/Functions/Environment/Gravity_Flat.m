% GRAVITY_FLAT Computes Gravity Magnitude assuming Flat Central Body
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gravity_Flat:
%     Computes Gravity Magnitude assuming Flat Central Body
% 
% SYNTAX:
%	[Gmag, G_ned] = Gravity_Flat(Alt, CentralBody)
%	[Gmag, G_ned] = Gravity_Flat(Alt)
%
% INPUTS: 
%	Name            Size		Units           Description
%	Alt             [1x1]       [length]        Altitude with respect to Flat
%	CentralBody     {struct}
%    .gm            [1x1]       [length^3/s^2]  Central Body Gravitational Constant
%    .MR            [1x1]       [length]        Mean Radius of Central Body
%
% OUTPUTS: 
%	Name            Size        Units          Description
%	Gmag            [1x1]       [length/s^2]    Magnitude of Gravity Vector
%   G_ned           [1x3]       [length/s^2]    Gravity Vector in North / East /
%                                               Down frame (e.g. flat earth
%                                               inertial frame)
% NOTES:
% This calculation is not unit specific.  Input distances only need to be
%   of a uniform unit.  Standard METRIC [m, m^3/s^2] or ENGLISH 
%   [ft, ft^3/s^2] distances should be used.
%
% If the CentralBody structure is NOT provided, a WGS-84 Earth is assumed 
% with METRIC inputs.  A mean radius (MR) of 6378e3 [m] and Graivtational 
% Constant (gm) of 398600.4418e9 [m^3/s^2] will then be used.
%
% This function is intended for use ONLY on simulations using flat central
% body equations of motion.  It is NOT for use on oblate central body
% simulations.
%
% EXAMPLES:
% 	Example 1: Compute the Gravity on Earth at an altitude of 1000 [m]
%   Alt = 1000;                     % [m]
% 	[Gmag, G_ned] = Gravity_Flat(Alt)
% 	Returns Gmag = 9.7956           % [m/sec^2]      
%           G_ned= [ 0 0 9.7956]    % [m/sec^2]
%
% 	Example 2: Compute the Gravity on Mars at an altitude of 2000 [m]
%   CentralBody.gm = 42828*10^9;    % [m^3/s^2]
%   CentralBody.MR = 3397*10^3;     % [m]
%   Alt = 2000;                     % [m]
% 	[Gmag, G_ned] = Gravity_Flat(Alt, CentralBody)
% 	Returns Gmag = 3.707            % [m/sec^2]
%           G_ned = [ 0 0 3.707]    % [m/sec^2]
%
% SOURCE DOCUMENTATION:
%	[1]    Sidi, Marcel J. Spacecraft Dynamics & Control, a Practical 
%          Engineering Approach. Cambridge University Press, New York, 
%          Copyright 1997 Pg.9 
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Gravity_Flat.m">Gravity_Flat.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gravity_Flat.m">Driver_Gravity_Flat.m</a>
%	  Documentation: <a href="matlab:pptOpen('Gravity_Flat_Function_Documentation.pptx');">Gravity_Flat_Function_Documentation.pptx</a>
%
% See also Gravity_PointMass
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/377
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Gravity_Flat.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Gmag, G_ned] = Gravity_Flat(Alt, CentralBody)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);
%% Input check
if nargin < 2
    CentralBody.MR=6378*10^3;%m
    CentralBody.gm=398600.4418*10^9; %m^3s^?2
end
if ischar(Alt)|| ischar(CentralBody)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end
%% Main Function:
R = Alt + CentralBody.MR;
Gmag = CentralBody.gm / (R*R);
G_ned = [0 0 Gmag];

end 
%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/ENVIRONMENT/Gravity_Flat.m
%**Add New Revision notes to TOP of list**

%% Initials Identification:
% INI: FullName         : Email                             : NGGN username
%  JJ: Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
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
