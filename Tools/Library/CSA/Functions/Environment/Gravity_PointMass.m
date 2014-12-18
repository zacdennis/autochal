% GRAVITY_POINTMASS Computes Gravity Magnitude and Vector assuming Point
%   Mass Pure Attraction
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Gravity_PointMass:
%     Computes Gravity Magnitude and Vector assuming Point Mass Pure
%     Attraction
% SYNTAX:
%	[Gmag, G_i] = Gravity_PointMass(P_i, CentralBody or GM)
%	[Gmag, G_i] = Gravity_PointMass(P_i)
%
% INPUTS: 
%	Name            Size            Units           Description
%	P_i             [1x3] or [3x1]  [length]        Position in Central
%                                                   Body Inertial
%	CentralBody		{struct}                        Central Body Structure
%    .gm             [1x1]          [length^3/s^2]  Gravitational Constant
%   GM              [1x1]           [length^3/s^2]  Central Body
%                                                    Gravitational Constant
%
% OUTPUTS: 
%	Name            Size            Units           Description
%	Gmag            [1x1]           [length/s^2]    Magnitude of Gravity Vector
%   G_i             [1x3] or [3x1]  [length/s^2]    Gravity Vector in Central 
%                                                    Body Inertial Frame
% NOTES:
%   This calculation is not unit specific.  Input distances only need to be
%   of a uniform unit.  Standard METRIC [m, m^3/s^2] or ENGLISH 
%   [ft, ft^3/s^2] distances should be used.
%
%   There are two different methods for specify the Central Body's
%   Gravitational Constant (GM), either via the CentralBody structure, or
%   by specifying it directly.  The the GM is not specified, the Earth is
%   assumed to be the central body and the WGS-84 Gravitational Constant of
%   3986004.418e8 [m^3/s^2] (Note METRIC) is utilized.
%
% EXAMPLES:
% 	Example 1: Compute the Gravity at 0 latitude/0 longitude on the Earth
%   Note that in these simplified equations converting Lat/Lon/Alt to P_i,
%   mean sidereal time is 0 and Earth is a sphere.
%   Alt = 0;            % [m]   Altitude over surface
%   Lat = 0;            % [deg] Geocentric Latitude
%   Lon = 0;            % [deg] Geocentric Longitude
%   MR  = 6371008.7714; % [m]   Earth's Mean Radius of Semi-axis
%   P_i(1) = (Alt+MR)*cosd(Lat)*cosd(Lon);  % [m]
%   P_i(2) = (Alt+MR)*cosd(Lat)*sind(Lon);  % [m]
%   P_i(3) = (Alt+MR)*sind(Lat)             % [m]
% 	[Gmag,G_i] = Gravity_PointMass(P_i)
%	Returns Gmag = 9.8202                   % [m/sec^2]
%           G_i = [-9.8202 0 0]             % [m/sec^2]
%
%   Example 2: Compute the Gravity at 0 lat/0 lon on the Moon
%   Alt = 0;            % [m]   Altitude over surface
%   Lat = 0;            % [deg] Geocentric Latitude
%   Lon = 0;            % [deg] Geocentric Longitude
%   MR  = 1737100.0;    % [m]   Moon's Mean Radius of Semi-axis
%   P_i(1) = (Alt+MR)*cosd(Lat)*cosd(Lon);      % [m]
%   P_i(2) = (Alt+MR)*cosd(Lat)*sind(Lon);      % [m]
%   P_i(3) = (Alt+MR)*sind(Lat)                 % [m]
%   CentralBody.gm = 4.902801056e12;            % [m^3/s^2]
%   [Gmag, G_i] = Gravity_PointMass(P_i, CentralBody)
%	Returns Gmag= 1.6248                        % [m/sec^2]
%           G_i =[-1.6248   0    0]             % [m/sec^2]
%
% SOURCE DOCUMENTATION:
%	[1] Sidi, Marcel J. Spacecraft Dynamics & Control, a Practical 
%        Engineering approach. Cambridge University Press, New York, 
%        Copyright 1997 Pg. 9 (eqn 2.1.4)
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Gravity_PointMass.m">Gravity_PointMass.m</a>
%	  Driver script: <a href="matlab:edit Driver_Gravity_PointMass.m">Driver_Gravity_PointMass.m</a>
%	  Documentation: <a href="matlab:pptOpen('Gravity_PointMass_Function_Documentation.pptx');">Gravity_PointMass_Function_Documentation.pptx</a>
%
% See also Gravity_Flat 
%
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/378
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/Gravity_PointMass.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Gmag,G_i] = Gravity_PointMass(P_i,CentralBody)

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
switch nargin
    case 0
        error([mfnam ':InputArgCheck'], ['Missing an Input. Must provide at last 1 input.  See ' ...
            mlink ' documentation for help.']);
    case 1
        GM = [];
    case 2
        % Nominal
        if(isstruct(CentralBody))
            % Input Form 1: Entering Central Body Structure
            GM = CentralBody.gm;
        else
            % Input Form 2: Inputting GM
            GM = CentralBody;
        end
end

if(isempty(GM))
    GM = 3986004.418e8;        % [m^3/s^2] WGS-84 Earth Gravitational Constant
end

if ischar(P_i)
     error([mfnam ':InputArgCheck'], 'Input of type string or CHAR. Must be expressed in scalar form.')
end

%% Main Function:
R = sqrt( P_i(1)*P_i(1) + P_i(2)*P_i(2) + P_i(3)*P_i(3) );  % [length]
Gmag = GM / (R*R);      % [length/sec^2]
G_i = -Gmag * P_i/R;    % [length/sec^2]

end

%% REVISION HISTORY
% YYMMDD INI: note
% 100909 JJ:  Filled the documentation source.
% 100819 JJ:  Function template created using CreateNewFunc
% 080114 MWS: Originally created function for VSI_LIB
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/ENVIRONMENT/Gravity_PointMass.m
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
